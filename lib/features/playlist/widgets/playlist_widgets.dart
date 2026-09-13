import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';

class PlaylistInfoCard extends StatelessWidget {
  const PlaylistInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(color: AppColors.surfaceLight, borderRadius: BorderRadius.circular(8.r)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('What is an M3U playlist?', style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w600)),
        SizedBox(height: 8.h),
        Text('An M3U file contains a list of TV channels with their stream URLs. You can get one from your IPTV provider. The file starts with #EXTM3U and contains #EXTINF entries.', style: TextStyle(color: AppColors.textSecondary, fontSize: 13.sp)),
      ]),
    );
  }
}

class PlaylistDivider extends StatelessWidget {
  const PlaylistDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 32.h),
      child: Row(children: [
        const Expanded(child: Divider()),
        Padding(padding: EdgeInsets.symmetric(horizontal: 16.w), child: Text('OR', style: TextStyle(color: AppColors.textMuted, fontSize: 14.sp))),
        const Expanded(child: Divider()),
      ]),
    );
  }
}
