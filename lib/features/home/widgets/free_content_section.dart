import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../youtube/view/youtube_view.dart';

class FreeContentSection extends StatelessWidget {
  const FreeContentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
          child: Text('Free Content', style: GoogleFonts.playfairDisplay(color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.w700)),
        ),
        SizedBox(
          height: 90.h,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            children: [
              _FreeContentCard(icon: Icons.play_circle_filled, title: 'YouTube', subtitle: 'Free videos & music', gradient: const LinearGradient(colors: [Color(0xFFFF0000), Color(0xFFCC0000)]), onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const YouTubeView()))),
              SizedBox(width: 12.w),
              _FreeContentCard(icon: Icons.movie_filter, title: 'Free Movies', subtitle: 'Public domain films', gradient: const LinearGradient(colors: [Color(0xFF7B2FF7), Color(0xFF5B1FD7)]), onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const YouTubeView()))),
            ],
          ),
        ),
      ],
    );
  }
}

class _FreeContentCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Gradient gradient;
  final VoidCallback onTap;

  const _FreeContentCard({required this.icon, required this.title, required this.subtitle, required this.gradient, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160.w,
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        decoration: BoxDecoration(gradient: gradient, borderRadius: BorderRadius.circular(16.r)),
        child: Padding(
          padding: EdgeInsets.all(14.w),
          child: Row(
            children: [
              Container(width: 44.w, height: 44.h, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12.r)), child: Icon(icon, color: Colors.white, size: 24.sp)),
              SizedBox(width: 12.w),
              Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: TextStyle(color: Colors.white, fontSize: 15.sp, fontWeight: FontWeight.bold)),
                SizedBox(height: 2.h),
                Text(subtitle, style: TextStyle(color: Colors.white70, fontSize: 11.sp), maxLines: 1, overflow: TextOverflow.ellipsis),
              ])),
            ],
          ),
        ),
      ),
    );
  }
}
