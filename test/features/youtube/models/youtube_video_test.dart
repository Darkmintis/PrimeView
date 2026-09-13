import 'package:flutter_test/flutter_test.dart';
import 'package:primeview/features/youtube/models/youtube_video.dart';

void main() {
  group('YouTubeVideo', () {
    group('constructor', () {
      test('creates with all fields', () {
        const video = YouTubeVideo(
          id: 'vid-1',
          title: 'Flutter Tutorial',
          channelName: 'Acme Code',
          thumbnailUrl: 'https://img.youtube.com/vid-1.jpg',
          duration: Duration(minutes: 15, seconds: 30),
          streamUrl: 'https://example.com/stream.m3u8',
        );

        expect(video.id, 'vid-1');
        expect(video.title, 'Flutter Tutorial');
        expect(video.channelName, 'Acme Code');
        expect(video.thumbnailUrl, 'https://img.youtube.com/vid-1.jpg');
        expect(video.duration, const Duration(minutes: 15, seconds: 30));
        expect(video.streamUrl, 'https://example.com/stream.m3u8');
      });

      test('creates with defaults', () {
        const video = YouTubeVideo(
          id: 'vid-1',
          title: 'Test',
          channelName: 'Channel',
          streamUrl: 'http://stream.com',
        );

        expect(video.thumbnailUrl, isNull);
        expect(video.duration, Duration.zero);
      });
    });

    group('durationFormatted', () {
      test('formats minutes and seconds', () {
        const video = YouTubeVideo(
          id: '1', title: 'T', channelName: 'C',
          duration: Duration(minutes: 5, seconds: 30),
          streamUrl: 'http://s.com',
        );
        expect(video.durationFormatted, '5:30');
      });

      test('formats hours, minutes, and seconds', () {
        const video = YouTubeVideo(
          id: '1', title: 'T', channelName: 'C',
          duration: Duration(hours: 1, minutes: 23, seconds: 45),
          streamUrl: 'http://s.com',
        );
        expect(video.durationFormatted, '1:23:45');
      });

      test('pads single-digit seconds', () {
        const video = YouTubeVideo(
          id: '1', title: 'T', channelName: 'C',
          duration: Duration(minutes: 3, seconds: 5),
          streamUrl: 'http://s.com',
        );
        expect(video.durationFormatted, '3:05');
      });

      test('handles zero duration', () {
        const video = YouTubeVideo(
          id: '1', title: 'T', channelName: 'C',
          duration: Duration.zero,
          streamUrl: 'http://s.com',
        );
        expect(video.durationFormatted, '0:00');
      });

      test('formats exactly one hour', () {
        const video = YouTubeVideo(
          id: '1', title: 'T', channelName: 'C',
          duration: Duration(hours: 1),
          streamUrl: 'http://s.com',
        );
        expect(video.durationFormatted, '1:00:00');
      });

      test('formats multiple hours', () {
        const video = YouTubeVideo(
          id: '1', title: 'T', channelName: 'C',
          duration: Duration(hours: 3, minutes: 45, seconds: 12),
          streamUrl: 'http://s.com',
        );
        expect(video.durationFormatted, '3:45:12');
      });
    });

    group('equality', () {
      test('equal instances', () {
        const a = YouTubeVideo(id: '1', title: 'A', channelName: 'C', streamUrl: 'http://s.com');
        const b = YouTubeVideo(id: '1', title: 'A', channelName: 'C', streamUrl: 'http://s.com');
        expect(a, equals(b));
        expect(a.hashCode, equals(b.hashCode));
      });

      test('unequal instances', () {
        const a = YouTubeVideo(id: '1', title: 'A', channelName: 'C', streamUrl: 'http://s.com');
        const b = YouTubeVideo(id: '2', title: 'B', channelName: 'D', streamUrl: 'http://s2.com');
        expect(a, isNot(equals(b)));
      });

      test('equality considers all fields', () {
        const a = YouTubeVideo(
          id: '1', title: 'A', channelName: 'C',
          thumbnailUrl: 'thumb.jpg', duration: Duration(minutes: 10),
          streamUrl: 'http://s.com',
        );
        const b = YouTubeVideo(
          id: '1', title: 'A', channelName: 'C',
          thumbnailUrl: 'thumb.jpg', duration: Duration(minutes: 10),
          streamUrl: 'http://s.com',
        );
        expect(a, equals(b));
      });

      test('different thumbnail makes unequal', () {
        const a = YouTubeVideo(id: '1', title: 'A', channelName: 'C', thumbnailUrl: 'a.jpg', streamUrl: 'http://s.com');
        const b = YouTubeVideo(id: '1', title: 'A', channelName: 'C', thumbnailUrl: 'b.jpg', streamUrl: 'http://s.com');
        expect(a, isNot(equals(b)));
      });
    });

    group('props', () {
      test('contains all fields', () {
        const video = YouTubeVideo(
          id: '1', title: 'T', channelName: 'C',
          thumbnailUrl: 'thumb.jpg', duration: Duration(minutes: 5),
          streamUrl: 'http://s.com',
        );
        expect(video.props, ['1', 'T', 'C', 'thumb.jpg', const Duration(minutes: 5), 'http://s.com']);
      });
    });
  });
}
