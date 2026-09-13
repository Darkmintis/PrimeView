import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../playlist/view/playlist_input_view.dart';

class HomeErrorState extends StatelessWidget {
  final String? errorMessage;
  const HomeErrorState({super.key, this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(32.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.tv_off, size: 72.sp, color: AppColors.textMuted),
              SizedBox(height: 16.h),
              Text('No channels available', style: TextStyle(color: Colors.white, fontSize: 22.sp, fontWeight: FontWeight.bold)),
              SizedBox(height: 8.h),
              Text(errorMessage ?? 'Failed to load channels.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textSecondary, fontSize: 14.sp)),
              SizedBox(height: 24.h),
              ElevatedButton.icon(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PlaylistInputView())),
                icon: const Icon(Icons.add),
                label: const Text('Add Playlist'),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeEmptyState extends StatelessWidget {
  const HomeEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('No channels found in playlist', style: TextStyle(color: AppColors.textSecondary, fontSize: 16.sp)),
      ),
    );
  }
}
