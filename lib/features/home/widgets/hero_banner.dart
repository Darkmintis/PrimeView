import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/models/channel_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../favorites/viewmodels/favorites_viewmodel.dart';
import '../../player/view/player_view.dart';
import '../../playlist/viewmodels/playlist_viewmodel.dart';

class HeroBanner extends ConsumerStatefulWidget {
  const HeroBanner({super.key});

  @override
  ConsumerState<HeroBanner> createState() => _HeroBannerState();
}

class _HeroBannerState extends ConsumerState<HeroBanner> {
  final _pageController = PageController();
  int _currentPage = 0;
  Timer? _autoRotateTimer;

  List<ChannelModel> _getCarouselItems(List<ChannelModel> favorites, List<ChannelModel> allChannels) {
    final items = <ChannelModel>[];
    final seen = <String>{};

    for (final c in favorites) {
      if (items.length >= 5) break;
      if (seen.add(c.id)) items.add(c);
    }

    if (items.isEmpty) {
      for (final c in allChannels) {
        if (items.length >= 5) break;
        if (seen.add(c.id)) items.add(c);
      }
    }

    return items.isEmpty ? allChannels.take(5).toList() : items;
  }

  void _startAutoRotate(int itemCount) {
    _autoRotateTimer?.cancel();
    if (itemCount <= 1) return;
    _autoRotateTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted || !_pageController.hasClients) return;
      final next = (_currentPage + 1) % itemCount;
      _pageController.animateToPage(next, duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
    });
  }

  @override
  void dispose() {
    _autoRotateTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final favorites = ref.watch(favoriteChannelsProvider);
    final allChannels = ref.watch(channelsProvider);
    final items = _getCarouselItems(favorites, allChannels);

    _startAutoRotate(items.length);

    return SizedBox(
      height: 300.h,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: items.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (_, i) => _HeroSlide(channel: items[i]),
          ),
          if (items.length > 1) Positioned(bottom: 80.h, left: 0, right: 0, child: _PageDots(count: items.length, current: _currentPage)),
          Positioned(bottom: 0, left: 0, right: 0, child: _GlassInfoPanel(channel: items[_currentPage.clamp(0, items.length - 1)])),
        ],
      ),
    );
  }
}

class _HeroSlide extends StatelessWidget {
  final ChannelModel channel;
  const _HeroSlide({required this.channel});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (channel.logo != null && channel.logo!.isNotEmpty)
          CachedNetworkImage(
            imageUrl: channel.logo!,
            fit: BoxFit.cover,
            placeholder: (_, _) => _gradientBg(),
            errorWidget: (_, _, _) => _gradientBg(),
          )
        else
          _gradientBg(),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color(0x000A0E1A), const Color(0x000A0E1A), AppColors.background],
              stops: const [0.0, 0.4, 1.0],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + 8.h,
          left: 16.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: AppColors.error,
              borderRadius: BorderRadius.circular(4.r),
              boxShadow: [BoxShadow(color: AppColors.error.withValues(alpha: 0.4), blurRadius: 8, spreadRadius: 1)],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 6.w, height: 6.h, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white)),
                SizedBox(width: 4.w),
                Text('LIVE', style: TextStyle(color: Colors.white, fontSize: 9.sp, fontWeight: FontWeight.w800, letterSpacing: 1)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _gradientBg() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppColors.surface, AppColors.surfaceLight, AppColors.cardBackground], begin: Alignment.topLeft, end: Alignment.bottomRight),
      ),
      child: Center(child: Icon(Icons.live_tv_rounded, size: 60.sp, color: AppColors.textMuted.withValues(alpha: 0.2))),
    );
  }
}

class _PageDots extends StatelessWidget {
  final int count;
  final int current;
  const _PageDots({required this.count, required this.current});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final isActive = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 3.w),
          width: isActive ? 20.w : 6.w,
          height: 6.h,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : Colors.white.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(3.r),
            boxShadow: isActive ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.5), blurRadius: 6)] : null,
          ),
        );
      }),
    );
  }
}

