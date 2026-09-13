import 'package:equatable/equatable.dart';

class RecordingModel extends Equatable {
  final String id;
  final String channelName;
  final String channelUrl;
  final String? channelLogo;
  final String filePath;
  final DateTime startedAt;
  final DateTime? stoppedAt;
  final bool isRecording;
  final int fileSizeBytes;

  const RecordingModel({
    required this.id,
    required this.channelName,
    required this.channelUrl,
    this.channelLogo,
    required this.filePath,
    required this.startedAt,
    this.stoppedAt,
    this.isRecording = true,
    this.fileSizeBytes = 0,
  });

  RecordingModel copyWith({
    String? id,
    String? channelName,
    String? channelUrl,
    String? channelLogo,
    String? filePath,
    DateTime? startedAt,
    DateTime? stoppedAt,
    bool? isRecording,
    int? fileSizeBytes,
  }) {
    return RecordingModel(
      id: id ?? this.id,
      channelName: channelName ?? this.channelName,
      channelUrl: channelUrl ?? this.channelUrl,
      channelLogo: channelLogo ?? this.channelLogo,
      filePath: filePath ?? this.filePath,
      startedAt: startedAt ?? this.startedAt,
      stoppedAt: stoppedAt ?? this.stoppedAt,
      isRecording: isRecording ?? this.isRecording,
      fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
    );
  }

  Duration get duration {
    final end = stoppedAt ?? DateTime.now();
    return end.difference(startedAt);
  }

  String get fileSizeFormatted {
    if (fileSizeBytes < 1024) return '$fileSizeBytes B';
    if (fileSizeBytes < 1024 * 1024) {
      return '${(fileSizeBytes / 1024).toStringAsFixed(1)} KB';
    }
    if (fileSizeBytes < 1024 * 1024 * 1024) {
      return '${(fileSizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(fileSizeBytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  @override
  List<Object?> get props => [
        id,
        channelName,
        channelUrl,
        channelLogo,
        filePath,
        startedAt,
        stoppedAt,
        isRecording,
        fileSizeBytes,
      ];
}
