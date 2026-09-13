import 'package:flutter_riverpod/flutter_riverpod.dart';

enum TabIndex { home, youtube, search, library, recordings, settings }

final currentTabProvider = StateProvider<TabIndex>((ref) => TabIndex.home);
