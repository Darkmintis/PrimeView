import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/premium_app_bar.dart';
import '../viewmodels/library_viewmodel.dart';
import '../widgets/media_permission_gate.dart';
import '../widgets/video_card.dart';
import '../widgets/folder_card.dart';
import '../models/local_video.dart';
import 'folder_view.dart';
import 'local_player_view.dart';

class LibraryView extends ConsumerWidget {
  const LibraryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final libState = ref.watch(libraryProvider);

    return MediaPermissionGate(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: libState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: () => ref.read(libraryProvider.notifier).refresh(),
                child: CustomScrollView(
                  slivers: [
                    PremiumSliverAppBar(
                      title: 'Library',
                      showGradientIcon: true,
                      icon: Icons.video_library,
                      expandedHeight: 80,
                      actions: [
                        if (libState.recentlyWatched.isNotEmpty)
                          IconButton(
                            icon: Icon(Icons.history, color: AppColors.textMuted, size: 22.sp),
                            onPressed: () => _showHistorySheet(context, ref, libState),
                          ),
                      ],
                    ),
                    if (libState.recentlyWatched.isNotEmpty) ...[
                      SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        sliver: SliverToBoxAdapter(
                          child: Text('Recently Watched', style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                        sliver: SliverToBoxAdapter(
                          child: SizedBox(
                            height: 140.h,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: libState.recentlyWatched.take(10).length,
                              separatorBuilder: (_, index1) => SizedBox(width: 12.w),
                              itemBuilder: (_, i) {
                                final video = libState.recentlyWatched[i];
                                return SizedBox(
                                  width: 180.w,
                                  child: VideoCard(
                                    video: video,
                                    onTap: () => _playVideo(context, ref, video),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                    if (libState.folders.isNotEmpty) ...[
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
                        sliver: SliverToBoxAdapter(
                          child: Text('Folders', style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        sliver: SliverList.separated(
                          itemCount: libState.folders.length,
                          separatorBuilder: (_, index2) => SizedBox(height: 8.h),
                          itemBuilder: (_, i) {
                            final folder = libState.folders[i];
                            return FolderCard(
                              folder: folder,
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => FolderView(folder: folder)),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
                      sliver: SliverToBoxAdapter(
                        child: Text('All Videos (${libState.videos.length})', style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, mainAxisSpacing: 12.h, crossAxisSpacing: 12.w, childAspectRatio: 0.85,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (_, i) => VideoCard(
                            video: libState.videos[i],
                            onTap: () => _playVideo(context, ref, libState.videos[i]),
                          ),
                          childCount: libState.videos.length,
                        ),
                      ),
                    ),
                    SliverPadding(padding: EdgeInsets.only(bottom: 16.h), sliver: const SliverToBoxAdapter()),
                  ],
                ),
              ),
      ),
    );
  }

  void _playVideo(BuildContext context, WidgetRef ref, LocalVideo video) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => LocalPlayerView(video: video),
    ));
  }

  void _showHistorySheet(BuildContext context, WidgetRef ref, libState) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
      builder: (_) => Container(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Watch History', style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () { ref.read(libraryProvider.notifier).clearHistory(); Navigator.pop(context); },
                  child: Text('Clear All', style: TextStyle(color: AppColors.error, fontSize: 14.sp)),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            ...libState.recentlyWatched.map((v) => ListTile(
              leading: Icon(Icons.play_circle_outline, color: AppColors.primary, size: 24.sp),
              title: Text(v.title, maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white, fontSize: 14.sp)),
              subtitle: Text(v.durationFormatted, style: TextStyle(color: AppColors.textMuted, fontSize: 12.sp)),
              trailing: IconButton(
                icon: Icon(Icons.close, color: AppColors.textMuted, size: 18.sp),
                onPressed: () => ref.read(libraryProvider.notifier).removeFromHistory(v.id),
              ),
            )),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 16.h),
          ],
        ),
      ),
    );
  }
}
