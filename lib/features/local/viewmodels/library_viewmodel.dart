import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/injection_container.dart';
import '../models/local_video.dart';
import '../models/media_folder.dart';
import '../services/media_scanner.dart';
import '../services/permission_service.dart';
import '../repositories/local_repository.dart';

class LibraryState {
  final List<LocalVideo> videos;
  final List<MediaFolder> folders;
  final List<LocalVideo> recentlyWatched;
  final bool isLoading;
  final bool hasPermission;
  final String? error;

  const LibraryState({
    this.videos = const [],
    this.folders = const [],
    this.recentlyWatched = const [],
    this.isLoading = false,
    this.hasPermission = false,
    this.error,
  });

  LibraryState copyWith({
    List<LocalVideo>? videos,
    List<MediaFolder>? folders,
    List<LocalVideo>? recentlyWatched,
    bool? isLoading,
    bool? hasPermission,
    String? error,
    bool clearError = false,
  }) {
    return LibraryState(
      videos: videos ?? this.videos,
      folders: folders ?? this.folders,
      recentlyWatched: recentlyWatched ?? this.recentlyWatched,
      isLoading: isLoading ?? this.isLoading,
      hasPermission: hasPermission ?? this.hasPermission,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class LibraryViewModel extends StateNotifier<LibraryState> {
  final MediaScanner _scanner;
  final PermissionService _permission;
  final LocalRepository _repository;

  LibraryViewModel(this._scanner, this._permission, this._repository)
      : super(const LibraryState()) {
    _init();
  }

  Future<void> _init() async {
    final hasPermission = await _permission.hasVideoPermission();
    state = state.copyWith(hasPermission: hasPermission);
    if (hasPermission) {
      await refresh();
    }
  }

  Future<void> requestPermission() async {
    final granted = await _permission.requestAllPermissions();
    state = state.copyWith(hasPermission: granted);
    if (granted) {
      await refresh();
    }
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final results = await Future.wait([
        _scanner.scanAllVideos(),
        _scanner.scanFolders(),
      ]);

      final videos = results[0] as List<LocalVideo>;
      final folders = results[1] as List<MediaFolder>;

      final history = _repository.getWatchHistory();
      final enrichedVideos = videos.map((v) {
        final historyItem = history.firstWhere(
          (h) => h.id == v.id,
          orElse: () => v,
        );
        return v.copyWith(
          lastPosition: historyItem.lastPosition,
          isFullyWatched: historyItem.isFullyWatched,
        );
      }).toList();

      state = state.copyWith(
        videos: enrichedVideos,
        folders: folders,
        recentlyWatched: history.take(20).toList(),
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to scan media',
      );
    }
  }

  Future<void> updatePlaybackPosition(String videoId, Duration position, Duration total) async {
    await _repository.saveResumePosition(videoId, position);
    final isFullyWatched = total.inSeconds > 0 && position.inSeconds >= total.inSeconds - 5;
    final video = state.videos.firstWhere(
      (v) => v.id == videoId,
      orElse: () => state.videos.first,
    );
    final updated = video.copyWith(lastPosition: position, isFullyWatched: isFullyWatched);
    await _repository.saveWatchHistory(updated);

    final updatedVideos = state.videos.map((v) => v.id == videoId ? updated : v).toList();
    state = state.copyWith(videos: updatedVideos);
  }

  Future<void> removeFromHistory(String videoId) async {
    await _repository.removeWatchHistory(videoId);
    state = state.copyWith(
      recentlyWatched: state.recentlyWatched.where((v) => v.id != videoId).toList(),
    );
  }

  Future<void> clearHistory() async {
    await _repository.clearHistory();
    state = state.copyWith(recentlyWatched: []);
  }

  List<LocalVideo> getVideosInFolder(String folderPath) {
    return state.videos.where((v) => v.folderPath == folderPath).toList();
  }
}

final libraryProvider =
    StateNotifierProvider<LibraryViewModel, LibraryState>((ref) {
  return LibraryViewModel(
    sl<MediaScanner>(),
    sl<PermissionService>(),
    sl<LocalRepository>(),
  );
});

final folderVideosProvider =
    Provider.family<List<LocalVideo>, String>((ref, folderPath) {
  final libState = ref.watch(libraryProvider);
  return libState.videos.where((v) => v.folderPath == folderPath).toList();
});
