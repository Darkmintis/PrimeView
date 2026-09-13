import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../viewmodels/search_viewmodel.dart';

class SearchInputBar extends ConsumerWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool hasFilters;

  const SearchInputBar({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.hasFilters,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: MediaQuery.of(context).padding.top + 8,
        bottom: 8.h,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: hasFilters || focusNode.hasFocus
                ? AppColors.primary.withValues(alpha: 0.7)
                : AppColors.divider,
            width: hasFilters || focusNode.hasFocus ? 1.5 : 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14.r),
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            style: TextStyle(color: Colors.white, fontSize: 16.sp),
            decoration: InputDecoration(
              hintText: 'Search channels...',
              hintStyle: TextStyle(
                color: AppColors.textMuted.withValues(alpha: 0.7),
                fontSize: 15.sp,
              ),
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: 16.w, right: 8.w),
                child: Icon(Icons.search, color: AppColors.textMuted, size: 22.sp),
              ),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (hasFilters)
                    Padding(
                      padding: EdgeInsets.only(right: 4.w),
                      child: Container(
                        width: 8.w,
                        height: 8.h,
                        decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                      ),
                    ),
                  if (controller.text.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        controller.clear();
                        ref.read(searchProvider.notifier).setQuery('');
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
                        child: Icon(Icons.clear, color: AppColors.textMuted, size: 20.sp),
                      ),
                    ),
                  SizedBox(width: 4.w),
                ],
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 14.h),
            ),
            onChanged: (v) => ref.read(searchProvider.notifier).setQuery(v),
          ),
        ),
      ),
    );
  }
}
