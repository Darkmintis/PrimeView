import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../viewmodels/settings_viewmodel.dart';

void showPlaylistUrlDialog(BuildContext context, WidgetRef ref, String currentUrl) {
  final controller = TextEditingController(text: currentUrl);
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: AppColors.surface,
      title: Text('Playlist URL', style: TextStyle(color: Colors.white, fontSize: 18.sp)),
      content: TextField(
        controller: controller,
        style: TextStyle(color: Colors.white, fontSize: 14.sp),
        decoration: InputDecoration(hintText: 'Enter M3U playlist URL', hintStyle: TextStyle(color: AppColors.textMuted)),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(ctx).pop(), child: Text('Cancel', style: TextStyle(color: AppColors.textMuted))),
        TextButton(
          onPressed: () {
            ref.read(settingsProvider.notifier).setPlaylistUrl(controller.text);
            Navigator.of(ctx).pop();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Playlist URL updated'), behavior: SnackBarBehavior.floating));
          },
          child: Text('Save', style: TextStyle(color: AppColors.primary)),
        ),
      ],
    ),
  );
}

void showAppAboutDialog(BuildContext context) {
  showAboutDialog(
    context: context,
    applicationName: AppConstants.appName,
    applicationVersion: AppConstants.appVersion,
    applicationIcon: Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(shape: BoxShape.circle, gradient: AppColors.premiumGradient),
      child: const Icon(Icons.live_tv, color: Colors.white, size: 24),
    ),
    children: [
      const SizedBox(height: 8),
      Text('PrimeView is a premium IPTV streaming application.', style: TextStyle(color: AppColors.textSecondary)),
    ],
  );
}
