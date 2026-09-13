import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart' show VideoController;
import '../../../core/utils/logger.dart';

class PlayerState {
  final Player? player;
  final VideoController? controller;
  final bool isInitialized;
  final bool isPlaying;
  final bool isFullScreen;
  final Duration position;
  final Duration duration;
  final double volume;
  final bool isMuted;
  final double playbackSpeed;
  final bool showControls;
  final bool hasError;
  final String? errorMessage;
  final bool isLoading;

  const PlayerState({
    this.player,
    this.controller,
    this.isInitialized = false,
    this.isPlaying = false,
    this.isFullScreen = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.volume = 1.0,
    this.isMuted = false,
    this.playbackSpeed = 1.0,
    this.showControls = true,
    this.hasError = false,
    this.errorMessage,
    this.isLoading = true,
  });

  PlayerState copyWith({
    Player? player,
    VideoController? controller,
    bool? isInitialized,
    bool? isPlaying,
    bool? isFullScreen,
    Duration? position,
    Duration? duration,
    double? volume,
    bool? isMuted,
    double? playbackSpeed,
    bool? showControls,
    bool? hasError,
    String? errorMessage,
    bool? isLoading,
  }) {
    return PlayerState(
      player: player ?? this.player,
      controller: controller ?? this.controller,
      isInitialized: isInitialized ?? this.isInitialized,
      isPlaying: isPlaying ?? this.isPlaying,
      isFullScreen: isFullScreen ?? this.isFullScreen,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      volume: volume ?? this.volume,
      isMuted: isMuted ?? this.isMuted,
      playbackSpeed: playbackSpeed ?? this.playbackSpeed,
      showControls: showControls ?? this.showControls,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class PlayerViewModel extends StateNotifier<PlayerState> {
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<Duration>? _durationSub;
  StreamSubscription<bool>? _playingSub;
  StreamSubscription<bool>? _completedSub;

  PlayerViewModel() : super(const PlayerState());

  Future<void> initialize(String url) async {
    state = state.copyWith(isLoading: true, hasError: false, errorMessage: null);

    try {
      final player = Player();
      final controller = VideoController(player);

      state = state.copyWith(player: player, controller: controller);

      _positionSub = player.stream.position.listen((position) {
        if (mounted) {
          state = state.copyWith(position: position);
        }
      });

      _durationSub = player.stream.duration.listen((duration) {
        if (mounted) {
          state = state.copyWith(duration: duration);
        }
      });

      _playingSub = player.stream.playing.listen((playing) {
        if (mounted) {
          state = state.copyWith(isPlaying: playing);
        }
      });

      _completedSub = player.stream.completed.listen((completed) {
        if (completed && mounted) {
          state = state.copyWith(isPlaying: false);
        }
      });

      await player.open(Media(url));

      state = state.copyWith(
        isInitialized: true,
        isPlaying: true,
        isLoading: false,
      );

      AppLogger.info('Player initialized: ${url.substring(0, url.length < 80 ? url.length : 80)}...');
    } catch (e) {
      AppLogger.error('Failed to initialize player', error: e);
      state = state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: 'Failed to load stream. The URL may be invalid or the stream is offline.',
      );
    }
  }

  void play() {
    state.player?.play();
    state = state.copyWith(isPlaying: true);
  }

  void pause() {
    state.player?.pause();
    state = state.copyWith(isPlaying: false);
  }

  void togglePlayPause() {
    if (state.isPlaying) {
      pause();
    } else {
      play();
    }
  }

  void seekTo(Duration position) {
    state.player?.seek(position);
  }

  void seekForward([int seconds = 10]) {
    final target = state.position + Duration(seconds: seconds);
    seekTo(target > state.duration ? state.duration : target);
  }

  void seekBackward([int seconds = 10]) {
    final target = state.position - Duration(seconds: seconds);
    seekTo(target < Duration.zero ? Duration.zero : target);
  }

  void setVolume(double volume) {
    final clamped = volume.clamp(0.0, 1.0);
    state.player?.setVolume(clamped * 100);
    state = state.copyWith(volume: clamped, isMuted: clamped == 0);
  }

  void toggleMute() {
    final muted = !state.isMuted;
    state.player?.setVolume(muted ? 0 : state.volume * 100);
    state = state.copyWith(isMuted: muted);
  }

  void increaseVolume() {
    setVolume((state.volume + 0.1).clamp(0.0, 1.0));
  }

  void decreaseVolume() {
    setVolume((state.volume - 0.1).clamp(0.0, 1.0));
  }

  Future<void> switchChannel(String url) async {
    await _disposeStreams();
    final oldPlayer = state.player;
    if (oldPlayer != null) {
      await oldPlayer.stop();
      await oldPlayer.dispose();
    }
    state = state.copyWith(
      player: null,
      controller: null,
      isInitialized: false,
      isPlaying: false,
      position: Duration.zero,
      duration: Duration.zero,
      hasError: false,
      errorMessage: null,
      isLoading: true,
      showControls: true,
    );
    await initialize(url);
  }

  void setPlaybackSpeed(double speed) {
    final clamped = speed.clamp(0.25, 2.0);
    state.player?.setRate(clamped);
    state = state.copyWith(playbackSpeed: clamped);
  }

  void toggleFullScreen() {
    state = state.copyWith(isFullScreen: !state.isFullScreen);
  }

  void showControls() {
    state = state.copyWith(showControls: true);
  }

  void hideControls() {
    state = state.copyWith(showControls: false);
  }

  void toggleControls() {
    state = state.copyWith(showControls: !state.showControls);
  }

  Future<void> retry(String url) async {
    await _disposeStreams();
    final oldPlayer = state.player;
    if (oldPlayer != null) {
      await oldPlayer.stop();
      await oldPlayer.dispose();
    }
    state = const PlayerState();
    await initialize(url);
  }

  Future<void> _disposeStreams() async {
    await _positionSub?.cancel();
    await _durationSub?.cancel();
    await _playingSub?.cancel();
    await _completedSub?.cancel();
    _positionSub = null;
    _durationSub = null;
    _playingSub = null;
    _completedSub = null;
  }

  @override
  void dispose() {
    _disposeStreams();
    state.player?.stop();
    state.player?.dispose();
    super.dispose();
  }
}

final playerViewModelProvider =
    StateNotifierProvider.autoDispose<PlayerViewModel, PlayerState>((ref) {
  return PlayerViewModel();
});
