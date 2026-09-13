import 'package:flutter_test/flutter_test.dart';
import 'package:primeview/core/constants/app_constants.dart';

void main() {
  group('AppConstants', () {
    test('app name is PrimeView', () {
      expect(AppConstants.appName, 'PrimeView');
    });

    test('app version is defined', () {
      expect(AppConstants.appVersion, isNotEmpty);
    });

    test('default playlist URL is valid', () {
      expect(AppConstants.defaultPlaylistUrl, startsWith('https://'));
      expect(AppConstants.defaultPlaylistUrl, endsWith('.m3u'));
    });

    test('category playlists are valid URLs', () {
      for (final url in AppConstants.categoryPlaylists) {
        expect(url, startsWith('https://'));
        expect(url, endsWith('.m3u'));
      }
    });

    test('category playlists has 6 entries', () {
      expect(AppConstants.categoryPlaylists.length, 6);
    });

    test('connection timeout is reasonable', () {
      expect(AppConstants.connectionTimeout.inSeconds, greaterThanOrEqualTo(10));
      expect(AppConstants.connectionTimeout.inSeconds, lessThanOrEqualTo(60));
    });

    test('receive timeout is longer than connection timeout', () {
      expect(AppConstants.receiveTimeout.inSeconds, greaterThan(AppConstants.connectionTimeout.inSeconds));
    });

    test('hive keys are non-empty strings', () {
      expect(AppConstants.hiveBoxName, isNotEmpty);
      expect(AppConstants.hiveFavoritesKey, isNotEmpty);
      expect(AppConstants.hiveRecentlyWatchedKey, isNotEmpty);
      expect(AppConstants.hivePlaylistKey, isNotEmpty);
    });

    test('hive keys are unique', () {
      final keys = {
        AppConstants.hiveFavoritesKey,
        AppConstants.hiveRecentlyWatchedKey,
        AppConstants.hivePlaylistKey,
      };
      expect(keys.length, 3);
    });

    test('category constants are defined', () {
      expect(AppConstants.categoryAll, 'All');
      expect(AppConstants.categoryFavorites, 'Favorites');
      expect(AppConstants.categoryRecentlyWatched, 'Recently Watched');
    });

    test('UI constants are positive', () {
      expect(AppConstants.channelLogoSize, greaterThan(0));
      expect(AppConstants.heroBannerHeight, greaterThan(0));
      expect(AppConstants.channelRowHeight, greaterThan(0));
    });

    test('animation duration is reasonable', () {
      expect(AppConstants.animationDuration.inMilliseconds, greaterThan(0));
      expect(AppConstants.animationDuration.inMilliseconds, lessThanOrEqualTo(1000));
    });

    test('predefined categories are non-empty', () {
      expect(AppConstants.predefinedCategories, isNotEmpty);
      for (final cat in AppConstants.predefinedCategories) {
        expect(cat, isNotEmpty);
      }
    });

    test('predefined categories are unique', () {
      final unique = AppConstants.predefinedCategories.toSet();
      expect(unique.length, AppConstants.predefinedCategories.length);
    });
  });
}
