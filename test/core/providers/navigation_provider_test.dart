import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:primeview/core/providers/navigation_provider.dart';

void main() {
  group('navigation_provider', () {
    test('default tab is home', () {
      final container = ProviderContainer();

      addTearDown(container.dispose);

      expect(container.read(currentTabProvider), TabIndex.home);
    });

    test('can change tab', () {
      final container = ProviderContainer();

      addTearDown(container.dispose);

      container.read(currentTabProvider.notifier).state = TabIndex.search;
      expect(container.read(currentTabProvider), TabIndex.search);

      container.read(currentTabProvider.notifier).state = TabIndex.library;
      expect(container.read(currentTabProvider), TabIndex.library);

      container.read(currentTabProvider.notifier).state = TabIndex.recordings;
      expect(container.read(currentTabProvider), TabIndex.recordings);

      container.read(currentTabProvider.notifier).state = TabIndex.settings;
      expect(container.read(currentTabProvider), TabIndex.settings);
    });

    test('TabIndex enum has 6 values', () {
      expect(TabIndex.values.length, 6);
      expect(TabIndex.values, containsAll([
        TabIndex.home,
        TabIndex.youtube,
        TabIndex.search,
        TabIndex.library,
        TabIndex.recordings,
        TabIndex.settings,
      ]));
    });

    test('TabIndex.index returns correct indices', () {
      expect(TabIndex.home.index, 0);
      expect(TabIndex.youtube.index, 1);
      expect(TabIndex.search.index, 2);
      expect(TabIndex.library.index, 3);
      expect(TabIndex.recordings.index, 4);
      expect(TabIndex.settings.index, 5);
    });

    test('can cycle through all tabs', () {
      final container = ProviderContainer();

      addTearDown(container.dispose);

      for (final tab in TabIndex.values) {
        container.read(currentTabProvider.notifier).state = tab;
        expect(container.read(currentTabProvider), tab);
      }
    });
  });
}
