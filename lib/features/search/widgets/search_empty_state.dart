import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';

class SearchEmptyState extends StatelessWidget {
  final int channelCount;
  const SearchEmptyState({super.key, required this.channelCount});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.live_tv_outlined, size: 72.sp, color: AppColors.textMuted),
          SizedBox(height: 16.h),
          Text(
            '$channelCount channels available',
            style: TextStyle(color: AppColors.textMuted, fontSize: 16.sp),
          ),
          SizedBox(height: 8.h),
          Text(
            'Search or tap filter to find channels',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14.sp),
          ),
        ],
      ),
    );
  }
}

class SearchNoResults extends StatelessWidget {
  const SearchNoResults({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64.sp, color: AppColors.textMuted),
          SizedBox(height: 16.h),
          Text(
            'No channels found',
            style: TextStyle(color: AppColors.textMuted, fontSize: 16.sp),
          ),
          SizedBox(height: 8.h),
          Text(
            'Try adjusting your filters or search term',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14.sp),
          ),
        ],
      ),
    );
  }
}
