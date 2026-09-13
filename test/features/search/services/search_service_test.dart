import 'package:flutter_test/flutter_test.dart';
import 'package:primeview/features/search/services/search_service.dart';
import 'package:primeview/core/models/channel_model.dart';

void main() {
  late SearchService service;

  setUp(() {
    service = SearchService();
  });

  final channels = [
    const ChannelModel(id: '1', name: 'BBC News', url: 'http://bbc.com', category: 'News', language: 'English', country: 'United Kingdom'),
    const ChannelModel(id: '2', name: 'CNN International', url: 'http://cnn.com', category: 'News', language: 'English', country: 'United States'),
    const ChannelModel(id: '3', name: 'Sky Sports', url: 'http://sky.com', category: 'Sports', language: 'English', country: 'United Kingdom'),
    const ChannelModel(id: '4', name: 'ESPN', url: 'http://espn.com', category: 'Sports', language: 'Spanish', country: 'United States'),
    const ChannelModel(id: '5', name: 'France 24', url: 'http://france24.com', category: 'News', language: 'French', country: 'France'),
    const ChannelModel(id: '6', name: 'NHK World', url: 'http://nhk.jp', category: 'Entertainment', language: 'Japanese', country: 'Japan'),
    const ChannelModel(id: '7', name: 'Al Jazeera', url: 'http://aljazeera.com', category: 'News', language: 'Arabic', country: 'Qatar'),
  ];

  group('SearchService.filter', () {
    group('text query', () {
      test('filters by channel name (case insensitive)', () {
        final result = service.filter(channels: channels, query: 'bbc');
        expect(result.length, 1);
        expect(result[0].name, 'BBC News');
      });

      test('filters by partial name match', () {
        final result = service.filter(channels: channels, query: 'news');
        expect(result.length, 4);
      });

      test('filters by category name in query', () {
        final result = service.filter(channels: channels, query: 'sports');
        expect(result.length, 2);
      });

      test('filters by country name in query', () {
        final result = service.filter(channels: channels, query: 'france');
        expect(result.length, 1);
        expect(result[0].name, 'France 24');
      });

      test('returns empty for no match', () {
        final result = service.filter(channels: channels, query: 'nonexistent');
        expect(result, isEmpty);
      });

      test('empty query returns all channels', () {
        final result = service.filter(channels: channels, query: '');
        expect(result.length, channels.length);
      });
    });

    group('category filter', () {
      test('filters by exact category', () {
        final result = service.filter(channels: channels, query: '', category: 'News');
        expect(result.length, 4);
        expect(result.every((c) => c.category == 'News'), true);
      });

      test('filters by Sports category', () {
        final result = service.filter(channels: channels, query: '', category: 'Sports');
        expect(result.length, 2);
      });

      test('null category returns all', () {
        final result = service.filter(channels: channels, query: '', category: null);
        expect(result.length, channels.length);
      });

      test('empty category string returns all', () {
        final result = service.filter(channels: channels, query: '', category: '');
        expect(result.length, channels.length);
      });
    });

    group('language filter', () {
      test('filters by language', () {
        final result = service.filter(channels: channels, query: '', language: 'English');
        expect(result.length, 3);
        expect(result.every((c) => c.language == 'English'), true);
      });

      test('filters by Spanish', () {
        final result = service.filter(channels: channels, query: '', language: 'Spanish');
        expect(result.length, 1);
        expect(result[0].name, 'ESPN');
      });

      test('null language returns all', () {
        final result = service.filter(channels: channels, query: '', language: null);
        expect(result.length, channels.length);
      });
    });

    group('country filter', () {
      test('filters by country', () {
        final result = service.filter(channels: channels, query: '', country: 'United Kingdom');
        expect(result.length, 2);
      });

      test('filters by United States', () {
        final result = service.filter(channels: channels, query: '', country: 'United States');
        expect(result.length, 2);
      });

      test('null country returns all', () {
        final result = service.filter(channels: channels, query: '', country: null);
        expect(result.length, channels.length);
      });
    });

    group('combined filters', () {
      test('query + category', () {
        final result = service.filter(channels: channels, query: 'news', category: 'News');
        expect(result.length, 4);
      });

      test('query + language + country', () {
        final result = service.filter(
          channels: channels,
          query: '',
          language: 'English',
          country: 'United Kingdom',
        );
        expect(result.length, 2);
      });

      test('all filters combined', () {
        final result = service.filter(
          channels: channels,
          query: 'news',
          category: 'News',
          language: 'English',
          country: 'United Kingdom',
        );
        expect(result.length, 1);
        expect(result[0].name, 'BBC News');
      });

      test('overly restrictive filters return empty', () {
        final result = service.filter(
          channels: channels,
          query: 'sports',
          category: 'News',
        );
        expect(result, isEmpty);
      });
    });

    group('edge cases', () {
      test('empty channel list', () {
        final result = service.filter(channels: [], query: 'test');
        expect(result, isEmpty);
      });

      test('whitespace-only query filters out all', () {
        final result = service.filter(channels: channels, query: '   ');
        expect(result, isEmpty);
      });
    });
  });
}
