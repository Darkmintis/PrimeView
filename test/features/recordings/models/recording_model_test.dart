import 'package:flutter_test/flutter_test.dart';
import 'package:primeview/features/recordings/models/recording_model.dart';

void main() {
  group('RecordingModel', () {
    final baseTime = DateTime(2025, 1, 15, 10, 0, 0);

    group('constructor', () {
      test('creates with all fields', () {
        final recording = RecordingModel(
          id: 'rec-1',
          channelName: 'BBC News',
          channelUrl: 'http://example.com/bbc.m3u8',
          channelLogo: 'http://example.com/bbc.png',
          filePath: '/recordings/bbc.ts',
          startedAt: baseTime,
          stoppedAt: baseTime.add(const Duration(minutes: 30)),
          isRecording: false,
          fileSizeBytes: 1024 * 1024 * 50,
        );

        expect(recording.id, 'rec-1');
        expect(recording.channelName, 'BBC News');
        expect(recording.channelUrl, 'http://example.com/bbc.m3u8');
        expect(recording.channelLogo, 'http://example.com/bbc.png');
        expect(recording.filePath, '/recordings/bbc.ts');
        expect(recording.startedAt, baseTime);
        expect(recording.stoppedAt, baseTime.add(const Duration(minutes: 30)));
        expect(recording.isRecording, false);
        expect(recording.fileSizeBytes, 1024 * 1024 * 50);
      });

      test('creates with defaults', () {
        final recording = RecordingModel(
          id: 'rec-1',
          channelName: 'BBC',
          channelUrl: 'http://bbc.com',
          filePath: '/path',
          startedAt: baseTime,
        );

        expect(recording.channelLogo, isNull);
        expect(recording.stoppedAt, isNull);
        expect(recording.isRecording, true);
        expect(recording.fileSizeBytes, 0);
      });
    });

    group('copyWith', () {
      test('copies with overrides', () {
        final original = RecordingModel(
          id: 'rec-1',
          channelName: 'BBC',
          channelUrl: 'http://bbc.com',
          filePath: '/path',
          startedAt: baseTime,
        );

        final copy = original.copyWith(
          isRecording: false,
          stoppedAt: baseTime.add(const Duration(minutes: 10)),
          fileSizeBytes: 2048,
        );

        expect(copy.isRecording, false);
        expect(copy.stoppedAt, baseTime.add(const Duration(minutes: 10)));
        expect(copy.fileSizeBytes, 2048);
        expect(copy.id, original.id);
        expect(copy.channelName, original.channelName);
      });
    });

    group('duration', () {
      test('calculates duration with stoppedAt', () {
        final recording = RecordingModel(
          id: 'rec-1',
          channelName: 'BBC',
          channelUrl: 'http://bbc.com',
          filePath: '/path',
          startedAt: baseTime,
          stoppedAt: baseTime.add(const Duration(hours: 1, minutes: 30)),
          isRecording: false,
        );

        expect(recording.duration, const Duration(hours: 1, minutes: 30));
      });

      test('calculates duration when still recording', () {
        final now = DateTime.now();
        final recording = RecordingModel(
          id: 'rec-1',
          channelName: 'BBC',
          channelUrl: 'http://bbc.com',
          filePath: '/path',
          startedAt: now,
          isRecording: true,
        );

        final duration = recording.duration;
        expect(duration.inSeconds, greaterThanOrEqualTo(0));
        expect(duration.inSeconds, lessThanOrEqualTo(5));
      });
    });

    group('fileSizeFormatted', () {
      test('formats bytes', () {
        final recording = RecordingModel(
          id: '1', channelName: 'A', channelUrl: 'http://a.com',
          filePath: '/p', startedAt: baseTime, fileSizeBytes: 512,
        );
        expect(recording.fileSizeFormatted, '512 B');
      });

      test('formats kilobytes', () {
        final recording = RecordingModel(
          id: '1', channelName: 'A', channelUrl: 'http://a.com',
          filePath: '/p', startedAt: baseTime, fileSizeBytes: 2048,
        );
        expect(recording.fileSizeFormatted, '2.0 KB');
      });

      test('formats megabytes', () {
        final recording = RecordingModel(
          id: '1', channelName: 'A', channelUrl: 'http://a.com',
          filePath: '/p', startedAt: baseTime, fileSizeBytes: 1024 * 1024 * 5,
        );
        expect(recording.fileSizeFormatted, '5.0 MB');
      });

      test('formats gigabytes', () {
        final recording = RecordingModel(
          id: '1', channelName: 'A', channelUrl: 'http://a.com',
          filePath: '/p', startedAt: baseTime, fileSizeBytes: 1024 * 1024 * 1024 * 2,
        );
        expect(recording.fileSizeFormatted, '2.0 GB');
      });

      test('formats zero bytes', () {
        final recording = RecordingModel(
          id: '1', channelName: 'A', channelUrl: 'http://a.com',
          filePath: '/p', startedAt: baseTime, fileSizeBytes: 0,
        );
        expect(recording.fileSizeFormatted, '0 B');
      });

      test('formats exact 1 KB boundary', () {
        final recording = RecordingModel(
          id: '1', channelName: 'A', channelUrl: 'http://a.com',
          filePath: '/p', startedAt: baseTime, fileSizeBytes: 1024,
        );
        expect(recording.fileSizeFormatted, '1.0 KB');
      });

      test('formats exact 1 MB boundary', () {
        final recording = RecordingModel(
          id: '1', channelName: 'A', channelUrl: 'http://a.com',
          filePath: '/p', startedAt: baseTime, fileSizeBytes: 1024 * 1024,
        );
        expect(recording.fileSizeFormatted, '1.0 MB');
      });

      test('formats exact 1 GB boundary', () {
        final recording = RecordingModel(
          id: '1', channelName: 'A', channelUrl: 'http://a.com',
          filePath: '/p', startedAt: baseTime, fileSizeBytes: 1024 * 1024 * 1024,
        );
        expect(recording.fileSizeFormatted, '1.0 GB');
      });
    });

    group('equality', () {
      test('equal instances', () {
        final a = RecordingModel(
          id: '1', channelName: 'A', channelUrl: 'http://a.com',
          filePath: '/p', startedAt: baseTime,
        );
        final b = RecordingModel(
          id: '1', channelName: 'A', channelUrl: 'http://a.com',
          filePath: '/p', startedAt: baseTime,
        );
        expect(a, equals(b));
        expect(a.hashCode, equals(b.hashCode));
      });

      test('unequal instances', () {
        final a = RecordingModel(
          id: '1', channelName: 'A', channelUrl: 'http://a.com',
          filePath: '/p', startedAt: baseTime,
        );
        final b = RecordingModel(
          id: '2', channelName: 'B', channelUrl: 'http://b.com',
          filePath: '/q', startedAt: baseTime,
        );
        expect(a, isNot(equals(b)));
      });
    });
  });
}
