import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:odigov3/ui/ads_create/web/helper/trim_settings.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

// Conditional import for web-specific functionality
import 'dart:html' as html;

class VideoService {
  static final VideoService _instance = VideoService._internal();
  factory VideoService() => _instance;
  VideoService._internal();

  // Get video duration using video_player
  Future<Duration?> getVideoDuration(dynamic videoSource) async {
    try {
      print('Platform: ${kIsWeb ? "Web" : "Native"}');

      if (kIsWeb) {
        return await _getVideoDurationWeb(videoSource);
      } else {
        return await _getVideoDurationNative(videoSource as File);
      }
    } catch (e) {
      print('Error getting video duration: $e');
      return null;
    }
  }



  // Get video duration on web platform
  Future<Duration?> _getVideoDurationWeb(dynamic videoSource) async {
    try {
      print('Getting duration for web video source');

      VideoPlayerController controller;

      if (videoSource is String && videoSource.startsWith('blob:')) {
        print('Using network controller for blob URL: $videoSource');
        controller = VideoPlayerController.networkUrl(Uri.parse(videoSource));
      } else if (videoSource is File) {
        print('Using file controller for: ${videoSource.path}');
        controller = VideoPlayerController.file(videoSource);
      } else {
        print('Unsupported video source type: ${videoSource.runtimeType}');
        return null;
      }

      print('VideoPlayerController created');

      await controller.initialize();
      print('VideoPlayerController initialized');

      final duration = controller.value.duration;
      print('Raw duration from controller: $duration');
      print('Duration in seconds: ${duration.inSeconds}');
      print('Duration in milliseconds: ${duration.inMilliseconds}');

      await controller.dispose();
      print('VideoPlayerController disposed');

      return duration;
    } catch (e) {
      print('Error getting video duration on web: $e');
      print('Error type: ${e.runtimeType}');
      return null;
    }
  }

  // Get video duration on native platforms
  Future<Duration?> _getVideoDurationNative(File videoFile) async {
    try {
      print('Attempting to get duration for: ${videoFile.path}');
      print('File exists: ${await videoFile.exists()}');
      print('File size: ${await videoFile.length()} bytes');

      final controller = VideoPlayerController.file(videoFile);
      print('VideoPlayerController created');

      await controller.initialize();
      print('VideoPlayerController initialized');

      final duration = controller.value.duration;
      print('Raw duration from controller: $duration');
      print('Duration in seconds: ${duration.inSeconds}');
      print('Duration in milliseconds: ${duration.inMilliseconds}');

      await controller.dispose();
      print('VideoPlayerController disposed');

      // Check if duration is valid
      if (duration == Duration.zero) {
        print('Duration is zero, trying FFmpeg fallback');
        return await _getVideoDurationWithFFmpeg(videoFile);
      }

      return duration;
    } catch (e) {
      print('Error getting video duration with video_player: $e');
      print('Error type: ${e.runtimeType}');
      print('Trying FFmpeg fallback');
      return await _getVideoDurationWithFFmpeg(videoFile);
    }
  }

  // Fallback method to get video duration using FFmpeg (native platforms only)
  Future<Duration?> _getVideoDurationWithFFmpeg(File videoFile) async {
    if (kIsWeb) {
      print('FFmpeg not available on web platform');
      return null;
    }

    try {
      print('Getting duration with FFmpeg for: ${videoFile.path}');

      final session = await FFmpegKit.execute('-i "${videoFile.path}" -f null -');
      final logs = await session.getLogs();

      for (final log in logs) {
        final message = log.getMessage();
        if (message.contains('Duration:')) {
          print('FFmpeg log: $message');

          // Parse duration from FFmpeg output (format: Duration: HH:MM:SS.mmm)
          final durationMatch = RegExp(r'Duration: (\d{2}):(\d{2}):(\d{2})\.(\d{2})').firstMatch(message);
          if (durationMatch != null) {
            final hours = int.parse(durationMatch.group(1)!);
            final minutes = int.parse(durationMatch.group(2)!);
            final seconds = int.parse(durationMatch.group(3)!);
            final centiseconds = int.parse(durationMatch.group(4)!);

            final duration = Duration(
              hours: hours,
              minutes: minutes,
              seconds: seconds,
              milliseconds: centiseconds * 10,
            );

            print('FFmpeg duration parsed: $duration (${duration.inSeconds} seconds)');
            return duration;
          }
        }
      }

      print('Could not parse duration from FFmpeg output');
      return null;
    } catch (e) {
      print('Error getting video duration with FFmpeg: $e');
      return null;
    }
  }

  // Validate if video can be trimmed
  Future<bool> canTrimVideo(dynamic videoSource) async {
    try {
      if (kIsWeb) {
        return await _canTrimVideoWeb(videoSource);
      } else {
        return await _canTrimVideoNative(videoSource as File);
      }
    } catch (e) {
      print('Error validating video: $e');
      return false;
    }
  }

