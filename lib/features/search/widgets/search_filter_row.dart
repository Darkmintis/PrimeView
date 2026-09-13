import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import 'search_pickers.dart';

class SearchFilterRow extends StatelessWidget {
  final String? selectedCategory;
  final String? selectedCountry;
  final bool hasFilters;
  final VoidCallback onCategoryTap;
  final VoidCallback onCountryTap;
  final VoidCallback onClear;

  const SearchFilterRow({
    super.key,
    this.selectedCategory,
    this.selectedCountry,
    required this.hasFilters,
    required this.onCategoryTap,
    required this.onCountryTap,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 4.h),
      child: Row(
        children: [
          SearchFilterChip(
            label: selectedCategory ?? 'Category',
            icon: Icons.category,
            isActive: selectedCategory != null,
            onTap: onCategoryTap,
          ),
          SizedBox(width: 8.w),
          SearchFilterChip(
            label: selectedCountry ?? 'Country',
            icon: Icons.flag,
            isActive: selectedCountry != null,
            onTap: onCountryTap,
          ),
          const Spacer(),
          if (hasFilters)
            GestureDetector(
              onTap: onClear,
              child: Text(
                'Clear',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12.sp,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
