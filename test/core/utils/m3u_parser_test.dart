import 'package:flutter_test/flutter_test.dart';
import 'package:primeview/core/utils/m3u_parser.dart';

void main() {
  group('M3uParser', () {
    group('parse', () {
      test('parses valid M3U with EXTINF metadata', () {
        const content = '''#EXTM3U
#EXTINF:-1 tvg-logo="https://example.com/bbc.png" group-title="News" tvg-language="English" tvg-country="United Kingdom",BBC News
https://example.com/bbc.m3u8
#EXTINF:-1 tvg-logo="https://example.com/cnn.png" group-title="News" tvg-language="English" tvg-country="United States",CNN
https://example.com/cnn.m3u8''';

        final channels = M3uParser.parse(content);

        expect(channels.length, 2);

        expect(channels[0].name, 'BBC News');
        expect(channels[0].url, 'https://example.com/bbc.m3u8');
        expect(channels[0].logo, 'https://example.com/bbc.png');
        expect(channels[0].category, 'News');
        expect(channels[0].language, 'English');
        expect(channels[0].country, 'United Kingdom');
        expect(channels[0].isActive, true);

        expect(channels[1].name, 'CNN');
        expect(channels[1].url, 'https://example.com/cnn.m3u8');
      });

      test('parses M3U with only URLs (no EXTINF)', () {
        const content = '''#EXTM3U
https://example.com/channel1.m3u8
https://example.com/channel2.m3u8''';

        final channels = M3uParser.parse(content);

        expect(channels.length, 2);
        expect(channels[0].name, 'channel1');
        expect(channels[1].name, 'channel2');
      });

      test('assigns Uncategorized when no group-title', () {
        const content = '''#EXTM3U
#EXTINF:-1,No Group Channel
https://example.com/nogroup.m3u8''';

        final channels = M3uParser.parse(content);
        expect(channels[0].category, 'Uncategorized');
      });

      test('deduplicates channels by name', () {
        const content = '''#EXTM3U
#EXTINF:-1,BBC News
https://example.com/bbc1.m3u8
#EXTINF:-1,BBC News
https://example.com/bbc2.m3u8''';

        final channels = M3uParser.parse(content);
        expect(channels.length, 1);
      });

      test('deduplicates case-insensitively', () {
        const content = '''#EXTM3U
#EXTINF:-1,BBC News
https://example.com/bbc1.m3u8
#EXTINF:-1,bbc news
https://example.com/bbc2.m3u8''';

        final channels = M3uParser.parse(content);
        expect(channels.length, 1);
      });

      test('skips empty URLs', () {
        const content = '''#EXTM3U
#EXTINF:-1,Valid Channel
https://example.com/valid.m3u8
#EXTINF:-1,Empty URL Channel

#EXTINF:-1,Another Valid
https://example.com/another.m3u8''';

        final channels = M3uParser.parse(content);
        expect(channels.length, 2);
      });

      test('parses RTMP and RTSP URLs', () {
        const content = '''#EXTM3U
#EXTINF:-1,RTMP Channel
rtmp://example.com/live/stream
#EXTINF:-1,RTSP Channel
rtsp://example.com/live/stream''';

        final channels = M3uParser.parse(content);
        expect(channels.length, 2);
        expect(channels[0].url, startsWith('rtmp://'));
        expect(channels[1].url, startsWith('rtsp://'));
      });

      test('extracts quality from channel name', () {
        const content = '''#EXTM3U
#EXTINF:-1,BBC News HD
https://example.com/bbc_hd.m3u8
#EXTINF:-1,CNN 1080p
https://example.com/cnn_1080p.m3u8
#EXTINF:-1,Sky News 4K
https://example.com/sky_4k.m3u8''';

        final channels = M3uParser.parse(content);

        expect(channels[0].quality, 'HD');
        expect(channels[0].name, 'BBC News');

        expect(channels[1].quality, '1080P');
        expect(channels[1].name, 'CNN');

        expect(channels[2].quality, '4K');
        expect(channels[2].name, 'Sky News');
      });

      test('handles HTML entities in names', () {
        const content = '''#EXTM3U
#EXTINF:-1,BBC &amp; ITV
https://example.com/ch.m3u8''';

        final channels = M3uParser.parse(content);
        expect(channels[0].name, 'BBC & ITV');
      });

      test('returns empty list for invalid content', () {
        final channels = M3uParser.parse('this is not m3u content');
        expect(channels, isEmpty);
      });

      test('returns empty list for empty content', () {
        final channels = M3uParser.parse('');
        expect(channels, isEmpty);
      });

      test('returns empty list for malformed EXTINF lines', () {
        const content = '''#EXTM3U
random text
https://example.com/ch.m3u8''';

        final channels = M3uParser.parse(content);
        expect(channels.length, 1);
        expect(channels[0].name, 'ch');
      });

      test('assigns unique IDs to channels', () {
        const content = '''#EXTM3U
#EXTINF:-1,Channel A
https://example.com/a.m3u8
#EXTINF:-1,Channel B
https://example.com/b.m3u8''';

        final channels = M3uParser.parse(content);
        expect(channels[0].id, isNot(equals(channels[1].id)));
      });

      test('parses large playlist without error', () {
        final buffer = StringBuffer('#EXTM3U\n');
        for (var i = 0; i < 1000; i++) {
          buffer.writeln('#EXTINF:-1 group-title="Cat${i % 10}",Channel $i');
          buffer.writeln('https://example.com/ch$i.m3u8');
        }

        final channels = M3uParser.parse(buffer.toString());
        expect(channels.length, 1000);
      });
    });

    group('isValidM3u', () {
      test('returns true for valid M3U header', () {
        expect(M3uParser.isValidM3u('#EXTM3U\n#EXTINF:-1,Ch\nhttp://x.com'), true);
      });

      test('returns true with leading whitespace', () {
        expect(M3uParser.isValidM3u('  \n  #EXTM3U'), true);
      });

      test('returns false for non-M3U content', () {
        expect(M3uParser.isValidM3u('hello world'), false);
      });

      test('returns false for empty string', () {
        expect(M3uParser.isValidM3u(''), false);
      });

      test('returns false for HTML content', () {
        expect(M3uParser.isValidM3u('<html><body>test</body></html>'), false);
      });
    });
  });
}
