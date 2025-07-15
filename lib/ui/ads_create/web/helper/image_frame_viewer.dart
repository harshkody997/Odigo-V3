import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';
import 'package:hive/hive.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/controller/create_ads/create_ads_controller.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/widgets/cache_image.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:video_player/video_player.dart';

class ImageFrameViewer extends ConsumerStatefulWidget {
  const ImageFrameViewer({Key? key}) : super(key: key);

  @override
  ConsumerState<ImageFrameViewer> createState() => _OdigoFrameViewerState();
}

class _OdigoFrameViewerState extends ConsumerState<ImageFrameViewer> {
  ///Init
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {});
  }

  ///Dispose
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  ///Build
  @override
  Widget build(BuildContext context) {
    final createAdsWatch = ref.watch(createAdsController);
    return Container(
      child: SizedBox(
        height: context.height / 1.5,
        width: context.width / 3,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CommonSVG(
              strIcon: Assets.svgs.svgOdigoFrame.keyName,
              boxFit: BoxFit.contain,
              height: context.height * 0.791,
              width: context.width * 0.412,
            ),
            if (createAdsWatch.viewerDocumentData != null)
              Container(
                height: context.height * 0.455,
                width: context.width * 0.135,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.black, width: 1.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Placeholder while video initializes
                      if (createAdsWatch.viewerDocumentData?.fileType == FileType.video)
                        if (createAdsWatch.videoController == null ||
                            !createAdsWatch.videoController!.value.isInitialized)
                          Center(
                            child: CommonSVG(
                              strIcon: Assets.svgs.svgPlaceholder.keyName,
                              boxFit: BoxFit.cover,
                            ),
                          )
                        else
                          SizedBox.expand(
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: SizedBox(
                                width: createAdsWatch.videoController!.value.size.width,
                                height: createAdsWatch.videoController!.value.size.height,
                                child: VideoPlayer(createAdsWatch.videoController!),
                              ),
                            ),
                          ),
                      // Image fallback if not a video
                      if (createAdsWatch.viewerDocumentData?.fileType != FileType.video)
                        createAdsWatch.viewerDocumentData?.fileUrl != null
                        ? CacheImage(
                            imageURL: createAdsWatch.viewerDocumentData?.fileUrl ?? '',
                          contentMode: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        )
                        : Image.memory(
                          createAdsWatch.viewerDocumentData!.selectedData!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),

                      // Play/Pause Button
                      // if (createAdsWatch.viewerDocumentData?.fileType == FileType.video &&
                      //     createAdsWatch.videoController != null &&
                      //     createAdsWatch.videoController!.value.isInitialized)
                      //   InkWell(
                      //     onTap: () {
                      //       createAdsWatch.playPausePlayer();
                      //
                      //     },
                      //     child: Container(
                      //       decoration: BoxDecoration(
                      //         shape: BoxShape.circle,
                      //         color: Colors.black.withOpacity(0.6),
                      //       ),
                      //       padding: EdgeInsets.all(8),
                      //       child: Icon(
                      //         createAdsWatch.videoController!.value.isPlaying
                      //             ? Icons.pause
                      //             : Icons.play_arrow,
                      //         color: Colors.white,
                      //         size: 20,
                      //       ),
                      //     ),
                      //   ),
                    ],
                  ),
                ),
              ).paddingOnly(bottom: context.height * 0.095),
          ],
        ),
      ),
    )
        .paddingOnly(top: context.height * 0.07);
  }
}
