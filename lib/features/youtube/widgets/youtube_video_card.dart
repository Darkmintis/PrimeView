import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../models/youtube_video.dart';

class YouTubeVideoCard extends StatelessWidget {
  final YouTubeVideo video;
  final VoidCallback onTap;
  const YouTubeVideoCard({super.key, required this.video, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12.r), border: Border.all(color: AppColors.divider.withValues(alpha: 0.2))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: video.thumbnailUrl != null
                        ? CachedNetworkImage(
                            imageUrl: video.thumbnailUrl!,
                            fit: BoxFit.cover,
                            placeholder: (_, _) => Container(color: AppColors.surfaceLight, child: Icon(Icons.play_circle_outline, color: AppColors.textMuted, size: 32.sp)),
                            errorWidget: (_, _, _) => Container(color: AppColors.surfaceLight, child: Icon(Icons.play_circle_outline, color: AppColors.textMuted, size: 32.sp)),
                          )
                        : Container(color: AppColors.surfaceLight, child: Icon(Icons.play_circle_outline, color: AppColors.textMuted, size: 32.sp)),
                  ),
                ),
                if (video.duration != Duration.zero)
                  Positioned(bottom: 6.h, right: 6.w, child: Container(padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h), decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(4.r)), child: Text(video.durationFormatted, style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.w600)))),
                Positioned(top: 0, left: 0, right: 0, bottom: 0, child: Center(child: Container(width: 44.w, height: 44.h, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black.withValues(alpha: 0.5)), child: Icon(Icons.play_arrow, color: Colors.white, size: 28.sp)))),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(8.w),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(video.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.w500, height: 1.3)),
                SizedBox(height: 4.h),
                Text(video.channelName, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: AppColors.textMuted, fontSize: 11.sp)),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
