// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:injectable/injectable.dart';
// import 'package:odigov3/framework/dependency_injection/inject.dart';
// import 'package:video_player/video_player.dart';
// import 'package:odigov3/ui/ads_create/web/helper/trim_settings.dart';
//
//
// final videoPlayerControllerProvider = ChangeNotifierProvider(
//       (ref) => getIt<VideoPlayerControllerProvider>(),
// );
//
// @injectable
// class VideoPlayerControllerProvider extends ChangeNotifier {
//   // VideoPlayerController? controller;
//   // bool isInitialized = false;
//   // bool isPlaying = false;
//   // Duration currentPosition = Duration.zero;
//   // TrimSettings? trimSettings;
//
//   // Future<void> initialize({File? videoFile, String? videoUrl, TrimSettings? trim}) async {
//   //   trimSettings = trim;
//   //   if (videoFile == null && videoUrl == null) {
//   //     disposeController();
//   //     return;
//   //   }
//   //
//   //   try {
//   //     disposeController();
//   //
//   //     if (videoUrl != null) {
//   //       controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
//   //     } else if (videoFile != null) {
//   //       controller = VideoPlayerController.file(videoFile);
//   //     }
//   //
//   //     await controller!.initialize();
//   //     controller!.addListener(_videoListener);
//   //
//   //     isInitialized = true;
//   //     notifyListeners();
//   //   } catch (e) {
//   //     isInitialized = false;
//   //     notifyListeners();
//   //   }
//   // }
//   //
//   // void _videoListener() {
//   //   if (controller != null && controller!.value.isInitialized) {
//   //     final position = controller!.value.position;
//   //     if (position != currentPosition) {
//   //       currentPosition = position;
//   //       notifyListeners();
//   //     }
//   //
//   //     if (trimSettings != null && position >= trimSettings!.endTime) {
//   //       controller!.pause();
//   //       isPlaying = false;
//   //       notifyListeners();
//   //     }
//   //   }
//   // }
//   //
//   // void disposeController() {
//   //   controller?.removeListener(_videoListener);
//   //   controller?.dispose();
//   //   controller = null;
//   //   isInitialized = false;
//   //   isPlaying = false;
//   //   currentPosition = Duration.zero;
//   //   notifyListeners();
//   // }
//   //
//   // Future<void> togglePlayPause() async {
//   //   if (controller == null || !controller!.value.isInitialized) return;
//   //
//   //   if (isPlaying) {
//   //     await controller!.pause();
//   //   } else {
//   //     if (trimSettings != null) {
//   //       final currentPos = controller!.value.position;
//   //       if (currentPos < trimSettings!.startTime || currentPos >= trimSettings!.endTime) {
//   //         await controller!.seekTo(trimSettings!.startTime);
//   //       }
//   //     }
//   //     await controller!.play();
//   //   }
//   //
//   //   isPlaying = !isPlaying;
//   //   notifyListeners();
//   // }
//   //
//   // Future<void> seekTo(Duration position) async {
//   //   if (controller != null && controller!.value.isInitialized) {
//   //     await controller!.seekTo(position);
//   //   }
//   // }
//
//
//
//   @override
//   void dispose() {
//     disposeController();
//     super.dispose();
//   }
// }
