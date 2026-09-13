import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 3.w, height: 16.h, decoration: BoxDecoration(gradient: AppColors.premiumGradient, borderRadius: BorderRadius.circular(2.r))),
        SizedBox(width: 8.w),
        Text(title, style: TextStyle(color: AppColors.textSecondary, fontSize: 13.sp, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
      ],
    );
  }
}

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SettingsTile({super.key, required this.icon, required this.title, required this.subtitle, this.trailing, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(color: AppColors.cardBackground, borderRadius: BorderRadius.circular(12.r), border: Border.all(color: AppColors.divider)),
        child: Row(
          children: [
            Container(width: 36.w, height: 36.h, decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10.r)), child: Icon(icon, color: AppColors.primaryLight, size: 18.sp)),
            SizedBox(width: 12.w),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w500)),
              SizedBox(height: 2.h),
              Text(subtitle, style: TextStyle(color: AppColors.textMuted, fontSize: 12.sp), maxLines: 1, overflow: TextOverflow.ellipsis),
            ])),
            ?trailing,
          ],
        ),
      ),
    );
  }
}
