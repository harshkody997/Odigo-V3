
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/create_ads/ads_details_controller.dart';
import 'package:odigov3/framework/repository/client_ads/model/client_ads_details_response_model.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/controller/create_ads/create_ads_controller.dart';
import 'package:odigov3/ui/utils/app_enums.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/cache_image.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';


class AdDetailsShowMediaWidget extends ConsumerStatefulWidget {
  final String adsType;
  const AdDetailsShowMediaWidget({Key? key, required this.adsType}) : super(key: key);

  @override
  ConsumerState<AdDetailsShowMediaWidget> createState() => _AdDetailsShowMediaWidgetState();
}

class _AdDetailsShowMediaWidgetState extends ConsumerState<AdDetailsShowMediaWidget> {

  ///Build
  @override
  Widget build(BuildContext context) {
    final adsDetailsWatch = ref.watch(adsDetailsController);
    String? mediaType = (widget.adsType == AdsType.Client.name) ? adsDetailsWatch.clientAdsDetailState.success?.data?.adsMediaType : adsDetailsWatch.defaultAdsDetailState.success?.data?.adsMediaType;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(title:LocaleKeys.keyMediaDetails.localized, style: TextStyles.semiBold.copyWith(fontSize: 14)),
        SizedBox(height: context.height * 0.015,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CommonText(title: LocaleKeys.keyMediaType.localized, style: TextStyles.regular.copyWith(fontSize: 12, color: AppColors.clr7C7474),),
            CommonText(title: mediaType ?? '', style: TextStyles.regular.copyWith(fontSize: 12),),
          ],
        ),
        SizedBox(height: context.height * 0.02,),

        mediaType == 'IMAGE' ? ImageContainer() : VideoContainer()
      ],
    );
  }

  ImageContainer() {
    final adsDetailsWatch = ref.watch(adsDetailsController);
    List<FileElement> files = (widget.adsType == AdsType.Client.name) ? adsDetailsWatch.clientAdsDetailState.success?.data?.files ?? [] : adsDetailsWatch.defaultAdsDetailState.success?.data?.files ?? [];
    final createAdWatch = ref.watch(createAdsController);
    return files.isEmpty
        ? SizedBox(height: context.height * 0.3, child: Center(child: Text('No Data Found', style: TextStyles.medium)))
        : Column(
      children: [
        if (files != [])
        /// To Show Selected Images
          ...List.generate(files.length, (index) {
            final item = files[index];
            return Container(
              padding: EdgeInsets.all(context.height * 0.01),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.clrE7EAEE),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  (item.fileUrl != null)
                      ? CacheImage(
                    imageURL: item.fileUrl ?? '',
                    width: context.height * 0.08,
                    height: context.height * 0.08,
                    contentMode: BoxFit.cover,
                  ).paddingAll(4)
                      : Offstage(),

                  SizedBox(width: context.width * 0.02),

                  /// Name & Size Column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CommonText(title: item.originalFile ?? '', overflow: TextOverflow.ellipsis, fontWeight: FontWeight.bold),
                      ],
                    ),
                  ),


                  InkWell(
                    onTap: () {
                      if(createAdWatch.tappedIndex != index) {
                        createAdWatch.updateViewerData(DocumentData(documentName: item.originalFile, fileType: FileType.image, fileUrl: item.fileUrl), index);
                      }else{
                        createAdWatch.updateViewerData(null,-1);
                      }
                    },
                    child: CommonSVG(strIcon: createAdWatch.tappedIndex == index ?  Assets.svgs.svgHidePasswordSvg_.keyName: Assets.svgs.svgShowPasswordSvg_.keyName),
                  ).paddingOnly(right: 8),
                ],
              ),
            ).paddingSymmetric(vertical: context.height * 0.01);
          }),
      ],
    );
  }

  VideoContainer() {
    final adsDetailsWatch = ref.watch(adsDetailsController);
    List<FileElement> files = (widget.adsType == AdsType.Client.name) ? adsDetailsWatch.clientAdsDetailState.success?.data?.files ?? [] : adsDetailsWatch.defaultAdsDetailState.success?.data?.files ?? [];
    final createAdWatch = ref.watch(createAdsController);
    return files.isEmpty
        ? SizedBox(height: context.height * 0.3, child: Center(child: Text('No Data Found', style: TextStyles.medium)))
    : Column(
      children: [
        if (files != [])
        /// To Show Selected Images
          ...List.generate(files.length, (index) {
            final item = files[index];
            return Container(
              padding: EdgeInsets.all(context.height * 0.01),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.clrE7EAEE),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  (item.fileUrl != null)
                      ? CommonSVG(strIcon: Assets.svgs.svgPlaceholder.keyName,
                    width: context.height * 0.08,
                    height: context.height * 0.08,
                    boxFit: BoxFit.cover,).paddingAll(4)
                      : Offstage(),

                  SizedBox(width: context.width * 0.02),

                  /// Name & Size Column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CommonText(title: item.originalFile ?? '', overflow: TextOverflow.ellipsis, fontWeight: FontWeight.bold),
                      ],
                    ),
                  ),

                  /// Play/Pause Button
                  if (createAdWatch.viewerDocumentData?.fileType == FileType.video &&
                      createAdWatch.videoController != null &&
                      createAdWatch.videoController!.value.isInitialized)
                    InkWell(
                      onTap: () {
                        createAdWatch.playPausePlayer();

                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(0.6),
                        ),
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          createAdWatch.videoController!.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: Colors.white,
                          size: context.height * 0.015,
                        ),
                      ),
                    ).paddingOnly(right: 8),

                  InkWell(
                    onTap: () {
                      if(createAdWatch.tappedIndex != index) {
                        createAdWatch.updateViewerData(DocumentData(fileUrl: item.fileUrl, fileType: FileType.video, documentName: item.originalFile), index);
                        createAdWatch.initialiseVideo(videoUrl: item.fileUrl);
                      }else{
                        createAdWatch.updateViewerData(null,-1);
                        createAdWatch.disposeVideo();
                      }
                    },
                    child: CommonSVG(strIcon: createAdWatch.tappedIndex == index ?  Assets.svgs.svgHidePasswordSvg_.keyName: Assets.svgs.svgShowPasswordSvg_.keyName),
                  ).paddingOnly(right: 8),

                ],
              ),
            ).paddingSymmetric(vertical: context.height * 0.01);
          }),
      ],
    );
  }
}
