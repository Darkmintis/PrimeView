import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/app_colors.dart';

class PremiumSliverAppBar extends StatelessWidget {
  final String? title;
  final Widget? titleWidget;
  final double expandedHeight;
  final bool showGradientIcon;
  final IconData? icon;
  final List<Widget>? actions;
  final Widget? flexibleContent;
  final PreferredSizeWidget? bottom;

  const PremiumSliverAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.expandedHeight = 120,
    this.showGradientIcon = false,
    this.icon,
    this.actions,
    this.flexibleContent,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: expandedHeight.h,
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      actions: actions,
      bottom: bottom,
      title: titleWidget ?? (title != null
          ? Row(
              children: [
                if (showGradientIcon) ...[
                  Container(
                    width: 32.w, height: 32.h,
                    decoration: BoxDecoration(
                      gradient: AppColors.premiumGradient,
                      borderRadius: BorderRadius.circular(8.r),
                      boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 8)],
                    ),
                    child: Icon(icon ?? Icons.video_library, color: Colors.white, size: 18.sp),
                  ),
                  SizedBox(width: 8.w),
                ],
                Text(title!, style: TextStyle(color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.bold)),
              ],
            )
          : null),
      flexibleSpace: FlexibleSpaceBar(
        background: flexibleContent ?? Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0B0B1A), AppColors.background],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
    );
  }
}

class PremiumAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBack;
  final Color? backgroundColor;

  const PremiumAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.showBack = true,
    this.backgroundColor,
  });

  @override
  Size get preferredSize => Size.fromHeight(56.h);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          height: preferredSize.height,
          color: (backgroundColor ?? AppColors.background).withValues(alpha: 0.8),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                children: [
                  if (showBack)
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20.sp),
                      onPressed: () => Navigator.maybePop(context),
                    )
                  else if (leading != null)
                    leading!,
                  SizedBox(width: 4.w),
                  Expanded(
                    child: titleWidget ?? (title != null
                        ? Text(title!, style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold))
                        : const SizedBox()),
                  ),
                  if (actions != null) ...actions!,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
