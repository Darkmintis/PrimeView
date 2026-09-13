import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/logger.dart';
import '../models/local_video.dart';

class LocalRepository {
  static const _watchHistoryKey = 'watch_history';
  static const _resumePositionsKey = 'resume_positions';

  Box get _box => Hive.box(AppConstants.hiveBoxName);

  Future<void> saveWatchHistory(LocalVideo video) async {
    try {
      final history = getWatchHistory();
      final existingIndex = history.indexWhere((v) => v.id == video.id);
      if (existingIndex >= 0) {
        history[existingIndex] = video;
      } else {
        history.insert(0, video);
      }
      if (history.length > 100) history.removeLast();

      final jsonList = history.map((v) => v.toJson()).toList();
      await _box.put(_watchHistoryKey, jsonEncode(jsonList));
    } catch (e) {
      AppLogger.error('Failed to save watch history', error: e);
    }
  }

  List<LocalVideo> getWatchHistory() {
    try {
      final data = _box.get(_watchHistoryKey);
      if (data == null) return [];
      final jsonList = jsonDecode(data as String) as List;
      return jsonList.map((j) => LocalVideo.fromJson(j as Map<String, dynamic>)).toList();
    } catch (e) {
      AppLogger.error('Failed to get watch history', error: e);
      return [];
    }
  }

  Future<void> saveResumePosition(String videoId, Duration position) async {
    try {
      final data = _box.get(_resumePositionsKey);
      final map = data != null ? Map<String, dynamic>.from(jsonDecode(data as String)) : <String, dynamic>{};
      map[videoId] = position.inMilliseconds;
      await _box.put(_resumePositionsKey, jsonEncode(map));
    } catch (e) {
      AppLogger.error('Failed to save resume position', error: e);
    }
  }

  Duration getResumePosition(String videoId) {
    try {
      final data = _box.get(_resumePositionsKey);
      if (data == null) return Duration.zero;
      final map = jsonDecode(data as String) as Map<String, dynamic>;
      final ms = map[videoId] as int?;
      return ms != null ? Duration(milliseconds: ms) : Duration.zero;
    } catch (e) {
      return Duration.zero;
    }
  }

  Future<void> removeWatchHistory(String videoId) async {
    try {
      final history = getWatchHistory();
      history.removeWhere((v) => v.id == videoId);
      final jsonList = history.map((v) => v.toJson()).toList();
      await _box.put(_watchHistoryKey, jsonEncode(jsonList));
    } catch (e) {
      AppLogger.error('Failed to remove watch history', error: e);
    }
  }

  Future<void> clearHistory() async {
    try {
      await _box.delete(_watchHistoryKey);
      await _box.delete(_resumePositionsKey);
    } catch (e) {
      AppLogger.error('Failed to clear history', error: e);
    }
  }
}
