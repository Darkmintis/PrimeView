import 'package:equatable/equatable.dart';

class YouTubeVideo extends Equatable {
  final String id;
  final String title;
  final String channelName;
  final String? thumbnailUrl;
  final Duration duration;
  final String streamUrl;

  const YouTubeVideo({
    required this.id,
    required this.title,
    required this.channelName,
    this.thumbnailUrl,
    this.duration = Duration.zero,
    required this.streamUrl,
  });

  String get durationFormatted {
    if (duration.inHours > 0) {
      return '${duration.inHours}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
    }
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  List<Object?> get props => [id, title, channelName, thumbnailUrl, duration, streamUrl];
}
