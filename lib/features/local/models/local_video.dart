import 'package:equatable/equatable.dart';

class LocalVideo extends Equatable {
  final String id;
  final String title;
  final String path;
  final String? folderPath;
  final Duration duration;
  final int fileSize;
  final DateTime dateAdded;
  final DateTime? dateModified;
  final String? thumbnailPath;
  final Duration lastPosition;
  final bool isFullyWatched;

  const LocalVideo({
    required this.id,
    required this.title,
    required this.path,
    this.folderPath,
    this.duration = Duration.zero,
    this.fileSize = 0,
    required this.dateAdded,
    this.dateModified,
    this.thumbnailPath,
    this.lastPosition = Duration.zero,
    this.isFullyWatched = false,
  });

  String get durationFormatted {
    final h = duration.inHours;
    final m = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return h > 0 ? '$h:$m:$s' : '$m:$s';
  }

  String get fileSizeFormatted {
    if (fileSize < 1024) return '$fileSize B';
    if (fileSize < 1024 * 1024) return '${(fileSize / 1024).toStringAsFixed(1)} KB';
    if (fileSize < 1024 * 1024 * 1024) return '${(fileSize / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(fileSize / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  double get progress {
    if (duration.inSeconds == 0) return 0;
    return (lastPosition.inSeconds / duration.inSeconds).clamp(0.0, 1.0);
  }

  LocalVideo copyWith({
    String? id,
    String? title,
    String? path,
    String? folderPath,
    Duration? duration,
    int? fileSize,
    DateTime? dateAdded,
    DateTime? dateModified,
    String? thumbnailPath,
    Duration? lastPosition,
    bool? isFullyWatched,
  }) {
    return LocalVideo(
      id: id ?? this.id,
      title: title ?? this.title,
      path: path ?? this.path,
      folderPath: folderPath ?? this.folderPath,
      duration: duration ?? this.duration,
      fileSize: fileSize ?? this.fileSize,
      dateAdded: dateAdded ?? this.dateAdded,
      dateModified: dateModified ?? this.dateModified,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      lastPosition: lastPosition ?? this.lastPosition,
      isFullyWatched: isFullyWatched ?? this.isFullyWatched,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'path': path,
    'folderPath': folderPath,
    'durationMs': duration.inMilliseconds,
    'fileSize': fileSize,
    'dateAdded': dateAdded.toIso8601String(),
    'dateModified': dateModified?.toIso8601String(),
    'thumbnailPath': thumbnailPath,
    'lastPositionMs': lastPosition.inMilliseconds,
    'isFullyWatched': isFullyWatched,
  };

  factory LocalVideo.fromJson(Map<String, dynamic> json) => LocalVideo(
    id: json['id'] as String,
    title: json['title'] as String,
    path: json['path'] as String,
    folderPath: json['folderPath'] as String?,
    duration: Duration(milliseconds: json['durationMs'] as int? ?? 0),
    fileSize: json['fileSize'] as int? ?? 0,
    dateAdded: DateTime.parse(json['dateAdded'] as String),
    dateModified: json['dateModified'] != null ? DateTime.parse(json['dateModified'] as String) : null,
    thumbnailPath: json['thumbnailPath'] as String?,
    lastPosition: Duration(milliseconds: json['lastPositionMs'] as int? ?? 0),
    isFullyWatched: json['isFullyWatched'] as bool? ?? false,
  );

  @override
  List<Object?> get props => [id, title, path, duration, fileSize, lastPosition, isFullyWatched];
}
