import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../models/local_video.dart';

class VideoCard extends StatelessWidget {
  final LocalVideo video;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const VideoCard({super.key, required this.video, required this.onTap, this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.divider.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
                    ),
                    child: Icon(Icons.play_circle_outline, color: AppColors.textMuted, size: 36.sp),
                  ),
                  Positioned(
                    bottom: 6.h, right: 6.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                      decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(4.r)),
                      child: Text(video.durationFormatted, style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  if (video.isFullyWatched)
                    Positioned(
                      top: 6.h, left: 6.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                        decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(4.r)),
                        child: Text('Watched', style: TextStyle(color: Colors.white, fontSize: 8.sp, fontWeight: FontWeight.w600)),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(8.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(video.title, maxLines: 2, overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.w500, height: 1.3)),
                    Text(video.fileSizeFormatted, style: TextStyle(color: AppColors.textMuted, fontSize: 10.sp)),
                  ],
                ),
              ),
            ),
            if (video.progress > 0)
              LinearProgressIndicator(
                value: video.progress,
                backgroundColor: AppColors.surfaceLight,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                minHeight: 2.h,
              ),
          ],
        ),
      ),
    );
  }
}
