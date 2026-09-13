import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../playlist/viewmodels/playlist_viewmodel.dart';
import '../../playlist/view/playlist_input_view.dart';
import '../widgets/hero_banner.dart';
import '../widgets/channel_grid_card.dart';
import '../widgets/free_content_section.dart';
import '../widgets/home_states.dart';
import '../../../shared/widgets/loading_widget.dart';

class HomeView extends ConsumerStatefulWidget {
  final VoidCallback? onSearchTap;
  const HomeView({super.key, this.onSearchTap});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final playlistState = ref.watch(playlistProvider);
    final channels = ref.watch(channelsProvider);

    if (playlistState == PlaylistState.loading || playlistState == PlaylistState.idle) return const ChannelLoadingSkeleton();
    if (playlistState == PlaylistState.error) return HomeErrorState(errorMessage: ref.read(playlistProvider.notifier).errorMessage);
    if (channels.isEmpty) return const HomeEmptyState();

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(context),
          const SliverToBoxAdapter(child: FreeContentSection()),
          _buildChannelsHeader(channels.length),
          SliverPadding(padding: EdgeInsets.symmetric(horizontal: 12.w), sliver: SliverGrid.builder(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 0.7, crossAxisSpacing: 8, mainAxisSpacing: 8), itemCount: channels.length, itemBuilder: (_, i) => ChannelGridCard(channel: channels[i]))),
          SliverToBoxAdapter(child: SizedBox(height: 100.h)),
        ],
      ),
    );
  }

  SliverAppBar _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300.h,
      pinned: true,
      floating: false,
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      flexibleSpace: const FlexibleSpaceBar(background: HeroBanner()),
      title: Image.asset('assets/primeview_logo.png', height: 28.h, color: AppColors.primary, errorBuilder: (_, _, _) => Text('PrimeView', style: GoogleFonts.rubikDirt(color: AppColors.primary, fontSize: 26.sp, letterSpacing: 1))),
      actions: [
        IconButton(icon: const Icon(Icons.search), onPressed: () => widget.onSearchTap?.call()),
        PopupMenuButton<String>(icon: const Icon(Icons.more_vert), onSelected: (v) { if (v == 'add_playlist') Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PlaylistInputView())); }, itemBuilder: (_) => [PopupMenuItem(value: 'add_playlist', child: Row(children: [Icon(Icons.add_circle_outline, color: AppColors.textPrimary), SizedBox(width: 12.w), const Text('Add Playlist')]))]),
      ],
    );
  }

  SliverToBoxAdapter _buildChannelsHeader(int count) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 12.h),
        child: Row(
          children: [
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(colors: [AppColors.primary, AppColors.primaryLight]).createShader(bounds),
              child: Text('All Channels', style: GoogleFonts.playfairDisplay(color: Colors.white, fontSize: 26.sp, fontWeight: FontWeight.w700)),
            ),
            const Spacer(),
            Container(padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h), decoration: BoxDecoration(color: AppColors.surfaceLight, borderRadius: BorderRadius.circular(12.r)), child: Text('$count', style: TextStyle(color: AppColors.primary, fontSize: 13.sp, fontWeight: FontWeight.w600))),
          ],
        ),
      ),
    );
  }
}
