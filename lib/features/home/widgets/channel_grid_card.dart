import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/models/channel_model.dart';
import '../../../core/utils/html_utils.dart';
import '../../player/view/player_view.dart';

class ChannelGridCard extends StatelessWidget {
  final ChannelModel channel;
  const ChannelGridCard({super.key, required this.channel});

  @override
  Widget build(BuildContext context) {
    final hasCountry = channel.country != null && channel.country!.isNotEmpty;

    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => PlayerView(channel: channel))),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.divider, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF1F1F3A), Color(0xFF181830)], begin: Alignment.topLeft, end: Alignment.bottomRight)),
                      child: channel.logo != null && channel.logo!.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: channel.logo!,
                              fit: BoxFit.contain,
                              placeholder: (_, _) => Center(child: SizedBox(width: 20.w, height: 20.h, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary))),
                              errorWidget: (_, _, _) => _placeholderIcon(),
                            )
                          : _placeholderIcon(),
                    ),
                    if (hasCountry) Positioned(top: 4, right: 4, child: Container(padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h), decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.85), borderRadius: BorderRadius.circular(4.r)), child: Text(channel.country!.toUpperCase(), style: TextStyle(color: Colors.white, fontSize: 8.sp, fontWeight: FontWeight.w600, letterSpacing: 0.5)))),
                    Positioned(bottom: 4, left: 4, child: Container(padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h), decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(3.r)), child: Icon(Icons.play_circle_fill, color: AppColors.primaryLight, size: 14.sp))),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(8.w, 6.h, 8.w, 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(htmlDecode(channel.name), style: TextStyle(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
                  SizedBox(height: 3.h),
                  Row(children: [
                    Expanded(child: Text(htmlDecode(channel.category ?? ''), style: TextStyle(color: AppColors.textMuted, fontSize: 10.sp), maxLines: 1, overflow: TextOverflow.ellipsis)),
                    if (channel.language != null) Padding(padding: EdgeInsets.only(left: 4.w), child: _badge(channel.language!)),
                    if (channel.quality != null) Padding(padding: EdgeInsets.only(left: 4.w), child: _badge(channel.quality!)),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholderIcon() => Center(child: Icon(Icons.live_tv_rounded, color: AppColors.textMuted.withValues(alpha: 0.3), size: 36.sp));

  Widget _badge(String text) => Container(padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h), decoration: BoxDecoration(color: AppColors.surfaceLight, borderRadius: BorderRadius.circular(3.r)), child: Text(text, style: TextStyle(color: AppColors.textSecondary, fontSize: 8.sp)));
}
