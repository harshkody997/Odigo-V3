import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/create_ads/ads_details_controller.dart';
import 'package:odigov3/framework/controller/create_ads/create_ads_controller.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_confirmation_dialog.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class MediaDetailsTab extends ConsumerStatefulWidget {
  final String? uuid;

  const MediaDetailsTab({Key? key, this.uuid}) : super(key: key);

  @override
  ConsumerState<MediaDetailsTab> createState() => _MediaDetailsTabState();
}

class _MediaDetailsTabState extends ConsumerState<MediaDetailsTab> {
  ///Build
  @override
  Widget build(BuildContext context) {
    final createAdsWatch = ref.watch(createAdsController);
    final adsDetailsWatch = ref.watch(adsDetailsController);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(title: LocaleKeys.keyMediaDetails.localized, style: TextStyles.semiBold.copyWith(fontSize: 14)),

        SizedBox(height: context.height * 0.024),

        CommonText(title: LocaleKeys.keyMediaType.localized, style: TextStyles.semiBold.copyWith(fontSize: 14)),

        SizedBox(height: context.height * 0.024),

        if (widget.uuid?.isNotEmpty ?? false) ...{
          Row(
            children: [
              if ((adsDetailsWatch.clientAdsDetailState.success?.data?.adsMediaType == 'IMAGE' || adsDetailsWatch.defaultAdsDetailState.success?.data?.adsMediaType == 'IMAGE') && (widget.uuid?.isNotEmpty ?? false)) ...{
                Expanded(
                  child: (createAdsWatch.listImages.isNotEmpty)
                      ? CommonConfirmationOverlayWidget(
                          title: LocaleKeys.keyAreYouSure.localized,
                          description: LocaleKeys.keyByClickingYesTheSelectedDataWillBeCleared.localized,
                          onButtonTap: (positive) {
                            if (positive) {
                              createAdsWatch.updateMediaIndex(0);
                              createAdsWatch.listImages.clear();
                              createAdsWatch.updateViewerData(null, -1);
                            }
                          },
                          child: _buildImageTab(createAdsWatch),
                        )
                      : _buildImageTab(createAdsWatch),
                ),
              } else ...{
                Expanded(
                  child: (createAdsWatch.listVideos.isNotEmpty)
                      ? CommonConfirmationOverlayWidget(
                          title: LocaleKeys.keyAreYouSure.localized,
                          description: LocaleKeys.keyByClickingYesTheSelectedDataWillBeCleared.localized,
                          onButtonTap: (positive) {
                            if (positive) {
                              createAdsWatch.updateMediaIndex(1);
                              createAdsWatch.listVideos.clear();
                              createAdsWatch.updateViewerData(null, -1);
                            }
                          },
                          child: _buildVideoTab(createAdsWatch),
                        )
                      : _buildVideoTab(createAdsWatch),
                ),
              },
            ],
          ),
        } else ...{
          Row(
            children: [
              /// Images Button (Index 0)
              Expanded(
                child: (createAdsWatch.listVideos.isNotEmpty)
                    ? CommonConfirmationOverlayWidget(
                        title: LocaleKeys.keyAreYouSure.localized,
                        description: LocaleKeys.keyByClickingYesTheSelectedDataWillBeCleared.localized,
                        onButtonTap: (positive) {
                          if (positive) {
                            createAdsWatch.updateMediaIndex(0);
                            createAdsWatch.listVideos.clear();
                            createAdsWatch.updateViewerData(null, -1);
                          }
                        },
                        child: _buildTabItem(
                          title: LocaleKeys.keyImages.localized,
                          isSelected: createAdsWatch.mediaIndex == 0,
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          createAdsWatch.updateMediaIndex(0);
                        },
                        child: _buildTabItem(
                          title: LocaleKeys.keyImages.localized,
                          isSelected: createAdsWatch.mediaIndex == 0,
                        ),
                      ),
              ),

              SizedBox(width: context.width * 0.01),

              /// Video Button (Index 1)
              Expanded(
                child: (createAdsWatch.listImages.isNotEmpty)
                    ? CommonConfirmationOverlayWidget(
                        title: LocaleKeys.keyAreYouSure.localized,
                        description: LocaleKeys.keyByClickingYesTheSelectedDataWillBeCleared.localized,
                        onButtonTap: (positive) {
                          if (positive) {
                            createAdsWatch.updateMediaIndex(1);
                            createAdsWatch.listImages.clear();
                            createAdsWatch.updateViewerData(null, -1);
                          }
                        },
                        child: _buildTabItem(
                          title: LocaleKeys.keyVideo.localized,
                          isSelected: createAdsWatch.mediaIndex == 1,
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          createAdsWatch.updateMediaIndex(1);
                        },
                        child: _buildTabItem(
                          title: LocaleKeys.keyVideo.localized,
                          isSelected: createAdsWatch.mediaIndex == 1,
                        ),
                      ),
              ),
            ],
          ),
        },
      ],
    );
  }
}

Widget _buildTabItem({required String title, required bool isSelected}) {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(
        color: isSelected ? AppColors.clr2997FC : AppColors.clr7C7474,
        width: 1,
      ),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CommonText(
          title: title,
          style: TextStyles.regular.copyWith(
            fontSize: 14,
            color: isSelected ? AppColors.clr2997FC : AppColors.clr7C7474,
          ),
        ),
        Icon(
          Icons.check_circle_rounded,
          color: isSelected ? AppColors.clr2997FC : AppColors.clr7C7474,
        ),
      ],
    ).paddingSymmetric(vertical: 13, horizontal: 18),
  );
}

Widget _buildImageTab(CreateAdsController createAdsWatch) {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(
        color: createAdsWatch.mediaIndex == 0 ? AppColors.clr2997FC : AppColors.clr7C7474,
        width: 1,
      ),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CommonText(
          title: LocaleKeys.keyImages.localized,
          style: TextStyles.regular.copyWith(
            fontSize: 14,
            color: createAdsWatch.mediaIndex == 0 ? AppColors.clr2997FC : AppColors.clr7C7474,
          ),
        ),
        Icon(
          Icons.check_circle_rounded,
          color: createAdsWatch.mediaIndex == 0 ? AppColors.clr2997FC : AppColors.clr7C7474,
        ),
      ],
    ).paddingSymmetric(vertical: 13, horizontal: 18),
  );
}

Widget _buildVideoTab(CreateAdsController createAdsWatch) {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(
        color: createAdsWatch.mediaIndex == 1 ? AppColors.clr2997FC : AppColors.clr7C7474,
        width: 1,
      ),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CommonText(
          title: LocaleKeys.keyVideo.localized,
          style: TextStyles.regular.copyWith(
            fontSize: 14,
            color: createAdsWatch.mediaIndex == 1 ? AppColors.clr2997FC : AppColors.clr7C7474,
          ),
        ),
        Icon(
          Icons.check_circle_rounded,
          color: createAdsWatch.mediaIndex == 1 ? AppColors.clr2997FC : AppColors.clr7C7474,
        ),
      ],
    ).paddingSymmetric(vertical: 13, horizontal: 18),
  );
}
