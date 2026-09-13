import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/html_utils.dart';

class SearchFilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const SearchFilterChip({
    super.key,
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withValues(alpha: 0.15)
              : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isActive ? AppColors.primary : AppColors.divider,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14.sp,
              color: isActive ? AppColors.primary : AppColors.textMuted,
            ),
            SizedBox(width: 6.w),
            Text(
              label,
              style: TextStyle(
                color: isActive ? AppColors.primary : AppColors.textSecondary,
                fontSize: 12.sp,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            if (isActive) ...[
              SizedBox(width: 4.w),
              Icon(Icons.close, size: 12.sp, color: AppColors.primary),
            ],
          ],
        ),
      ),
    );
  }
}

class CategoryPicker extends StatelessWidget {
  final List<String> categories;
  final String? current;
  final ValueChanged<String?> onSelected;

  const CategoryPicker({
    super.key,
    required this.categories,
    required this.current,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.textMuted,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                Container(
                  width: 36.w,
                  height: 36.h,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(Icons.category, color: AppColors.primary, size: 20.sp),
                ),
                SizedBox(width: 12.w),
                Text(
                  'Select Category',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Wrap(
              spacing: 10.w,
              runSpacing: 10.h,
              children: [
                _buildOption('All', current == null, () => onSelected(null)),
                ...categories.map(
                  (c) => _buildOption(c, current == c, () => onSelected(c)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.divider,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selected)
              Padding(
                padding: EdgeInsets.only(right: 6.w),
                child: Icon(Icons.check, color: Colors.white, size: 16.sp),
              ),
            Text(
              htmlDecode(label),
              style: TextStyle(
                color: selected ? Colors.white : AppColors.textSecondary,
                fontSize: 14.sp,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CountryPicker extends StatelessWidget {
  final List<String> countries;
  final String? current;
  final ValueChanged<String?> onSelected;

  const CountryPicker({
    super.key,
    required this.countries,
    required this.current,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    var query = '';

    return StatefulBuilder(
      builder: (ctx, setSheetState) {
        final filtered = query.isEmpty
            ? countries
            : countries
                  .where((c) => htmlDecode(c).toLowerCase().contains(query))
                  .toList();

        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: 20.w,
              right: 20.w,
              top: 12.h,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: AppColors.textMuted,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Container(
                      width: 36.w,
                      height: 36.h,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(Icons.flag, color: AppColors.primary, size: 20.sp),
                    ),
                    SizedBox(width: 12.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select Country',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          '${filtered.length} of ${countries.length} countries',
                          style: TextStyle(color: AppColors.textMuted, fontSize: 12.sp),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: TextField(
                    controller: controller,
                    style: TextStyle(color: Colors.white, fontSize: 14.sp),
                    decoration: InputDecoration(
                      hintText: 'Search countries...',
                      hintStyle: TextStyle(
                        color: AppColors.textMuted.withValues(alpha: 0.7),
                        fontSize: 14.sp,
                      ),
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(12.w),
                        child: Icon(Icons.search, color: AppColors.textMuted, size: 20.sp),
                      ),
                      suffixIcon: query.isNotEmpty
                          ? GestureDetector(
                              onTap: () {
                                controller.clear();
                                setSheetState(() => query = '');
                              },
                              child: Padding(
                                padding: EdgeInsets.all(12.w),
                                child: Icon(Icons.clear, color: AppColors.textMuted, size: 18.sp),
                              ),
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 12.h),
                    ),
                    onChanged: (v) => setSheetState(() => query = v.toLowerCase()),
                  ),
                ),
                SizedBox(height: 12.h),
                Flexible(
                  child: filtered.isEmpty
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 24.h),
                            child: Text(
                              'No matching countries',
                              style: TextStyle(color: AppColors.textMuted, fontSize: 14.sp),
                            ),
                          ),
                        )
                      : ListView(
                          shrinkWrap: true,
                          children: [
                            _buildOption('All Countries', current == null, () => onSelected(null)),
                            ...filtered.map(
                              (c) => _buildOption(c, current == c, () => onSelected(c)),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOption(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.symmetric(vertical: 3.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary.withValues(alpha: 0.1) : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: selected ? AppColors.primary : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 22.w,
              height: 22.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? AppColors.primary : Colors.transparent,
                border: Border.all(
                  color: selected ? AppColors.primary : AppColors.textMuted,
                  width: 2,
                ),
              ),
              child: selected ? Icon(Icons.check, color: Colors.white, size: 14.sp) : null,
            ),
            SizedBox(width: 12.w),
            Text(
              htmlDecode(label),
              style: TextStyle(
                color: selected ? AppColors.primary : Colors.white,
                fontSize: 14.sp,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
