import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:file_picker/file_picker.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/di/injection_container.dart';
import '../models/local_video.dart';
import '../repositories/local_repository.dart';
import '../widgets/track_picker.dart';

class LocalPlayerView extends ConsumerStatefulWidget {
  final LocalVideo video;
  const LocalPlayerView({super.key, required this.video});

  @override
  ConsumerState<LocalPlayerView> createState() => _LocalPlayerViewState();
}

class _LocalPlayerViewState extends ConsumerState<LocalPlayerView> with WidgetsBindingObserver {
  late Player _player;
  late VideoController _controller;
  bool _isLoading = true;
  bool _hasError = false;
  String? _errorMsg;
  bool _showControls = true;
  bool _isFullScreen = false;

  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _isPlaying = false;
  List<AudioTrack> _audioTracks = [];
  List<SubtitleTrack> _subtitleTracks = [];
  AudioTrack? _currentAudio;
  SubtitleTrack? _currentSubtitle;

  @override
  void initState() {
    super.initState();
    _player = Player();
    _controller = VideoController(_player);
    WidgetsBinding.instance.addObserver(this);
    WakelockPlus.enable();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    try {
      _player.stream.position.listen((p) {
        if (mounted) setState(() => _position = p);
      });
      _player.stream.duration.listen((d) {
        if (mounted) setState(() => _duration = d);
      });
      _player.stream.playing.listen((p) {
        if (mounted) setState(() => _isPlaying = p);
      });
      _player.stream.tracks.listen((t) {
        if (mounted) {
          setState(() {
            _audioTracks = t.audio;
            _subtitleTracks = t.subtitle;
          });
        }
      });
      _player.stream.track.listen((t) {
        if (mounted) {
          setState(() {
            _currentAudio = t.audio;
            _currentSubtitle = t.subtitle;
          });
        }
      });

      final resumePos = sl<LocalRepository>().getResumePosition(widget.video.id);

      await _player.open(Media('file:///${widget.video.path}'));
      if (resumePos > Duration.zero && resumePos < _duration) {
        await _player.seek(resumePos);
      }

      setState(() { _isLoading = false; });
    } catch (e) {
      setState(() { _isLoading = false; _hasError = true; _errorMsg = e.toString(); });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) _player.pause();
    if (state == AppLifecycleState.resumed) _player.play();
  }

  @override
  void dispose() {
    sl<LocalRepository>().saveResumePosition(widget.video.id, _position);
    _player.pause();
    _player.stop();
    _player.dispose();
    WidgetsBinding.instance.removeObserver(this);
    WakelockPlus.disable();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return h > 0 ? '$h:$m:$s' : '$m:$s';
  }

  void _toggleFullScreen() {
    setState(() => _isFullScreen = !_isFullScreen);
    if (_isFullScreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
  }

  void _showTrackPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => TrackPicker(
        audioTracks: _audioTracks,
        currentAudio: _currentAudio,
        subtitleTracks: _subtitleTracks,
        currentSubtitle: _currentSubtitle,
        onAudioSelected: (t) => _player.setAudioTrack(t),
        onSubtitleSelected: (t) => _player.setSubtitleTrack(t),
        onLoadExternalSubtitle: _loadExternalSubtitle,
      ),
    );
  }

  Future<void> _loadExternalSubtitle() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['srt', 'ass', 'vtt', 'sub'],
      );
      if (result != null && result.files.single.path != null) {
        await _player.setSubtitleTrack(SubtitleTrack.uri(result.files.single.path!));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load subtitle file'), backgroundColor: AppColors.error),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        top: !_isFullScreen, bottom: !_isFullScreen,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_hasError) return _buildError();
    if (_isLoading) return _buildLoading();

    return GestureDetector(
      onTap: () => setState(() => _showControls = !_showControls),
      child: Stack(
        children: [
          Positioned.fill(child: Video(controller: _controller, controls: NoVideoControls, fit: BoxFit.contain)),
          if (_showControls) _buildControls(),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [Colors.black54, Colors.transparent, Colors.black54],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white, size: 24.sp),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Text(widget.video.title, maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w500)),
                  ),
                  IconButton(
                    icon: Icon(Icons.headphones, color: _audioTracks.length > 1 ? AppColors.primary : AppColors.textMuted, size: 22.sp),
                    onPressed: _showTrackPicker,
                  ),
                ],
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.replay_10, color: Colors.white, size: 32.sp),
                  onPressed: () { final t = _position - const Duration(seconds: 10); _player.seek(t < Duration.zero ? Duration.zero : t); },
                ),
                SizedBox(width: 24.w),
                GestureDetector(
                  onTap: () => _isPlaying ? _player.pause() : _player.play(),
                  child: Container(
                    width: 64.w, height: 64.h,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.primary),
                    child: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white, size: 36.sp),
                  ),
                ),
                SizedBox(width: 24.w),
                IconButton(
                  icon: Icon(Icons.forward_10, color: Colors.white, size: 32.sp),
                  onPressed: () { final t = _position + const Duration(seconds: 10); _player.seek(t > _duration ? _duration : t); },
                ),
              ],
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  Text(_formatDuration(_position), style: TextStyle(color: Colors.white, fontSize: 12.sp)),
                  Expanded(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 3.h, thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.r),
                        overlayShape: RoundSliderOverlayShape(overlayRadius: 14.r),
                      ),
                      child: Slider(
                        value: _duration.inMilliseconds > 0 ? _position.inMilliseconds.toDouble().clamp(0, _duration.inMilliseconds.toDouble()) : 0,
                        max: _duration.inMilliseconds > 0 ? _duration.inMilliseconds.toDouble() : 1,
                        activeColor: AppColors.primary,
                        inactiveColor: AppColors.divider,
                        onChanged: (v) => _player.seek(Duration(milliseconds: v.toInt())),
                      ),
                    ),
                  ),
                  Text(_formatDuration(_duration), style: TextStyle(color: Colors.white, fontSize: 12.sp)),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_subtitleTracks.where((t) => t.id != 'no').isNotEmpty)
                    IconButton(
                      icon: Icon(Icons.subtitles, color: _currentSubtitle != null && _currentSubtitle!.id != 'no' ? AppColors.primary : AppColors.textMuted, size: 22.sp),
                      onPressed: _showTrackPicker,
                    ),
                  SizedBox(width: 16.w),
                  IconButton(
                    icon: Icon(_isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen, color: Colors.white, size: 22.sp),
                    onPressed: _toggleFullScreen,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.primary),
          SizedBox(height: 16.h),
          Text('Loading ${widget.video.title}...', style: TextStyle(color: AppColors.textMuted, fontSize: 14.sp)),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: AppColors.error, size: 48.sp),
            SizedBox(height: 16.h),
            Text('Playback Error', style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 8.h),
            Text(_errorMsg ?? 'Unknown error', textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textMuted, fontSize: 14.sp)),
            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                    decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(8.r)),
                    child: Text('Go Back', style: TextStyle(color: Colors.white, fontSize: 14.sp)),
                  ),
                ),
                SizedBox(width: 16.w),
                GestureDetector(
                  onTap: () { setState(() { _hasError = false; _isLoading = true; }); _initPlayer(); },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                    decoration: BoxDecoration(gradient: AppColors.premiumGradient, borderRadius: BorderRadius.circular(8.r)),
                    child: Text('Retry', style: TextStyle(color: Colors.white, fontSize: 14.sp)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