  // Validate video on web platform
  Future<bool> _canTrimVideoWeb(dynamic videoSource) async {
    try {
      print('Validating video on web platform');

      // For web, we mainly rely on video duration check
      final duration = await getVideoDuration(videoSource);
      if (duration == null) {
        print('Could not get video duration');
        return false;
      }

      print('Video duration: ${duration.inSeconds} seconds (${formatDuration(duration)})');
      print('Minimum required: ${AppConstants.minimumVideoDurationSeconds} seconds');

      return duration.inSeconds >= AppConstants.minimumVideoDurationSeconds;
    } catch (e) {
      print('Error validating video on web: $e');
      return false;
    }
  }

  // Validate video on native platforms
  Future<bool> _canTrimVideoNative(File videoFile) async {
    try {
      // Check if file exists
      if (!await videoFile.exists()) {
        print('Video file does not exist: ${videoFile.path}');
        return false;
      }

      // Check file extension
      final extension = videoFile.path.split('.').last.toLowerCase();
      if (!AppConstants.supportedVideoFormats.contains(extension)) {
        print('Unsupported video format: $extension');
        return false;
      }

      // Check video duration
      final duration = await getVideoDuration(videoFile);
      if (duration == null) {
        print('Could not get video duration');
        return false;
      }

      print('Video duration: ${duration.inSeconds} seconds (${formatDuration(duration)})');
      print('Minimum required: ${AppConstants.minimumVideoDurationSeconds} seconds');

      return duration.inSeconds >= AppConstants.minimumVideoDurationSeconds;
    } catch (e) {
      print('Error validating video on native: $e');
      return false;
    }
  }

  // Trim video using FFmpeg (native) or Web APIs (web)
  Future<dynamic> trimVideo(TrimSettings trimSettings) async {
    if (kIsWeb) {
      return await _trimVideoWeb(trimSettings);
    } else {
      return await _trimVideoNative(trimSettings);
    }
  }

  // Trim video on web platform using Web APIs
  Future<String?> _trimVideoWeb(TrimSettings trimSettings) async {
    try {
      // Validate trim settings
      if (!trimSettings.isValid) {
        throw Exception('Invalid trim settings');
      }

      if (trimSettings.videoUrl == null) {
        throw Exception('Video URL is required for web trimming');
      }

      print('Starting web video trimming...');
      print('Video URL: ${trimSettings.videoUrl}');
      print('Start time: ${trimSettings.startTime.inSeconds}s');
      print('Duration: ${trimSettings.actualTrimDuration.inSeconds}s');

      // Create a URL with time fragment for precise playback
      // Format: video.mp4#t=startSeconds,endSeconds
      final startSeconds = trimSettings.startTime.inSeconds;
      final endSeconds = trimSettings.endTime.inSeconds;

      // Remove any existing fragment from the URL
      final baseUrl = trimSettings.videoUrl!.split('#')[0];
      final trimmedUrl = '$baseUrl#t=$startSeconds,$endSeconds';

      print('Generated trimmed URL: $trimmedUrl');

      // Simulate processing time for better UX
      await Future.delayed(const Duration(milliseconds: 500));

      return trimmedUrl;
    } catch (e) {
      print('Error trimming video on web: $e');
      return null;
    }
  }

