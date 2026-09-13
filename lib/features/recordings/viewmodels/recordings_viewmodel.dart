import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/utils/logger.dart';
import '../models/recording_model.dart';
import '../services/recording_service.dart';

class RecordingsState {
  final List<RecordingModel> recordings;
  final String? activeRecordingId;
  final bool isLoading;

  const RecordingsState({
    this.recordings = const [],
    this.activeRecordingId,
    this.isLoading = false,
  });

  RecordingsState copyWith({
    List<RecordingModel>? recordings,
    String? activeRecordingId,
    bool? isLoading,
    bool clearActiveId = false,
  }) {
    return RecordingsState(
      recordings: recordings ?? this.recordings,
      activeRecordingId:
          clearActiveId ? null : (activeRecordingId ?? this.activeRecordingId),
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class RecordingsViewModel extends StateNotifier<RecordingsState> {
  final RecordingService _service;

  RecordingsViewModel(this._service) : super(const RecordingsState());

  Future<void> startRecording({
    required String channelName,
    required String channelUrl,
    String? channelLogo,
  }) async {
    state = state.copyWith(isLoading: true);

    final recording = await _service.startRecording(
      channelName: channelName,
      channelUrl: channelUrl,
      channelLogo: channelLogo,
    );

    state = state.copyWith(
      recordings: [recording, ...state.recordings],
      isLoading: false,
      clearActiveId: true,
    );

    AppLogger.info('Recording completed: ${recording.channelName}');
  }

  void stopRecording(String id) {
    _service.stopRecording(id);
    state = state.copyWith(clearActiveId: true);

    final updated = state.recordings.map((r) {
      if (r.id == id) {
        return r.copyWith(isRecording: false, stoppedAt: DateTime.now());
      }
      return r;
    }).toList();

    state = state.copyWith(recordings: updated);
  }

  Future<void> deleteRecording(RecordingModel recording) async {
    await _service.deleteRecording(recording.filePath);
    state = state.copyWith(
      recordings: state.recordings.where((r) => r.id != recording.id).toList(),
    );
  }

  bool get isRecording => state.activeRecordingId != null;

  String? get activeRecordingId => state.activeRecordingId;

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }
}

final recordingsProvider =
    StateNotifierProvider.autoDispose<RecordingsViewModel, RecordingsState>(
        (ref) {
  return RecordingsViewModel(sl<RecordingService>());
});
