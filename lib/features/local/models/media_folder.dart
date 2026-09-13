import 'package:equatable/equatable.dart';

class MediaFolder extends Equatable {
  final String path;
  final String name;
  final int videoCount;
  final String? thumbnailPath;
  final DateTime? dateModified;

  const MediaFolder({
    required this.path,
    required this.name,
    this.videoCount = 0,
    this.thumbnailPath,
    this.dateModified,
  });

  MediaFolder copyWith({
    String? path,
    String? name,
    int? videoCount,
    String? thumbnailPath,
    DateTime? dateModified,
  }) {
    return MediaFolder(
      path: path ?? this.path,
      name: name ?? this.name,
      videoCount: videoCount ?? this.videoCount,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      dateModified: dateModified ?? this.dateModified,
    );
  }

  @override
  List<Object?> get props => [path, name, videoCount];
}
