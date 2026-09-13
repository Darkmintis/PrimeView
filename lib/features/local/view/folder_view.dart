import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/premium_app_bar.dart';
import '../models/media_folder.dart';
import '../viewmodels/library_viewmodel.dart';
import '../widgets/video_card.dart';
import 'local_player_view.dart';

class FolderView extends ConsumerWidget {
  final MediaFolder folder;
  const FolderView({super.key, required this.folder});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videos = ref.watch(folderVideosProvider(folder.path));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PremiumAppBar(title: folder.name),
      body: videos.isEmpty
          ? Center(child: Text('No videos in this folder', style: TextStyle(color: AppColors.textMuted, fontSize: 14.sp)))
          : GridView.builder(
              padding: EdgeInsets.all(16.w),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, mainAxisSpacing: 12.h, crossAxisSpacing: 12.w, childAspectRatio: 0.85,
              ),
              itemCount: videos.length,
              itemBuilder: (_, i) => VideoCard(
                video: videos[i],
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => LocalPlayerView(video: videos[i]))),
              ),
            ),
    );
  }
}
