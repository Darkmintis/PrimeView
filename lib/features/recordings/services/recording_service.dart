import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../../../core/utils/logger.dart';
import '../models/recording_model.dart';

class RecordingService {
  final Dio _dio = Dio();
  final Map<String, CancelToken> _activeTokens = {};
  final Map<String, StreamSubscription<List<int>>> _activeStreams = {};

  static const _uuid = Uuid();

  Future<RecordingModel> startRecording({
    required String channelName,
    required String channelUrl,
    String? channelLogo,
  }) async {
    final dir = await getApplicationDocumentsDirectory();
    final recordingsDir = Directory('${dir.path}/recordings');
    if (!await recordingsDir.exists()) {
      await recordingsDir.create(recursive: true);
    }

    final id = _uuid.v4();
    final fileName = '${channelName.replaceAll(RegExp(r'[^\w\s-]'), '')}_$id.ts';
    final filePath = '${recordingsDir.path}/$fileName';

    final recording = RecordingModel(
      id: id,
      channelName: channelName,
      channelUrl: channelUrl,
      channelLogo: channelLogo,
      filePath: filePath,
      startedAt: DateTime.now(),
    );

    final cancelToken = CancelToken();
    _activeTokens[id] = cancelToken;

    try {
      await _dio.download(
        channelUrl,
        filePath,
        cancelToken: cancelToken,
        options: Options(
          receiveTimeout: const Duration(minutes: 30),
          headers: {
            'User-Agent': 'PrimeView/0.2.0',
          },
        ),
      );

      AppLogger.info('Recording saved: $filePath');
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        AppLogger.info('Recording cancelled: $channelName');
      } else {
        AppLogger.error('Recording failed', error: e);
      }
    } catch (e) {
      AppLogger.error('Recording error', error: e);
    }

    return recording.copyWith(
      isRecording: false,
      stoppedAt: DateTime.now(),
    );
  }

  void stopRecording(String id) {
    final token = _activeTokens.remove(id);
    token?.cancel('User stopped recording');
  }

  Future<void> deleteRecording(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      AppLogger.error('Failed to delete recording', error: e);
    }
  }

  bool isRecording(String id) {
    return _activeTokens.containsKey(id);
  }

  void dispose() {
    for (final token in _activeTokens.values) {
      token.cancel('Service disposed');
    }
    _activeTokens.clear();
    for (final sub in _activeStreams.values) {
      sub.cancel();
    }
    _activeStreams.clear();
    _dio.close();
  }
}
