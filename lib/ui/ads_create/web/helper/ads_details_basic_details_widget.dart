import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/create_ads/ads_details_controller.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/client_ads/web/helper/ads_status_widget.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/app_enums.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class AdsDetailsBasicDetailsWidget extends ConsumerWidget {
  final String adsType;
  const AdsDetailsBasicDetailsWidget({super.key, required this.adsType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adsDetailsWatch = ref.watch(adsDetailsController);

    return Container(
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText(title: LocaleKeys.keyBasicDetails.localized,style: TextStyles.semiBold.copyWith(fontSize: 14),),
          SizedBox(height: context.height * 0.024,),
          if(adsType == AdsType.Client.name)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CommonText(title: LocaleKeys.keyStatus.localized,style: TextStyles.regular.copyWith(fontSize: 12, color: AppColors.clr7C7474),),
                AdsStatusWidget(status: adsDetailsWatch.clientAdsDetailState.success?.data?.status ?? '',)
              ],
            ).paddingOnly(bottom: context.height * 0.015),
          (adsType == AdsType.Client.name)
            ? _commonTextRow(LocaleKeys.keyClientName.localized, adsDetailsWatch.clientAdsDetailState.success?.data?.clientName ?? '')
            : _commonTextRow(LocaleKeys.keyDestinationName.localized, adsDetailsWatch.defaultAdsDetailState.success?.data?.destinationName ?? ''),

          SizedBox(height: context.height * 0.015,),
          _commonTextRow(LocaleKeys.keyTags.localized, (adsType == AdsType.Client.name) ? adsDetailsWatch.clientAdsDetailState.success?.data?.name ?? '' : adsDetailsWatch.defaultAdsDetailState.success?.data?.name ?? ''),
          SizedBox(height: context.height * 0.015,),
          _commonTextRow(LocaleKeys.keyCreatedDate.localized, (adsType == AdsType.Client.name) ? formatUtcToLocalDate(adsDetailsWatch.clientAdsDetailState.success?.data?.createdAt) ?? '' : formatUtcToLocalDate(adsDetailsWatch.defaultAdsDetailState.success?.data?.createdAt) ?? ''),
        ],
      ).paddingSymmetric(vertical: context.height * 0.032, horizontal: context.width * 0.017),
    );
  }

  _commonTextRow(String title, String value){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CommonText(title: title, style: TextStyles.regular.copyWith(fontSize: 12, color: AppColors.clr7C7474),),
        CommonText(title: value, style: TextStyles.regular.copyWith(fontSize: 12),),
      ],
    );
  }
}
