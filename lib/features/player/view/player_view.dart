import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:flutter/services.dart';
import '../../../core/models/channel_model.dart';
import '../viewmodels/player_viewmodel.dart';
import '../widgets/video_controls.dart';
import '../widgets/player_states.dart';
import '../../home/viewmodels/home_viewmodel.dart';

class PlayerView extends ConsumerStatefulWidget {
  final ChannelModel channel;
  const PlayerView({super.key, required this.channel});

  @override
  ConsumerState<PlayerView> createState() => _PlayerViewState();
}

class _PlayerViewState extends ConsumerState<PlayerView> with WidgetsBindingObserver {
  late final ChannelModel _currentChannel;
  bool _isInPip = false;

  @override
  void initState() {
    super.initState();
    _currentChannel = widget.channel;
    WidgetsBinding.instance.addObserver(this);
    WakelockPlus.enable();
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight, DeviceOrientation.portraitUp]);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(playerViewModelProvider.notifier).initialize(_currentChannel.url);
      saveLastWatchedChannel(_currentChannel);
    });
  }

  @override
  void dispose() {
    ref.read(playerViewModelProvider.notifier).stop();
    WidgetsBinding.instance.removeObserver(this);
    WakelockPlus.disable();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.light));
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused && !_isInPip) ref.read(playerViewModelProvider.notifier).pause();
    if (state == AppLifecycleState.resumed) { _isInPip = false; ref.read(playerViewModelProvider.notifier).play(); }
  }

  void _switchChannel(ChannelModel channel) {
    ref.read(playerViewModelProvider.notifier).switchChannel(channel.url);
    saveLastWatchedChannel(channel);
  }

  @override
  Widget build(BuildContext context) {
    final ps = ref.watch(playerViewModelProvider);

    if (ps.isFullScreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        top: !ps.isFullScreen, bottom: !ps.isFullScreen,
        child: _buildContent(ps, _currentChannel),
      ),
    );
  }

  Widget _buildContent(PlayerState ps, ChannelModel channel) {
    if (ps.hasError) return PlayerErrorView(errorMessage: ps.errorMessage, channel: channel);
    if (ps.isLoading && !ps.isInitialized) return PlayerLoadingView(channel: channel);
    if (ps.isInitialized && ps.controller != null) {
      return Stack(children: [Positioned.fill(child: Video(controller: ps.controller!, controls: NoVideoControls, fit: BoxFit.contain)), VideoControls(channelName: channel.name, currentChannel: channel, onChannelChanged: _switchChannel, onPipEnter: () => setState(() => _isInPip = true))]);
    }
    return PlayerLoadingView(channel: channel);
  }
}
