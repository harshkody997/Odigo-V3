import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/create_ads/create_ads_controller.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/ui/ads_create/video_player_controller.dart';
import 'package:odigov3/ui/ads_create/web/helper/trim_settings.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends ConsumerStatefulWidget {
  final File? videoFile;
  final String? videoUrl;
  // final TrimSettings? trimSettings;
  final VoidCallback? onVideoLoaded;
  final Function(Duration)? onPositionChanged;

  const VideoPlayerWidget({
    super.key,
    this.videoFile,
    this.videoUrl,
    // this.trimSettings,
    this.onVideoLoaded,
    this.onPositionChanged,
  });

  @override
  ConsumerState<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends ConsumerState<VideoPlayerWidget> {

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _initializeVideo();
    },);
  }

  // @override
  // void didUpdateWidget(VideoPlayerWidget oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   if (widget.videoFile != oldWidget.videoFile || widget.videoUrl != oldWidget.videoUrl) {
  //     _initializeVideo();
  //   }
  // }

  Future<void> _initializeVideo() async {
    final createAdRead = ref.watch(createAdsController);
    if (widget.videoFile == null && widget.videoUrl == null) {
      createAdRead.disposeVideoController();
      return;
    }

    try {
      createAdRead.disposeVideoController();

      if (widget.videoUrl != null) {
        print('Initializing video player with URL: ${widget.videoUrl}');
        createAdRead.controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl!));
      } else if (widget.videoFile != null) {
        print('Initializing video player with file: ${widget.videoFile!.path}');
        createAdRead.controller = VideoPlayerController.file(widget.videoFile!);
      }

      await createAdRead.controller!.initialize();

      createAdRead.controller!.addListener(_videoListener);

      if (mounted) {
          createAdRead.updateInitialization(true);
      }

      widget.onVideoLoaded?.call();
    } catch (e) {
      print('Error initializing video: $e');
      if (mounted) {
        createAdRead.updateInitialization(false);
      }
    }
  }

  void _videoListener() {
    final createAdRead = ref.watch(createAdsController);

    if (createAdRead.controller != null && createAdRead.controller!.value.isInitialized && mounted) {
      final position = createAdRead.controller!.value.position;
      if (position != createAdRead.currentPosition) {
        createAdRead.updateCurrentPosition(position);

        widget.onPositionChanged?.call(position);
      }

      // Check if we've reached the end of the trim segment
      if (createAdRead.trimSettings != null && position >= createAdRead.trimSettings!.endTime) {
        createAdRead.controller!.pause();
        createAdRead.updatePlayingStatus(false);
      }
    }
  }

  @override
  void dispose() {
    // final controllerProvider = ref.read(createAdsController);
    // controllerProvider.disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controllerState = ref.watch(createAdsController);
    if (widget.videoFile == null && widget.videoUrl == null) {
      return _buildPlaceholder();
    }

    if (!controllerState.isInitialized) {
      return _buildLoading();
    }


    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: context.width * 0.4,
          height: context.height * 0.4,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: VideoPlayer(controllerState.controller!),
          ),
        ).paddingOnly(top: context.height * 0.01,),
        Positioned.fill(
          child: GestureDetector(
            onTap: controllerState.togglePlayPause,
            child: Container(
              color: Colors.transparent,
              child: Center(
                child: AnimatedOpacity(
                  opacity: controllerState.isPlaying ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      controllerState.isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        // if (controllerState.trimSettings != null)
        //   Positioned(
        //     bottom: 8,
        //     left: 8,
        //     right: 8,
        //     child: Container(
        //       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        //       decoration: BoxDecoration(
        //         color: Colors.black54,
        //         borderRadius: BorderRadius.circular(4),
        //       ),
        //       child: Text(
        //         'Trim: ${_formatDuration(controllerState.trimSettings!.startTime)} - ${_formatDuration(controllerState.trimSettings!.endTime)}',
        //         style: const TextStyle(
        //           color: Colors.white,
        //           fontSize: 12,
        //         ),
        //         textAlign: TextAlign.center,
        //       ),
        //     ),
        //   ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      height: AppConstants.maxVideoPlayerHeight,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.video_library_outlined,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No video selected',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Container(
      height: AppConstants.maxVideoPlayerHeight,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
