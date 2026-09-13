import 'package:permission_handler/permission_handler.dart';
import '../../../core/utils/logger.dart';

class PermissionService {
  Future<bool> requestVideoPermission() async {
    try {
      final status = await Permission.videos.status;
      if (status.isGranted) return true;

      final result = await Permission.videos.request();
      if (result.isGranted) return true;

      if (result.isPermanentlyDenied) {
        AppLogger.warning('Video permission permanently denied');
        return false;
      }

      return result.isGranted;
    } catch (e) {
      AppLogger.error('Failed to request video permission', error: e);
      return false;
    }
  }

  Future<bool> requestStoragePermission() async {
    try {
      if (await Permission.videos.status.isGranted) return true;
      if (await Permission.photos.status.isGranted) return true;

      final result = await [
        Permission.videos,
        Permission.photos,
      ].request();

      return result[Permission.videos]?.isGranted == true ||
          result[Permission.photos]?.isGranted == true;
    } catch (e) {
      AppLogger.error('Failed to request storage permission', error: e);
      return false;
    }
  }

  Future<bool> requestAllPermissions() async {
    final video = await requestVideoPermission();
    return video;
  }

  Future<bool> hasVideoPermission() async {
    return await Permission.videos.status.isGranted ||
        await Permission.photos.status.isGranted;
  }
}
