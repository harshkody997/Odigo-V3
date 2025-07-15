import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/create_ads/ads_details_controller.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/ads_create/web/helper/ad_details_show_media_widget.dart';
import 'package:odigov3/ui/ads_create/web/helper/ads_details_basic_details_widget.dart';
import 'package:odigov3/ui/ads_create/web/helper/image_frame_viewer.dart';
import 'package:odigov3/ui/drawer/web/base_drawer_page_widget.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_anim_loader.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';

class AdsDetailsWeb extends ConsumerStatefulWidget {
  final String uuid;
  final String adsType;
  const AdsDetailsWeb({Key? key, required this.uuid, required this.adsType}) : super(key: key);

  @override
  ConsumerState<AdsDetailsWeb> createState() => _AdsDetailsWebState();
}

class _AdsDetailsWebState extends ConsumerState<AdsDetailsWeb> {
  ///Build Override
  @override
  Widget build(BuildContext context) {
    return BaseDrawerPageWidget(body: _bodyWidget());
  }

  ///Body Widget
  Widget _bodyWidget() {
    final adsDetailsWatch = ref.watch(adsDetailsController);
    return (adsDetailsWatch.defaultAdsDetailState.isLoading || adsDetailsWatch.clientAdsDetailState.isLoading)
    ? CommonAnimLoader()
    : Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///Basic details
                AdsDetailsBasicDetailsWidget(adsType: widget.adsType),

                SizedBox(height: context.height * 0.018,),

                Container(
                  decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    children: [

                      ///Media picker
                      AdDetailsShowMediaWidget(adsType: widget.adsType),
                    ],
                  ).paddingSymmetric(vertical: context.height * 0.032, horizontal: context.width * 0.017),
                ),
                ///Back button
                CommonButton(
                  buttonText: LocaleKeys.keyBack.localized,
                  buttonTextStyle: TextStyles.medium.copyWith(
                    fontSize: 14,
                    color: AppColors.clr787575,
                  ),
                  backgroundColor: AppColors.transparent,
                  borderColor: AppColors.clr9E9E9E,
                  borderRadius: BorderRadius.circular(6),
                  width: 145,
                  height: 48,
                  onTap: () {
                    ref.read(navigationStackController).pop();
                  },
                ).paddingOnly(top: 10),
              ],
            ),
          ),
        ),
        SizedBox(width: context.width * 0.015),
        Expanded(
          flex: 2,
          child: Container(
            height: context.height,
            decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(8)),
            child: ImageFrameViewer(),
          ),
        ),
      ],
    );
  }
}
