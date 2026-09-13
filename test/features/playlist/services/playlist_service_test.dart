import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:primeview/features/playlist/repositories/playlist_repository.dart';
import 'package:primeview/features/playlist/services/playlist_service.dart';
import 'package:primeview/core/models/channel_model.dart';

class MockPlaylistRepository extends Mock implements PlaylistRepository {}

void main() {
  late PlaylistService service;
  late MockPlaylistRepository mockRepo;

  setUp(() {
    mockRepo = MockPlaylistRepository();
    service = PlaylistService(mockRepo);
  });

  final testChannels = [
    const ChannelModel(id: '1', name: 'BBC', url: 'http://bbc.com', category: 'News'),
    const ChannelModel(id: '2', name: 'CNN', url: 'http://cnn.com', category: 'News'),
    const ChannelModel(id: '3', name: 'ESPN', url: 'http://espn.com', category: 'Sports'),
  ];

  const validM3u = '''#EXTM3U
#EXTINF:-1 group-title="News",BBC
http://bbc.com/stream.m3u8
#EXTINF:-1 group-title="Sports",ESPN
http://espn.com/stream.m3u8''';

  group('PlaylistService', () {
    group('loadFromCache', () {
      test('returns cached channels', () {
        when(() => mockRepo.getCachedPlaylist()).thenReturn(testChannels);

        final result = service.loadFromCache();

        expect(result, isNotNull);
        expect(result!.length, 3);
        verify(() => mockRepo.getCachedPlaylist()).called(1);
      });

      test('returns null when no cache', () {
        when(() => mockRepo.getCachedPlaylist()).thenReturn(null);

        final result = service.loadFromCache();

        expect(result, isNull);
      });
    });

    group('loadFromUrl', () {
      test('fetches, parses, and caches channels', () async {
        when(() => mockRepo.fetchRawPlaylist('http://playlist.com/m3u'))
            .thenAnswer((_) async => validM3u);
        when(() => mockRepo.cachePlaylist(any())).thenAnswer((_) async {});

        final result = await service.loadFromUrl('http://playlist.com/m3u');

        expect(result.length, 2);
        expect(result[0].name, 'BBC');
        expect(result[1].name, 'ESPN');
        verify(() => mockRepo.fetchRawPlaylist('http://playlist.com/m3u')).called(1);
        verify(() => mockRepo.cachePlaylist(any())).called(1);
      });

      test('does not cache empty results', () async {
        when(() => mockRepo.fetchRawPlaylist('http://empty.com'))
            .thenAnswer((_) async => 'no valid channels');

        final result = await service.loadFromUrl('http://empty.com');

        expect(result, isEmpty);
        verifyNever(() => mockRepo.cachePlaylist(any()));
      });

      test('propagates network errors', () async {
        when(() => mockRepo.fetchRawPlaylist(any()))
            .thenThrow(Exception('Network error'));

        expect(
          () => service.loadFromUrl('http://fail.com'),
          throwsException,
        );
      });
    });

    group('loadFromFile', () {
      test('parses M3U content and caches', () async {
        when(() => mockRepo.cachePlaylist(any())).thenAnswer((_) async {});

        final result = await service.loadFromFile(validM3u);

        expect(result.length, 2);
        verify(() => mockRepo.cachePlaylist(any())).called(1);
      });

      test('returns empty for invalid content', () async {
        final result = await service.loadFromFile('not m3u');

        expect(result, isEmpty);
        verifyNever(() => mockRepo.cachePlaylist(any()));
      });
    });

    group('fetchFromIptvOrg', () {
      test('fetches main playlist on first attempt', () async {
        when(() => mockRepo.fetchRawPlaylist('https://iptv-org.github.io/iptv/index.m3u'))
            .thenAnswer((_) async => validM3u);
        when(() => mockRepo.cachePlaylist(any())).thenAnswer((_) async {});

        final result = await service.fetchFromIptvOrg();

        expect(result.length, 2);
        verify(() => mockRepo.cachePlaylist(any())).called(1);
      });

      test('falls back to category playlists on failure', () async {
        when(() => mockRepo.fetchRawPlaylist('https://iptv-org.github.io/iptv/index.m3u'))
            .thenThrow(Exception('fail'));
        for (final url in [
          'https://iptv-org.github.io/iptv/categories/entertainment.m3u',
          'https://iptv-org.github.io/iptv/categories/sports.m3u',
          'https://iptv-org.github.io/iptv/categories/news.m3u',
          'https://iptv-org.github.io/iptv/categories/movies.m3u',
          'https://iptv-org.github.io/iptv/categories/music.m3u',
          'https://iptv-org.github.io/iptv/categories/kids.m3u',
        ]) {
          when(() => mockRepo.fetchRawPlaylist(url))
              .thenAnswer((_) async => '#EXTM3U\n#EXTINF:-1,Test\nhttp://test.com');
        }
        when(() => mockRepo.cachePlaylist(any())).thenAnswer((_) async {});

        final result = await service.fetchFromIptvOrg();

        expect(result, isNotEmpty);
      });

      test('returns empty when all fetches fail', () async {
        when(() => mockRepo.fetchRawPlaylist(any())).thenThrow(Exception('fail'));

        final result = await service.fetchFromIptvOrg();

        expect(result, isEmpty);
      });
    });
  });
}