class _GlassInfoPanel extends StatelessWidget {
  final ChannelModel channel;
  const _GlassInfoPanel({required this.channel});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 20.h),
          decoration: BoxDecoration(
            color: AppColors.background.withValues(alpha: 0.6),
            border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.08), width: 0.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  if (channel.category != null) _GradientBadge(text: channel.category!),
                  if (channel.quality != null) ...[SizedBox(width: 6.w), _GlassBadge(text: channel.quality!, accent: true)],
                  if (channel.country != null && channel.country!.isNotEmpty) ...[SizedBox(width: 6.w), _GlassBadge(text: channel.country!.toUpperCase())],
                  const Spacer(),
                  _LiveIndicator(),
                ],
              ),
              SizedBox(height: 10.h),
              Text(
                channel.name,
                style: GoogleFonts.playfairDisplay(color: Colors.white, fontSize: 24.sp, fontWeight: FontWeight.w700, height: 1.15),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 14.h),
              Row(
                children: [
                  _GlowButton(
                    label: 'Play',
                    icon: Icons.play_arrow_rounded,
                    isPrimary: true,
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => PlayerView(channel: channel))),
                  ),
                  SizedBox(width: 10.w),
                  _GlowButton(
                    label: 'Info',
                    icon: Icons.info_outline_rounded,
                    isPrimary: false,
                    onTap: () => _showInfo(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16.r))),
      builder: (context) => Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(channel.name, style: TextStyle(color: Colors.white, fontSize: 22.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 12.h),
            if (channel.category != null) _infoRow('Category', channel.category),
            if (channel.language != null) _infoRow('Language', channel.language),
            if (channel.group != null) _infoRow('Group', channel.group),
            SizedBox(height: 16.h),
            Text(channel.url, style: TextStyle(color: AppColors.textMuted, fontSize: 12.sp), maxLines: 2, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String? value) {
    if (value == null) return const SizedBox();
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(children: [
        Text('$label: ', style: TextStyle(color: AppColors.textMuted, fontSize: 14.sp)),
        Text(value, style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w500)),
      ]),
    );
  }
}

class _GradientBadge extends StatelessWidget {
  final String text;
  const _GradientBadge({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        gradient: AppColors.premiumGradient,
        borderRadius: BorderRadius.circular(4.r),
        boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 6)],
      ),
      child: Text(text, style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.w700, letterSpacing: 0.3)),
    );
  }
}

class _GlassBadge extends StatelessWidget {
  final String text;
  final bool accent;
  const _GlassBadge({required this.text, this.accent = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: accent ? AppColors.accent.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4.r),
        border: accent ? Border.all(color: AppColors.accent.withValues(alpha: 0.4)) : null,
      ),
      child: Text(text, style: TextStyle(color: accent ? AppColors.accent : Colors.white70, fontSize: 10.sp, fontWeight: FontWeight.w600)),
    );
  }
}

class _LiveIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.4, end: 1.0),
            duration: const Duration(milliseconds: 1200),
            builder: (_, v, child) => Container(
              width: 6.w, height: 6.h,
              decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.error.withValues(alpha: v)),
            ),
          ),
          SizedBox(width: 5.w),
          Text('LIVE', style: TextStyle(color: AppColors.error, fontSize: 9.sp, fontWeight: FontWeight.w800, letterSpacing: 0.8)),
        ],
      ),
    );
  }
}

class _GlowButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isPrimary;
  final VoidCallback onTap;
  const _GlowButton({required this.label, required this.icon, required this.isPrimary, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        decoration: BoxDecoration(
          gradient: isPrimary ? AppColors.premiumGradient : null,
          color: isPrimary ? null : Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: isPrimary ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.4), blurRadius: 12, offset: const Offset(0, 4))] : null,
          border: isPrimary ? null : Border.all(color: Colors.white.withValues(alpha: 0.15)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 20.sp),
            SizedBox(width: 6.w),
            Text(label, style: TextStyle(color: Colors.white, fontSize: 13.sp, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
