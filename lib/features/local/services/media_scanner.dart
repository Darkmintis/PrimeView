import 'package:photo_manager/photo_manager.dart';
import '../../../core/utils/logger.dart';
import '../models/local_video.dart';
import '../models/media_folder.dart';

class MediaScanner {
  List<AssetPathEntity>? _cachedPaths;

  Future<List<AssetPathEntity>> _getAssetPaths() async {
    if (_cachedPaths != null) return _cachedPaths!;
    try {
      _cachedPaths = await PhotoManager.getAssetPathList(type: RequestType.video);
      return _cachedPaths!;
    } catch (e) {
      AppLogger.error('Failed to get asset paths', error: e);
      return [];
    }
  }

  Future<List<LocalVideo>> scanAllVideos() async {
    try {
      final paths = await _getAssetPaths();
      if (paths.isEmpty) return [];

      final allVideos = <LocalVideo>[];
      for (final path in paths) {
        final assets = await path.getAssetListRange(start: 0, end: await path.assetCountAsync);
        for (final asset in assets) {
          final file = await asset.originFile;
          if (file == null) continue;

          final fileSize = await asset.fileSize;
          final localVideo = LocalVideo(
            id: asset.id,
            title: asset.title ?? asset.id,
            path: file.path,
            folderPath: asset.relativePath,
            duration: Duration(seconds: asset.duration),
            fileSize: fileSize,
            dateAdded: asset.createDateTime,
            dateModified: asset.modifiedDateTime,
            thumbnailPath: file.path,
          );
          allVideos.add(localVideo);
        }
      }

      allVideos.sort((a, b) => b.dateAdded.compareTo(a.dateAdded));
      AppLogger.info('Scanned ${allVideos.length} videos');
      return allVideos;
    } catch (e) {
      AppLogger.error('Failed to scan videos', error: e);
      return [];
    }
  }

  Future<List<MediaFolder>> scanFolders() async {
    try {
      final paths = await _getAssetPaths();
      if (paths.isEmpty) return [];

      final folderMap = <String, int>{};
      for (final path in paths) {
        final assets = await path.getAssetListRange(start: 0, end: await path.assetCountAsync);
        for (final asset in assets) {
          final folder = asset.relativePath ?? 'Unknown';
          folderMap[folder] = (folderMap[folder] ?? 0) + 1;
        }
      }

      final folders = folderMap.entries.map((e) {
        final name = e.key.split('/').where((s) => s.isNotEmpty).last;
        return MediaFolder(
          path: e.key,
          name: name.isEmpty ? 'Videos' : name,
          videoCount: e.value,
        );
      }).toList();

      folders.sort((a, b) => b.videoCount.compareTo(a.videoCount));
      AppLogger.info('Found ${folders.length} folders with videos');
      return folders;
    } catch (e) {
      AppLogger.error('Failed to scan folders', error: e);
      return [];
    }
  }

  Future<List<LocalVideo>> scanFolder(String folderPath) async {
    try {
      final paths = await _getAssetPaths();
      final videos = <LocalVideo>[];

      for (final path in paths) {
        final assets = await path.getAssetListRange(start: 0, end: await path.assetCountAsync);
        for (final asset in assets) {
          if (asset.relativePath != folderPath) continue;
          final file = await asset.originFile;
          if (file == null) continue;

          final fileSize = await asset.fileSize;
          videos.add(LocalVideo(
            id: asset.id,
            title: asset.title ?? asset.id,
            path: file.path,
            folderPath: asset.relativePath,
            duration: Duration(seconds: asset.duration),
            fileSize: fileSize,
            dateAdded: asset.createDateTime,
            dateModified: asset.modifiedDateTime,
            thumbnailPath: file.path,
          ));
        }
      }

      videos.sort((a, b) => b.dateAdded.compareTo(a.dateAdded));
      return videos;
    } catch (e) {
      AppLogger.error('Failed to scan folder: $folderPath', error: e);
      return [];
    }
  }

  void clearCache() {
    _cachedPaths = null;
  }
}
