import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/injection_container.dart';
import '../models/youtube_video.dart';
import '../services/youtube_service.dart';

class YouTubeState {
  final List<YouTubeVideo> videos;
  final bool isLoading;
  final String? error;
  final String searchQuery;

  const YouTubeState({
    this.videos = const [],
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
  });

  YouTubeState copyWith({
    List<YouTubeVideo>? videos,
    bool? isLoading,
    String? error,
    String? searchQuery,
    bool clearError = false,
  }) {
    return YouTubeState(
      videos: videos ?? this.videos,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class YouTubeViewModel extends StateNotifier<YouTubeState> {
  final YouTubeService _service;

  YouTubeViewModel(this._service) : super(const YouTubeState()) {
    loadTrending();
  }

  Future<void> loadTrending() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final videos = await _service.getTrending();
      state = state.copyWith(videos: videos, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load trending videos',
      );
    }
  }

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      loadTrending();
      return;
    }

    state = state.copyWith(isLoading: true, searchQuery: query, clearError: true);
    try {
      final videos = await _service.search(query);
      state = state.copyWith(videos: videos, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Search failed. Please try again.',
      );
    }
  }

  Future<void> loadFreeMovies() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final videos = await _service.getFreeMovies();
      state = state.copyWith(videos: videos, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load free movies',
      );
    }
  }

  Future<String?> getStreamUrl(String videoId) async {
    return await _service.getStreamUrl(videoId);
  }
}

final youtubeProvider =
    StateNotifierProvider.autoDispose<YouTubeViewModel, YouTubeState>((ref) {
  return YouTubeViewModel(sl<YouTubeService>());
});
