import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import '../../../core/utils/logger.dart';
import '../models/youtube_video.dart';

class YouTubeService {
  final YoutubeExplode _yt = YoutubeExplode();

  Future<List<YouTubeVideo>> search(String query, {int maxResults = 20}) async {
    try {
      final searchList = await _yt.search.search(query, filter: TypeFilters.video);
      final videos = searchList.take(maxResults).map((video) {
        return YouTubeVideo(
          id: video.id.value,
          title: video.title,
          channelName: video.author,
          thumbnailUrl: video.thumbnails.highResUrl,
          duration: video.duration ?? Duration.zero,
          streamUrl: 'https://www.youtube.com/watch?v=${video.id.value}',
        );
      }).toList();

      return videos;
    } catch (e) {
      AppLogger.error('YouTube search failed', error: e);
      return [];
    }
  }

  Future<List<YouTubeVideo>> getTrending({int maxResults = 20}) async {
    try {
      final trending = await _yt.search.search('trending music videos', filter: TypeFilters.video);
      return trending.take(maxResults).map((video) {
        return YouTubeVideo(
          id: video.id.value,
          title: video.title,
          channelName: video.author,
          thumbnailUrl: video.thumbnails.highResUrl,
          duration: video.duration ?? Duration.zero,
          streamUrl: 'https://www.youtube.com/watch?v=${video.id.value}',
        );
      }).toList();
    } catch (e) {
      AppLogger.error('YouTube trending failed', error: e);
      return [];
    }
  }

  Future<List<YouTubeVideo>> getFreeMovies({int maxResults = 20}) async {
    try {
      final results = await _yt.search.search(
        'full movie free no copyright',
        filter: TypeFilters.video,
      );
      return results.take(maxResults).map((video) {
        return YouTubeVideo(
          id: video.id.value,
          title: video.title,
          channelName: video.author,
          thumbnailUrl: video.thumbnails.highResUrl,
          duration: video.duration ?? Duration.zero,
          streamUrl: 'https://www.youtube.com/watch?v=${video.id.value}',
        );
      }).toList();
    } catch (e) {
      AppLogger.error('YouTube free movies search failed', error: e);
      return [];
    }
  }

  Future<String?> getStreamUrl(String videoId) async {
    try {
      final manifest = await _yt.videos.streamsClient.getManifest(videoId);
      final streams = manifest.muxed;
      if (streams.isNotEmpty) {
        return streams.first.url.toString();
      }
      return null;
    } catch (e) {
      AppLogger.error('Failed to get stream URL', error: e);
      return null;
    }
  }

  void dispose() {
    _yt.close();
  }
}
