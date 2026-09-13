import 'package:flutter_test/flutter_test.dart';
import 'package:primeview/core/utils/channel_utils.dart';
import 'package:primeview/core/models/channel_model.dart';

void main() {
  group('channel_utils', () {
    group('extractQuality', () {
      test('extracts 1080p', () {
        expect(extractQuality('BBC News 1080p'), '1080P');
      });

      test('extracts 1080i', () {
        expect(extractQuality('BBC News 1080i'), '1080I');
      });

      test('extracts 720p', () {
        expect(extractQuality('CNN 720p'), '720P');
      });

      test('extracts 480p', () {
        expect(extractQuality('Fox 480p'), '480P');
      });

      test('extracts 360p', () {
        expect(extractQuality('Low Quality 360p'), '360P');
      });

      test('extracts 240p', () {
        expect(extractQuality('Mobile 240p'), '240P');
      });

      test('extracts 144p', () {
        expect(extractQuality('Ultra Low 144p'), '144P');
      });

      test('extracts 4K', () {
        expect(extractQuality('Channel 4K'), '4K');
      });

      test('extracts UHD', () {
        expect(extractQuality('Samsung UHD'), 'UHD');
      });

      test('extracts FHD', () {
        expect(extractQuality('Sony FHD'), 'FHD');
      });

      test('extracts HD', () {
        expect(extractQuality('ESPN HD'), 'HD');
      });

      test('extracts SD', () {
        expect(extractQuality('Local SD'), 'SD');
      });

      test('extracts 2160p', () {
        expect(extractQuality('Channel 2160p'), '2160P');
      });

      test('extracts 1440p', () {
        expect(extractQuality('QHD 1440p'), '1440P');
      });

      test('returns null for no quality indicator', () {
        expect(extractQuality('BBC News'), isNull);
      });

      test('returns null for empty string', () {
        expect(extractQuality(''), isNull);
      });

      test('case insensitive matching', () {
        expect(extractQuality('channel 1080P'), '1080P');
        expect(extractQuality('channel 1080p'), '1080P');
        expect(extractQuality('channel hd'), 'HD');
        expect(extractQuality('channel Hd'), 'HD');
      });

      test('extracts first match only', () {
        expect(extractQuality('1080p vs 720p'), '1080P');
      });
    });

    group('cleanChannelName', () {
      test('removes 1080p from name', () {
        expect(cleanChannelName('BBC News 1080p'), 'BBC News');
      });

      test('removes HD from name', () {
        expect(cleanChannelName('ESPN HD'), 'ESPN');
      });

      test('removes 4K from name', () {
        expect(cleanChannelName('Sky News 4K'), 'Sky News');
      });

      test('collapses multiple spaces', () {
        expect(cleanChannelName('BBC   News   HD'), 'BBC News');
      });

      test('trims whitespace', () {
        expect(cleanChannelName('  BBC News HD  '), 'BBC News');
      });

      test('returns original when no quality', () {
        expect(cleanChannelName('BBC News'), 'BBC News');
      });

      test('handles empty string', () {
        expect(cleanChannelName(''), '');
      });
    });

    group('processChannelQuality', () {
      test('extracts quality and cleans name', () {
        const channel = ChannelModel(
          id: '1',
          name: 'BBC News HD',
          url: 'http://example.com',
        );

        final processed = processChannelQuality(channel);

        expect(processed.name, 'BBC News');
        expect(processed.quality, 'HD');
        expect(processed.id, '1');
        expect(processed.url, 'http://example.com');
      });

      test('returns unchanged channel when no quality', () {
        const channel = ChannelModel(
          id: '1',
          name: 'BBC News',
          url: 'http://example.com',
        );

        final processed = processChannelQuality(channel);

        expect(processed, equals(channel));
      });

      test('preserves existing quality if no match in name', () {
        const channel = ChannelModel(
          id: '1',
          name: 'BBC News',
          url: 'http://example.com',
          quality: 'FHD',
        );

        final processed = processChannelQuality(channel);

        expect(processed.quality, 'FHD');
        expect(processed.name, 'BBC News');
      });
    });
  });
}
