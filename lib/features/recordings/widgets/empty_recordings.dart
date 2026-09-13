import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';

class EmptyRecordings extends StatelessWidget {
  const EmptyRecordings({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(width: 80.w, height: 80.h, decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.primary.withValues(alpha: 0.1)), child: Icon(Icons.fiber_manual_record, size: 40.sp, color: AppColors.primary)),
        SizedBox(height: 24.h),
        Text('No recordings yet', style: TextStyle(color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.w600)),
        SizedBox(height: 8.h),
        Text('Start recording from the player\nto save streams for later', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textMuted, fontSize: 14.sp)),
      ]),
    );
  }
}
