import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/navigation_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../features/home/view/home_view.dart';
import '../../features/youtube/view/youtube_view.dart';
import '../../features/search/view/search_view.dart';
import '../../features/local/view/library_view.dart';
import '../../features/recordings/view/recordings_view.dart';
import '../../features/settings/view/settings_view.dart';

class AppScaffold extends ConsumerWidget {
  const AppScaffold({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(currentTabProvider);

    final screens = <Widget>[
      HomeView(
        onSearchTap: () =>
            ref.read(currentTabProvider.notifier).state = TabIndex.search,
      ),
      const YouTubeView(),
      const SearchView(),
      const LibraryView(),
      const RecordingsView(),
      const SettingsView(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: currentIndex.index,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border(
            top: BorderSide(
              color: AppColors.divider.withValues(alpha: 0.3),
              width: 0.5,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.05),
              blurRadius: 12.r,
              spreadRadius: 0,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 4.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                _navItems.length,
                (index) => _NavBarItem(
                  icon: _navItems[index].icon,
                  activeIcon: _navItems[index].activeIcon,
                  label: _navItems[index].label,
                  isSelected: currentIndex.index == index,
                  onTap: () => ref
                      .read(currentTabProvider.notifier)
                      .state = TabIndex.values[index],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

const _navItems = [
  _NavItem(Icons.home_outlined, Icons.home, 'Home'),
  _NavItem(Icons.play_circle_outline, Icons.play_circle, 'YouTube'),
  _NavItem(Icons.search_outlined, Icons.search, 'Search'),
  _NavItem(Icons.video_library_outlined, Icons.video_library, 'Library'),
  _NavItem(Icons.fiber_manual_record_outlined, Icons.fiber_manual_record, 'Record'),
  _NavItem(Icons.settings_outlined, Icons.settings, 'Settings'),
];

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _NavItem(this.icon, this.activeIcon, this.label);
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: isSelected
                    ? [AppColors.primary, AppColors.primaryLight]
                    : [AppColors.textMuted, AppColors.textMuted],
              ).createShader(bounds),
              child: Icon(
                isSelected ? activeIcon : icon,
                color: Colors.white,
                size: 22.sp,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.textMuted,
                fontSize: 9.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
