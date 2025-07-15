import 'dart:io';

class TrimSettings {
  final File? videoFile;
  final String? videoUrl;
  final Duration startTime;
  final Duration endTime;
  final Duration trimDuration;
  final Duration videoDuration;
  final int? videoFileSizeInBytes;

  const TrimSettings({
    this.videoFile,
    this.videoUrl,
    required this.startTime,
    required this.endTime,
    required this.trimDuration,
    required this.videoDuration,
    this.videoFileSizeInBytes,
  }) : assert(videoFile != null || videoUrl != null, 'Either videoFile or videoUrl must be provided');

  // Create trim settings with start time and automatic end time calculation
  factory TrimSettings.fromStartTime({
    File? videoFile,
    String? videoUrl,
    required Duration startTime,
    required Duration trimDuration,
    required Duration videoDuration,
    int? videoFileSizeInBytes,
  }) {
    // Calculate end time, ensuring it doesn't exceed video duration
    Duration calculatedEndTime = startTime + trimDuration;
    if (calculatedEndTime > videoDuration) {
      calculatedEndTime = videoDuration;
    }

    return TrimSettings(
      videoFile: videoFile,
      videoUrl: videoUrl,
      startTime: startTime,
      endTime: calculatedEndTime,
      trimDuration: calculatedEndTime - startTime,
      videoDuration: videoDuration,
      videoFileSizeInBytes: videoFileSizeInBytes,
    );
  }

  // Create trim settings with end time and automatic start time calculation
  factory TrimSettings.fromEndTime({
    File? videoFile,
    String? videoUrl,
    required Duration endTime,
    required Duration trimDuration,
    required Duration videoDuration,
    int? videoFileSizeInBytes,
  }) {
    // Calculate start time, ensuring it's not negative
    Duration calculatedStartTime = endTime - trimDuration;
    if (calculatedStartTime < Duration.zero) {
      calculatedStartTime = Duration.zero;
    }

    return TrimSettings(
      videoFile: videoFile,
      videoUrl: videoUrl,
      startTime: calculatedStartTime,
      endTime: endTime,
      trimDuration: endTime - calculatedStartTime,
      videoDuration: videoDuration,
      videoFileSizeInBytes: videoFileSizeInBytes,
    );
  }

  // Copy with new values
  TrimSettings copyWith({
    File? videoFile,
    String? videoUrl,
    Duration? startTime,
    Duration? endTime,
    Duration? trimDuration,
    Duration? videoDuration,
    int? videoFileSizeInBytes,
  }) {
    return TrimSettings(
      videoFile: videoFile ?? this.videoFile,
      videoUrl: videoUrl ?? this.videoUrl,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      trimDuration: trimDuration ?? this.trimDuration,
      videoDuration: videoDuration ?? this.videoDuration,
      videoFileSizeInBytes: videoFileSizeInBytes ?? this.videoFileSizeInBytes,
    );
  }

  // Check if the trim settings are valid
  bool get isValid {
    return startTime >= Duration.zero &&
        endTime <= videoDuration &&
        startTime < endTime &&
        trimDuration > Duration.zero;
  }

  // Get the actual trim duration (might be less than requested if near end of video)
  Duration get actualTrimDuration => endTime - startTime;

  // Get start time as percentage of total video duration
  double get startTimePercentage => startTime.inMilliseconds / videoDuration.inMilliseconds;

  // Get end time as percentage of total video duration
  double get endTimePercentage => endTime.inMilliseconds / videoDuration.inMilliseconds;

  @override
  String toString() {
    final source = videoFile?.path ?? videoUrl ?? 'unknown';
    final size = videoFileSizeInBytes != null ? '$videoFileSizeInBytes bytes' : 'unknown size';
    return 'TrimSettings(source: $source, startTime: $startTime, endTime: $endTime, trimDuration: $trimDuration, videoDuration: $videoDuration, size: $size)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TrimSettings &&
        other.videoFile?.path == videoFile?.path &&
        other.videoUrl == videoUrl &&
        other.startTime == startTime &&
        other.endTime == endTime &&
        other.trimDuration == trimDuration &&
        other.videoDuration == videoDuration &&
        other.videoFileSizeInBytes == videoFileSizeInBytes;
  }

  @override
  int get hashCode {
    return Object.hash(
      videoFile?.path,
      videoUrl,
      startTime,
      endTime,
      trimDuration,
      videoDuration,
      videoFileSizeInBytes,
    );
  }
}