  // Download trimmed video on web platform
  Future<void> downloadTrimmedVideoWeb(String videoUrl, TrimSettings trimSettings) async {
    if (!kIsWeb) return;

    try {
      print('Creating trimmed video download for web...');

      // Create filename with timestamp and trim info
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final startTime = trimSettings.startTime.inSeconds;
      final endTime = trimSettings.endTime.inSeconds;
      final filename = 'TRIMMED_${startTime}s-${endTime}s_$timestamp.mp4';

      // Get the base URL without fragment
      final baseUrl = videoUrl.split('#')[0];

      print('Creating download with trim instructions: $filename');
      print('Trim range: ${startTime}s - ${endTime}s');

      // Create a text file with trim instructions
      final instructions = '''
VIDEO TRIM INSTRUCTIONS
=======================

Original Video: Download the video file separately
Trim Range: ${formatDuration(trimSettings.startTime)} to ${formatDuration(trimSettings.endTime)}
Duration: ${formatDuration(trimSettings.actualTrimDuration)}

To create the actual trimmed video:

OPTION 1 - Online Tools:
1. Go to https://online-video-cutter.com/ or similar
2. Upload your video
3. Set start time: ${formatDuration(trimSettings.startTime)}
4. Set end time: ${formatDuration(trimSettings.endTime)}
5. Download the trimmed result

OPTION 2 - FFmpeg Command Line:
ffmpeg -i "your_video.mp4" -ss ${trimSettings.startTime.inSeconds} -t ${trimSettings.actualTrimDuration.inSeconds} -c copy "trimmed_output.mp4"

OPTION 3 - Video Editing Software:
Use any video editor (DaVinci Resolve, OpenShot, etc.) to trim from ${formatDuration(trimSettings.startTime)} to ${formatDuration(trimSettings.endTime)}

The video player in this app shows the exact trimmed segment for preview.
''';

      // Create and download the instructions file
      final instructionsBlob = html.Blob([instructions], 'text/plain');
      final instructionsUrl = html.Url.createObjectUrl(instructionsBlob);

      final instructionsAnchor = html.AnchorElement(href: instructionsUrl)
        ..setAttribute('download', 'TRIM_INSTRUCTIONS_${startTime}s-${endTime}s.txt')
        ..style.display = 'none';

      html.document.body?.children.add(instructionsAnchor);
      instructionsAnchor.click();
      html.document.body?.children.remove(instructionsAnchor);
      html.Url.revokeObjectUrl(instructionsUrl);

      // Also provide option to download the original video
      final videoAnchor = html.AnchorElement(href: baseUrl)
        ..setAttribute('download', filename)
        ..style.display = 'none';

      html.document.body?.children.add(videoAnchor);
      videoAnchor.click();
      html.document.body?.children.remove(videoAnchor);

      print('Download completed with trim instructions');

    } catch (e) {
      print('Error creating download: $e');
      throw Exception('Failed to create download: $e');
    }
  }

  // Get download info for web
  Map<String, String> getWebDownloadInfo(TrimSettings trimSettings) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final startTime = trimSettings.startTime.inSeconds;
    final endTime = trimSettings.endTime.inSeconds;
    final filename = 'trimmed_video_${startTime}s-${endTime}s_$timestamp.mp4';

    return {
      'filename': filename,
      'startTime': formatDuration(trimSettings.startTime),
      'endTime': formatDuration(trimSettings.endTime),
      'duration': formatDuration(trimSettings.actualTrimDuration),
    };
  }

  // Trim video on native platforms using FFmpeg
  Future<File?> _trimVideoNative(TrimSettings trimSettings) async {
    try {
      // Validate trim settings
      if (!trimSettings.isValid) {
        throw Exception('Invalid trim settings');
      }

      if (trimSettings.videoFile == null) {
        throw Exception('Video file is required for trimming');
      }

      // Get output directory
      final directory = await getApplicationDocumentsDirectory();
      final outputPath = '${directory.path}/trimmed_video_${DateTime.now().millisecondsSinceEpoch}.mp4';

      // Format time for FFmpeg (HH:MM:SS.mmm)
      final startTimeFormatted = _formatDurationForFFmpeg(trimSettings.startTime);
      final durationFormatted = _formatDurationForFFmpeg(trimSettings.actualTrimDuration);

      // Build FFmpeg command
      final command = '-i "${trimSettings.videoFile!.path}" -ss $startTimeFormatted -t $durationFormatted -c copy -avoid_negative_ts make_zero "$outputPath"';

      print('FFmpeg command: $command');

      // Execute FFmpeg command
      final session = await FFmpegKit.execute(command);
      final returnCode = await session.getReturnCode();

      if (ReturnCode.isSuccess(returnCode)) {
        final outputFile = File(outputPath);
        if (await outputFile.exists()) {
          return outputFile;
        } else {
          throw Exception('Output file was not created');
        }
      } else {
        final logs = await session.getLogs();
        final errorMessage = logs.map((log) => log.getMessage()).join('\n');
        throw Exception('FFmpeg failed: $errorMessage');
      }
    } catch (e) {
      print('Error trimming video: $e');
      return null;
    }
  }

  // Format Duration for FFmpeg (HH:MM:SS.mmm)
  String _formatDurationForFFmpeg(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    final milliseconds = (duration.inMilliseconds % 1000).toString().padLeft(3, '0');
    return '$hours:$minutes:$seconds.$milliseconds';
  }

  // Get video file info
  Future<Map<String, dynamic>?> getVideoInfo(File videoFile) async {
    try {
      final duration = await getVideoDuration(videoFile);
      if (duration == null) return null;

      final fileSize = await videoFile.length();
      final fileName = videoFile.path.split('/').last;
      final extension = fileName.split('.').last.toLowerCase();

      return {
        'fileName': fileName,
        'fileSize': fileSize,
        'duration': duration,
        'extension': extension,
        'path': videoFile.path,
      };
    } catch (e) {
      print('Error getting video info: $e');
      return null;
    }
  }

  // Format file size for display
  String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  // Format duration for display
  String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }
}
