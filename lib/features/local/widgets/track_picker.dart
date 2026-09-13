import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:media_kit/media_kit.dart';
import '../../../core/theme/app_colors.dart';

class TrackPicker extends StatelessWidget {
  final List<AudioTrack> audioTracks;
  final AudioTrack? currentAudio;
  final List<SubtitleTrack> subtitleTracks;
  final SubtitleTrack? currentSubtitle;
  final ValueChanged<AudioTrack>? onAudioSelected;
  final ValueChanged<SubtitleTrack>? onSubtitleSelected;
  final VoidCallback? onLoadExternalSubtitle;

  const TrackPicker({
    super.key,
    this.audioTracks = const [],
    this.currentAudio,
    this.subtitleTracks = const [],
    this.currentSubtitle,
    this.onAudioSelected,
    this.onSubtitleSelected,
    this.onLoadExternalSubtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40.w, height: 4.h,
            margin: EdgeInsets.only(top: 12.h),
            decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(2.r)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Text('Tracks', style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold)),
          ),
          if (audioTracks.isNotEmpty) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(children: [
                Icon(Icons.audiotrack, color: AppColors.primary, size: 20.sp),
                SizedBox(width: 8.w),
                Text('Audio Track', style: TextStyle(color: AppColors.textMuted, fontSize: 13.sp)),
              ]),
            ),
            SizedBox(height: 4.h),
            ...audioTracks.where((t) => t.id != 'no').map((track) => _buildTrackTile(
              title: track.title ?? 'Audio ${track.id}',
              subtitle: track.language ?? track.id,
              isSelected: currentAudio?.id == track.id,
              onTap: () => onAudioSelected?.call(track),
            )),
            Divider(color: AppColors.divider, height: 1),
          ],
          if (subtitleTracks.isNotEmpty) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(children: [
                Icon(Icons.subtitles, color: AppColors.primary, size: 20.sp),
                SizedBox(width: 8.w),
                Text('Subtitle Track', style: TextStyle(color: AppColors.textMuted, fontSize: 13.sp)),
              ]),
            ),
            ...subtitleTracks.where((t) => t.id != 'no').map((track) => _buildTrackTile(
              title: track.title ?? 'Subtitle ${track.id}',
              subtitle: track.language ?? track.id,
              isSelected: currentSubtitle?.id == track.id,
              onTap: () => onSubtitleSelected?.call(track),
            )),
            _buildTrackTile(
              title: 'Load external subtitle...',
              icon: Icons.file_open,
              onTap: () {
                Navigator.pop(context);
                onLoadExternalSubtitle?.call();
              },
            ),
          ],
          if (audioTracks.isEmpty && subtitleTracks.isEmpty)
            Padding(
              padding: EdgeInsets.all(24.w),
              child: Text('No additional tracks available', style: TextStyle(color: AppColors.textMuted, fontSize: 14.sp)),
            ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 16.h),
        ],
      ),
    );
  }

  Widget _buildTrackTile({required String title, String? subtitle, bool isSelected = false, IconData? icon, VoidCallback? onTap}) {
    return ListTile(
      leading: icon != null ? Icon(icon, color: AppColors.primary, size: 20.sp) : null,
      title: Text(title, style: TextStyle(color: isSelected ? AppColors.primary : Colors.white, fontSize: 14.sp)),
      subtitle: subtitle != null ? Text(subtitle, style: TextStyle(color: AppColors.textMuted, fontSize: 12.sp)) : null,
      trailing: isSelected ? Icon(Icons.check, color: AppColors.primary, size: 20.sp) : null,
      onTap: onTap,
    );
  }
}
