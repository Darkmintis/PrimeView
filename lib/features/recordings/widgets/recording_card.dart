import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../models/recording_model.dart';

class RecordingCard extends StatelessWidget {
  final RecordingModel recording;
  final VoidCallback onDelete;
  const RecordingCard({super.key, required this.recording, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('MMM d, h:mm a');
    final d = recording.duration;
    final durationStr = '${d.inHours > 0 ? '${d.inHours}h ' : ''}${d.inMinutes.remainder(60)}m ${d.inSeconds.remainder(60)}s';

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: recording.isRecording ? AppColors.error.withValues(alpha: 0.5) : AppColors.divider.withValues(alpha: 0.3), width: recording.isRecording ? 1.5 : 0.5),
      ),
      child: Padding(
        padding: EdgeInsets.all(14.w),
        child: Row(
          children: [
            Container(width: 48.w, height: 48.h, decoration: BoxDecoration(color: recording.isRecording ? AppColors.error.withValues(alpha: 0.15) : AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12.r)), child: Icon(recording.isRecording ? Icons.fiber_manual_record : Icons.play_circle_outline, color: recording.isRecording ? AppColors.error : AppColors.primary, size: 26.sp)),
            SizedBox(width: 12.w),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(recording.channelName, style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
              SizedBox(height: 4.h),
              Row(children: [
                Text(timeFormat.format(recording.startedAt), style: TextStyle(color: AppColors.textMuted, fontSize: 11.sp)),
                if (recording.isRecording) ...[SizedBox(width: 6.w), Container(width: 6.w, height: 6.h, decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.error)), SizedBox(width: 4.w), Text('REC', style: TextStyle(color: AppColors.error, fontSize: 10.sp, fontWeight: FontWeight.w700))],
              ]),
            ])),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(durationStr, style: TextStyle(color: AppColors.textSecondary, fontSize: 12.sp, fontWeight: FontWeight.w500)),
              SizedBox(height: 2.h),
              Text(recording.fileSizeFormatted, style: TextStyle(color: AppColors.textMuted, fontSize: 11.sp)),
            ]),
            SizedBox(width: 8.w),
            PopupMenuButton<String>(onSelected: (v) { if (v == 'delete') onDelete(); }, itemBuilder: (_) => [const PopupMenuItem(value: 'delete', child: Text('Delete'))], icon: Icon(Icons.more_vert, color: AppColors.textMuted, size: 20.sp)),
          ],
        ),
      ),
    );
  }
}
