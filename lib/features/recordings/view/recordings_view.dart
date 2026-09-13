import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../viewmodels/recordings_viewmodel.dart';
import '../widgets/recording_card.dart';
import '../widgets/empty_recordings.dart';

class RecordingsView extends ConsumerWidget {
  const RecordingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(recordingsProvider);
    final recordings = state.recordings;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true, expandedHeight: 120.h, backgroundColor: AppColors.background, surfaceTintColor: Colors.transparent,
            title: Text('Recordings', style: TextStyle(color: Colors.white, fontSize: 22.sp, fontWeight: FontWeight.bold)),
            actions: [if (recordings.isNotEmpty) Padding(padding: EdgeInsets.only(right: 16.w), child: Center(child: Container(padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h), decoration: BoxDecoration(color: AppColors.surfaceLight, borderRadius: BorderRadius.circular(8.r)), child: Text('${recordings.length}', style: TextStyle(color: AppColors.textMuted, fontSize: 12.sp)))))],
            flexibleSpace: FlexibleSpaceBar(background: Container(decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF0B0B1A), AppColors.background], begin: Alignment.topCenter, end: Alignment.bottomCenter)))),
          ),
          if (recordings.isEmpty) const SliverFillRemaining(child: EmptyRecordings())
          else SliverPadding(padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 100.h), sliver: SliverList(delegate: SliverChildBuilderDelegate((_, i) => RecordingCard(recording: recordings[i], onDelete: () => ref.read(recordingsProvider.notifier).deleteRecording(recordings[i])), childCount: recordings.length))),
        ],
      ),
    );
  }
}
