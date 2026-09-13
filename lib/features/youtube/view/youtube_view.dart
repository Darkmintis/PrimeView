import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/channel_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../player/view/player_view.dart';
import '../models/youtube_video.dart';
import '../viewmodels/youtube_viewmodel.dart';
import '../widgets/youtube_video_card.dart';

class YouTubeView extends ConsumerStatefulWidget {
  const YouTubeView({super.key});

  @override
  ConsumerState<YouTubeView> createState() => _YouTubeViewState();
}

class _YouTubeViewState extends ConsumerState<YouTubeView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _playVideo(YouTubeVideo video) {
    final channel = ChannelModel(id: 'yt_${video.id}', name: video.title, url: video.streamUrl, logo: video.thumbnailUrl, category: 'YouTube', language: 'en');
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => PlayerView(channel: channel)));
  }

  @override
  Widget build(BuildContext context) {
    final ytState = ref.watch(youtubeProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true, expandedHeight: 120.h, backgroundColor: AppColors.background, surfaceTintColor: Colors.transparent,
            title: Row(children: [
              Container(width: 32.w, height: 32.h, decoration: BoxDecoration(gradient: AppColors.premiumGradient, borderRadius: BorderRadius.circular(8.r)), child: Icon(Icons.play_arrow, color: Colors.white, size: 20.sp)),
              SizedBox(width: 8.w),
              Text('YouTube', style: TextStyle(color: Colors.white, fontSize: 22.sp, fontWeight: FontWeight.bold)),
            ]),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF0B0B1A), AppColors.background], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                child: Align(alignment: Alignment.bottomCenter, child: Padding(padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 12.h), child: Container(
                  decoration: BoxDecoration(color: AppColors.surfaceLight, borderRadius: BorderRadius.circular(12.r), border: Border.all(color: AppColors.divider)),
                  child: TextField(
                    controller: _searchController, style: TextStyle(color: Colors.white, fontSize: 14.sp),
                    decoration: InputDecoration(
                      hintText: 'Search YouTube...', hintStyle: TextStyle(color: AppColors.textMuted.withValues(alpha: 0.7), fontSize: 14.sp),
                      prefixIcon: Padding(padding: EdgeInsets.all(12.w), child: Icon(Icons.search, color: AppColors.textMuted, size: 20.sp)),
                      suffixIcon: _searchController.text.isNotEmpty ? GestureDetector(onTap: () { _searchController.clear(); ref.read(youtubeProvider.notifier).loadTrending(); setState(() {}); }, child: Padding(padding: EdgeInsets.all(12.w), child: Icon(Icons.clear, color: AppColors.textMuted, size: 18.sp))) : null,
                      border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 12.h),
                    ),
                    onSubmitted: (v) => ref.read(youtubeProvider.notifier).search(v),
                    onChanged: (_) => setState(() {}),
                  ),
                ))),
              ),
            ),
          ),
          if (ytState.isLoading) const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
          else if (ytState.error != null) SliverFillRemaining(child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.error_outline, color: AppColors.error, size: 48.sp), SizedBox(height: 16.h), Text(ytState.error!, style: TextStyle(color: AppColors.textMuted))])))
          else SliverPadding(padding: EdgeInsets.symmetric(horizontal: 16.w), sliver: SliverGrid(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 12.h, crossAxisSpacing: 12.w, childAspectRatio: 0.75), delegate: SliverChildBuilderDelegate((_, i) => YouTubeVideoCard(video: ytState.videos[i], onTap: () => _playVideo(ytState.videos[i])), childCount: ytState.videos.length))),
          SliverPadding(padding: EdgeInsets.only(bottom: 16.h), sliver: const SliverToBoxAdapter()),
        ],
      ),
    );
  }
}
