import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/models/channel_model.dart';
import '../viewmodels/player_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlayerLoadingView extends StatelessWidget {
  final ChannelModel channel;
  const PlayerLoadingView({super.key, required this.channel});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF0B0B1A), Color(0xFF151528)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            width: 80.w, height: 80.h,
            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 2)),
            child: Center(child: SizedBox(width: 44.w, height: 44.h, child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 3))),
          ),
          SizedBox(height: 32.h),
          Text(channel.name, style: TextStyle(color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 8.h),
          Text('Connecting to stream...', style: TextStyle(color: AppColors.textMuted, fontSize: 14.sp)),
        ]),
      ),
    );
  }
}

class PlayerErrorView extends ConsumerWidget {
  final String? errorMessage;
  final ChannelModel channel;
  const PlayerErrorView({super.key, this.errorMessage, required this.channel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF0B0B1A), Color(0xFF151528)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(32.w),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(width: 96.w, height: 96.h, decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.error.withValues(alpha: 0.1)), child: Icon(Icons.warning_amber_rounded, size: 48.sp, color: AppColors.error)),
            SizedBox(height: 24.h),
            Text('Unable to play stream', style: TextStyle(color: Colors.white, fontSize: 22.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 12.h),
            Text(errorMessage ?? 'The stream could not be loaded.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textSecondary, fontSize: 14.sp)),
            SizedBox(height: 8.h),
            Container(padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h), decoration: BoxDecoration(color: AppColors.cardBackground, borderRadius: BorderRadius.circular(8.r)), child: Text(channel.url, textAlign: TextAlign.center, style: TextStyle(color: AppColors.textMuted, fontSize: 11.sp), maxLines: 2, overflow: TextOverflow.ellipsis)),
            SizedBox(height: 32.h),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ElevatedButton.icon(onPressed: () => ref.read(playerViewModelProvider.notifier).retry(channel.url), icon: const Icon(Icons.refresh), label: const Text('Retry'), style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)))),
              SizedBox(width: 16.w),
              OutlinedButton.icon(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.arrow_back), label: const Text('Go Back'), style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: AppColors.textMuted), padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)))),
            ]),
          ]),
        ),
      ),
    );
  }
}
