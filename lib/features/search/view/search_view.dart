import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/html_utils.dart';
import '../../playlist/viewmodels/playlist_viewmodel.dart';
import '../../playlist/widgets/channel_list_item.dart';
import '../viewmodels/search_viewmodel.dart';
import '../widgets/search_input_bar.dart';
import '../widgets/search_filter_row.dart';
import '../widgets/search_pickers.dart';
import '../widgets/search_empty_state.dart';

class SearchView extends ConsumerStatefulWidget {
  const SearchView({super.key});

  @override
  ConsumerState<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends ConsumerState<SearchView> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _showCategoryPicker() {
    final channels = ref.read(channelsProvider);
    final all = channels.map((c) => htmlDecode(c.category ?? '')).where((c) => c.isNotEmpty).toSet().toList()..sort();
    final filtered = AppConstants.predefinedCategories.where((c) => all.contains(c)).toList();
    final current = ref.read(searchProvider).selectedCategory;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => CategoryPicker(categories: filtered, current: current, onSelected: (v) { ref.read(searchProvider.notifier).setCategoryFilter(v); Navigator.of(context).pop(); }),
    );
  }

  void _showCountryPicker() {
    final channels = ref.read(channelsProvider);
    final all = channels.map((c) => c.country).where((c) => c != null && c.isNotEmpty).map((c) => c!).toSet().toList()..sort();
    if (all.isEmpty) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No countries available.'), behavior: SnackBarBehavior.floating)); return; }
    final current = ref.read(searchProvider).selectedCountry;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CountryPicker(countries: all, current: current, onSelected: (v) { ref.read(searchProvider.notifier).setCountryFilter(v); Navigator.of(context).pop(); }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final results = ref.watch(searchResultsProvider);
    final state = ref.watch(searchProvider);
    final channels = ref.watch(channelsProvider);
    final hasFilters = state.selectedCategory != null || state.selectedCountry != null;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: SearchInputBar(controller: _searchController, focusNode: _focusNode, hasFilters: hasFilters)),
          SliverToBoxAdapter(child: SearchFilterRow(selectedCategory: state.selectedCategory, selectedCountry: state.selectedCountry, hasFilters: hasFilters, onCategoryTap: _showCategoryPicker, onCountryTap: _showCountryPicker, onClear: () => ref.read(searchProvider.notifier).clearFilters())),
          if (state.query.isNotEmpty || results.isNotEmpty) SliverToBoxAdapter(child: Padding(padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 4.h), child: Text('${results.length} of ${channels.length} channels', style: TextStyle(color: AppColors.textMuted, fontSize: 13.sp)))),
          if (state.query.isEmpty && !hasFilters) SliverFillRemaining(child: SearchEmptyState(channelCount: channels.length))
          else if (results.isEmpty) const SliverFillRemaining(child: SearchNoResults())
          else SliverList.builder(itemCount: results.length, itemBuilder: (_, i) => Padding(padding: EdgeInsets.symmetric(horizontal: 16.w), child: ChannelListItem(channel: results[i]))),
        ],
      ),
    );
  }
}
