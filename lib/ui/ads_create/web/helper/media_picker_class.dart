import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/create_ads/create_ads_controller.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/ads_create/web/helper/image_container_widget.dart';
import 'package:odigov3/ui/ads_create/web/helper/video_player_widget.dart';
import 'package:odigov3/ui/ads_create/web/helper/video_timeline.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';
import 'package:odigov3/ui/utils/widgets/common_dialog.dart';
import 'package:odigov3/ui/utils/widgets/common_dialogs.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class MediaPickerClass extends ConsumerStatefulWidget {
  const MediaPickerClass({Key? key}) : super(key: key);

  @override
  ConsumerState<MediaPickerClass> createState() => _MediaPickerClassState();
}

class _MediaPickerClassState extends ConsumerState<MediaPickerClass> {
  ///Build
  @override
  Widget build(BuildContext context) {
    final createAdWatch = ref.watch(createAdsController);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: context.height * 0.024),

        CommonText(title: createAdWatch.mediaIndex == 0 ? LocaleKeys.keyAddImageMax.localized : LocaleKeys.keyAddVideoMax.localized, style: TextStyles.semiBold.copyWith(fontSize: 14)),

        createAdWatch.mediaIndex == 0 ? ImageContainerWidget() : VideoContainer(),
      ],
    );
  }

  VideoContainer() {
    final createAdWatch = ref.watch(createAdsController);
    return Column(
      children: [
        if (createAdWatch.listVideos != [])
          /// To Show Selected Images
          ...List.generate(createAdWatch.listVideos.length, (index) {
            final item = createAdWatch.listVideos[index];
            return Container(
              padding: EdgeInsets.all(context.height * 0.01),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.clrE7EAEE),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  (item.selectedData != null)
                      ? CommonSVG(
                          strIcon: Assets.svgs.svgPlaceholder.keyName,
                          width: context.height * 0.08,
                          height: context.height * 0.08,
                          boxFit: BoxFit.cover,
                        ).paddingAll(4)
                      // Image.memory(
                      //   item.selectedFile!,
                      //   width: context.height * 0.08,
                      //   height: context.height * 0.08,
                      //   fit: BoxFit.cover,
                      // ).paddingAll(4)
                      : Offstage(),

                  SizedBox(width: context.width * 0.02),

                  /// Name & Size Column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CommonText(title: item.documentName ?? '', overflow: TextOverflow.ellipsis, fontWeight: FontWeight.bold),
                        CommonText(
                          title: item.documentSize ?? '',
                          clrFont: AppColors.clr7C7474,
                          fontSize: 12,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  InkWell(
                    onTap: () {
                      if (createAdWatch.tappedIndex != index) {
                        createAdWatch.updateViewerData(item, index);
                        createAdWatch.initialiseVideo(videoBytes: item.selectedData!);
                      } else {
                        createAdWatch.updateViewerData(null, -1);
                        createAdWatch.disposeVideo();
                      }
                    },
                    child: CommonSVG(strIcon: createAdWatch.tappedIndex == index ? Assets.svgs.svgHidePasswordSvg_.keyName : Assets.svgs.svgShowPasswordSvg_.keyName),
                  ).paddingOnly(right: 8),

                  /// Remove Button
                  InkWell(
                    onTap: () {
                      // showLog(str)
                      createAdWatch.removeVideo(index);
                      createAdWatch.updateViewerData(null, -1);
                      createAdWatch.disposeVideo();
                    },
                    child: CommonSVG(strIcon: Assets.svgs.svgClearSearch.path),
                  ).paddingOnly(right: 8),
                ],
              ),
            ).paddingSymmetric(vertical: context.height * 0.01);
          }),

        SizedBox(height: context.height * 0.024),

        /// to select Video
        if (createAdWatch.listVideos.length < 1)
          Column(
            children: [
              /// Document Upload Section
              InkWell(
                onTap: () async {
                  File? result = await createAdWatch.selectVideo(context);
                  if (createAdWatch.errorMessage != null) {
                    if (mounted) {
                      showErrorDialogue(
                        context: context,
                        dismissble: true,
                        buttonText: LocaleKeys.keyOk.localized,
                        onTap: () {
                          Navigator.pop(context);
                        },
                        animation: Assets.anim.animErrorJson.keyName,
                        successMessage: createAdWatch.errorMessage ?? '',
                      );
                    }
                  }
                  showLog("file_pickerfile_pickerfile_picker ${result?.path}");
                  showLog("selectVideoselectVideoselectVideo ${createAdWatch.listVideos.length}");
                  if (result != null) {
                    showCommonWebDialog(
                      context: context,
                      keyBadge: createAdWatch.videoTrimmerDialogKey,
                      dialogBody: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: context.height * 0.01,
                            ),

                            Row(
                              children: [
                                ///Crossed Icon
                                InkWell(
                                  onTap: () {
                                    createAdWatch.disposeVideoController();
                                    createAdWatch.listVideos.clear();
                                    Navigator.pop(context);
                                  },
                                  child: CommonSVG(
                                    strIcon: Assets.svgs.svgLeftArrow.keyName,
                                    height: context.height * 0.020,
                                    width: context.height * 0.020,
                                  ),
                                ),
                                SizedBox(
                                  width: context.width * 0.01,
                                ),

                                CommonText(
                                  title: LocaleKeys.keyTrimVideo.localized,
                                  style: TextStyles.bold.copyWith(
                                    fontSize: 20,
                                    color: AppColors.black,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(
                              height: context.height * 0.01,
                            ),

                            // Video player
                            VideoPlayerWidget(
                              videoFile: kIsWeb ? null : createAdWatch.selectedVideoSource as File?,
                              videoUrl: kIsWeb ? createAdWatch.selectedVideoSource as String? : null,
                              // trimSettings: createAdWatch.trimSettings,
                              onPositionChanged: createAdWatch.onPositionChanged,
                            ),

                            const SizedBox(height: AppConstants.defaultPadding),

                            // Video timeline
                            if (createAdWatch.videoDuration != null)
                              VideoTimeline(
                                // videoDuration: createAdWatch.videoDuration!,
                                trimDuration: const Duration(seconds: AppConstants.defaultTrimDurationSeconds),
                                // trimSettings: createAdWatch.trimSettings,
                                // currentPosition: createAdWatch.currentPosition,
                                onTrimChanged: createAdWatch.onTrimChanged,
                              ),
                            Row(
                              children: [
                                Expanded(
                                  child: CommonButton(
                                    buttonText: LocaleKeys.keyTrimVideo.localized,
                                    isShowLoader: createAdWatch.isVideoTrimming,
                                    onTap: () {
                                      if (!createAdWatch.isVideoTrimming) {
                                        createAdWatch.trim().then(
                                          (value) {
                                            createAdWatch.changeImageErrorVisible(false);
                                            Navigator.pop(context);
                                          },
                                        );
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: AppConstants.defaultPadding),

                                Expanded(
                                  child: CommonButton(
                                    buttonText: LocaleKeys.keySkip.localized,
                                    onTap: () {
                                      createAdWatch.changeImageErrorVisible(false);
                                      // createAdWatch.skipTrimmer();
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ).paddingSymmetric(horizontal: context.width * 0.03, vertical: context.height * 0.03),
                      ),
                      height: 0.8,
                      width: 0.5,
                    );
                  }

                  // if (result != null) {
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     SnackBar(
                  //       content: CommonText(title: result, clrFont: AppColors.white),
                  //     ),
                  //   );
                  // }
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Document Upload Image
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              height: context.height * 0.07,
                              width: context.width,
                              decoration: BoxDecoration(
                                border: Border.all(color: createAdWatch.isImageErrorVisible ? AppColors.red : AppColors.clrE7EAEE),
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.zero,
                                  bottomRight: Radius.zero,
                                  topLeft: Radius.circular(6),
                                  bottomLeft: Radius.circular(6),
                                ),
                              ),
                              child: CommonText(
                                title: LocaleKeys.keySelectAFileOrDragAndDrop.localized,
                                style: TextStyles.medium.copyWith(color: AppColors.clr7C7474, fontSize: 14),
                              ).alignAtCenterLeft().paddingOnly(left: 10),
                            ),
                          ),
                          Container(
                            height: context.height * 0.07,
                            width: context.width * 0.16,
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              color: AppColors.whiteEAEAEA,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.zero,
                                bottomLeft: Radius.zero,
                                topRight: Radius.circular(6),
                                bottomRight: Radius.circular(6),
                              ),
                              border: Border.all(color: AppColors.clrE7EAEE),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CommonSVG(height: context.height * 0.02, strIcon: Assets.svgs.svgUploadImage.path),
                                SizedBox(width: 10),
                                CommonText(
                                  title: LocaleKeys.keyUploadVideo.localized,
                                  style: TextStyles.medium.copyWith(color: AppColors.black, fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              /// Error Text
              Visibility(
                visible: createAdWatch.isImageErrorVisible,
                child: CommonText(
                  title: createAdWatch.mediaIndex == 0 ? LocaleKeys.keyImageShouldBeRequired.localized : LocaleKeys.keyVideoShouldBeRequired.localized,
                  style: TextStyles.medium.copyWith(color: AppColors.red),
                ).alignAtCenterLeft().paddingOnly(top: 5, left: 15),
              ),
            ],
          ),
      ],
    );
  }

  // Future<void> trim() async {
  //   final createAdWatch = ref.watch(createAdsController);
  //   final response = await html.HttpRequest.request(
  //     createAdWatch.selectedVideoSource!,
  //     responseType: 'blob',
  //   );
  //   final blob = response.response as html.Blob;
  //   showLog("createAdWatch.trimSettings!.startTime.inSeconds.toDouble() ${createAdWatch.trimSettings!.startTime.inSeconds.toDouble()}");
  //   showLog("createAdWatch.trimSettings!.startTime.inSeconds.toDouble() ${createAdWatch.trimSettings!.endTime.inSeconds.toDouble()}");
  //   final blobUrl = await trimVideoJS(blob, createAdWatch.trimSettings!.startTime.inSeconds.toDouble(), createAdWatch.trimSettings!.endTime.inSeconds.toDouble());
  //   showLog("blobUrl ${blobUrl}");
  //   // trimVideoJS(blob, 11, 20);
  // }
}
