import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../viewmodels/library_viewmodel.dart';

class MediaPermissionGate extends ConsumerWidget {
  final Widget child;
  const MediaPermissionGate({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final libState = ref.watch(libraryProvider);

    if (libState.hasPermission) return child;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80.w,
              height: 80.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surfaceLight,
              ),
              child: Icon(Icons.video_library_outlined, size: 40.sp, color: AppColors.primary),
            ),
            SizedBox(height: 24.h),
            Text('Access Your Media', style: TextStyle(color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 8.h),
            Text(
              'PrimeView needs access to your videos to play local media files.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textMuted, fontSize: 14.sp),
            ),
            SizedBox(height: 24.h),
            GestureDetector(
              onTap: () => ref.read(libraryProvider.notifier).requestPermission(),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 14.h),
                decoration: BoxDecoration(
                  gradient: AppColors.premiumGradient,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text('Grant Access', style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
