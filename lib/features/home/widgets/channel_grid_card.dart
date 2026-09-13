import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/models/channel_model.dart';
import '../../../core/utils/html_utils.dart';
import '../../player/view/player_view.dart';

class ChannelGridCard extends StatefulWidget {
  final ChannelModel channel;
  const ChannelGridCard({super.key, required this.channel});

  @override
  State<ChannelGridCard> createState() => _ChannelGridCardState();
}

class _ChannelGridCardState extends State<ChannelGridCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final hasCountry = widget.channel.country != null && widget.channel.country!.isNotEmpty;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => PlayerView(channel: widget.channel)));
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: AppColors.divider.withValues(alpha: 0.5), width: 0.5),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4)),
              if (_isPressed) BoxShadow(color: AppColors.primary.withValues(alpha: 0.15), blurRadius: 16, spreadRadius: -2),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(14.r)),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF1F1F3A), Color(0xFF181830)], begin: Alignment.topLeft, end: Alignment.bottomRight)),
                        child: widget.channel.logo != null && widget.channel.logo!.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: widget.channel.logo!,
                                fit: BoxFit.contain,
                                placeholder: (_, _) => Center(child: SizedBox(width: 20.w, height: 20.h, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary.withValues(alpha: 0.5)))),
                                errorWidget: (_, _, _) => _placeholderIcon(),
                              )
                            : _placeholderIcon(),
                      ),
                      if (hasCountry)
                        Positioned(
                          top: 4, right: 4,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4.r),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                                decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.7), borderRadius: BorderRadius.circular(4.r)),
                                child: Text(widget.channel.country!.toUpperCase(), style: TextStyle(color: Colors.white, fontSize: 8.sp, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                              ),
                            ),
                          ),
                        ),
                      Positioned(
                        bottom: 4, left: 4,
                        child: Container(
                          padding: EdgeInsets.all(3.w),
                          decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(6.r)),
                          child: Icon(Icons.play_circle_fill, color: AppColors.primaryLight, size: 14.sp),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(8.w, 6.h, 8.w, 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(htmlDecode(widget.channel.name), style: TextStyle(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
                    SizedBox(height: 3.h),
                    Row(children: [
                      Expanded(child: Text(htmlDecode(widget.channel.category ?? ''), style: TextStyle(color: AppColors.textMuted, fontSize: 10.sp), maxLines: 1, overflow: TextOverflow.ellipsis)),
                      if (widget.channel.language != null) Padding(padding: EdgeInsets.only(left: 4.w), child: _badge(widget.channel.language!)),
                      if (widget.channel.quality != null) Padding(padding: EdgeInsets.only(left: 4.w), child: _badge(widget.channel.quality!)),
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _placeholderIcon() => Center(child: Icon(Icons.live_tv_rounded, color: AppColors.textMuted.withValues(alpha: 0.3), size: 36.sp));

  Widget _badge(String text) => Container(padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h), decoration: BoxDecoration(color: AppColors.surfaceLight, borderRadius: BorderRadius.circular(3.r)), child: Text(text, style: TextStyle(color: AppColors.textSecondary, fontSize: 8.sp)));
}
