import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../models/media_folder.dart';

class FolderCard extends StatelessWidget {
  final MediaFolder folder;
  final VoidCallback onTap;

  const FolderCard({super.key, required this.folder, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.divider.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.h,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(Icons.folder, color: AppColors.primary, size: 24.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(folder.name, maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w500)),
                  SizedBox(height: 2.h),
                  Text('${folder.videoCount} videos', style: TextStyle(color: AppColors.textMuted, fontSize: 12.sp)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.textMuted, size: 20.sp),
          ],
        ),
      ),
    );
  }
}
