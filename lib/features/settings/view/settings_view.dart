import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../playlist/viewmodels/playlist_viewmodel.dart';
import '../viewmodels/settings_viewmodel.dart';
import '../widgets/settings_widgets.dart';
import '../widgets/settings_dialogs.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(expandedHeight: 120.h, pinned: true, backgroundColor: AppColors.background, surfaceTintColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(background: Padding(padding: EdgeInsets.only(left: 16.w, bottom: 48.h), child: Column(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Settings', style: GoogleFonts.playfairDisplay(color: Colors.white, fontSize: 28.sp, fontWeight: FontWeight.w700)),
              SizedBox(height: 4.h),
              Text('Customize your experience', style: TextStyle(color: AppColors.textSecondary, fontSize: 13.sp)),
            ])))),
          SliverToBoxAdapter(child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SectionHeader(title: 'Playback'),
              SizedBox(height: 12.h),
              SettingsTile(icon: Icons.play_circle_outline, title: 'Auto-play on start', subtitle: 'Automatically play when opening a channel', trailing: Switch(value: settings.autoPlay, onChanged: (v) => ref.read(settingsProvider.notifier).setAutoPlay(v), activeTrackColor: AppColors.primary)),
              SettingsTile(icon: Icons.history, title: 'Remember last channel', subtitle: 'Resume from last watched channel', trailing: Switch(value: settings.rememberLastChannel, onChanged: (v) => ref.read(settingsProvider.notifier).setRememberLastChannel(v), activeTrackColor: AppColors.primary)),
              SizedBox(height: 24.h),
              const SectionHeader(title: 'Playlist'),
              SizedBox(height: 12.h),
              SettingsTile(icon: Icons.link, title: 'Playlist URL', subtitle: settings.playlistUrl.length > 50 ? '${settings.playlistUrl.substring(0, 50)}...' : settings.playlistUrl, trailing: Icon(Icons.chevron_right, color: AppColors.textMuted, size: 20.sp), onTap: () => showPlaylistUrlDialog(context, ref, settings.playlistUrl)),
              SettingsTile(icon: Icons.refresh, title: 'Refresh playlist', subtitle: 'Fetch latest channels from source', trailing: Icon(Icons.chevron_right, color: AppColors.textMuted, size: 20.sp), onTap: () { ref.read(playlistProvider.notifier).loadFromUrl(settings.playlistUrl); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Refreshing playlist...'), behavior: SnackBarBehavior.floating)); }),
              SizedBox(height: 24.h),
              const SectionHeader(title: 'About'),
              SizedBox(height: 12.h),
              SettingsTile(icon: Icons.info_outline, title: AppConstants.appName, subtitle: 'Version ${AppConstants.appVersion}', trailing: Icon(Icons.chevron_right, color: AppColors.textMuted, size: 20.sp), onTap: () => showAppAboutDialog(context)),
              SizedBox(height: 40.h),
            ]),
          )),
        ],
      ),
    );
  }
}
