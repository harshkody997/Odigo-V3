import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/ads_shown_time/ads_shown_time_controller.dart';
import 'package:odigov3/framework/repository/ads_shown_time/model/ads_shown_time_response_model.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/utils/app_enums.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_table_generator.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class AdsShowTimeListWidget extends ConsumerWidget {
  const AdsShowTimeListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adsShownTimeWatch = ref.watch(adsShownTimeController);
    return adsShownTimeWatch.selectedDestination!=null? CommonTableGenerator(headerContent: [
      ///Purchase UUid
      CommonHeader(title:  LocaleKeys.keyPurchaseUUID.localized),

      /// Client Name
      CommonHeader(title:  LocaleKeys.keyClientName.localized),
      /// Ads Name
      CommonHeader(title: LocaleKeys.keyAdsName.localized),
      /// Purchase Type
      CommonHeader(title: LocaleKeys.keyPurchaseType.localized),
      /// Time
      CommonHeader(title: LocaleKeys.keyTime.localized),
      /// Time Zone
      CommonHeader(title: LocaleKeys.keyTimeZoneForAds.localized),
      /// Robot Serial Number
      CommonHeader(title: LocaleKeys.keyRobotSerialNumber.localized),


    ], childrenHeader: adsShownTimeWatch.adsShownTimeList, childrenContent: (index) {
      AdsShownTime data = adsShownTimeWatch.adsShownTimeList[index];
      return [
        /// Purchase UUId
        CommonRow(title: data.purchaseUuid ?? '-'),

        /// Client Name
        CommonRow(title: data.odigoClientName ?? '-'),
        /// Ads Name
        CommonRow(title: data.adsName ?? '-'),
        /// Purchase Type
        Expanded(
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: context.width*0.008, vertical: context.height*0.006),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: data.purchaseType==PurchaseType.FILLER.name?[AppColors.clr3F51B5, AppColors.clr1A237E]:[AppColors.clr8E2DE2, AppColors.clr4A00E0],
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    ///SVG
                    CommonSVG(
                      strIcon: data.purchaseType==PurchaseType.FILLER.name?Assets.svgs.svgFilledRightArrow.keyName:Assets.svgs.svgCrown.keyName,
                      height: 12,
                      width: 12,
                      boxFit: BoxFit.scaleDown,
                    ), // You may use a custom crown icon instead
                    SizedBox(width: context.width*0.006),
                    ///Text
                    CommonText(
                      title: data.purchaseType==PurchaseType.FILLER.name?LocaleKeys.keyFiller.localized:LocaleKeys.keyPremium.localized,
                      style: TextStyles.medium.copyWith(
                          color: AppColors.white,
                          fontSize: 12
                      ),
                    ),
                  ],
                ),
              ),
              Spacer()
            ],
          ),
        ),
        /// Time
        CommonRow(title: DateFormat('h:mma').format(DateTime.fromMillisecondsSinceEpoch(data.adsShowTime ?? 0)).toLowerCase()),
        ///Time zone
        CommonRow(title: data.timeZone ?? '-'),
        /// Robot serial Number
        CommonRow(title: data.robotSerialNumber ?? '-'),

      ];
    }, /// Call pagination api method here
      isLoading: adsShownTimeWatch.adsShownTimeListState.isLoading,
      isLoadMore: adsShownTimeWatch.adsShownTimeListState.isLoadMore,
      onScrollListener: () {
        if (!adsShownTimeWatch.adsShownTimeListState.isLoadMore &&
            adsShownTimeWatch.adsShownTimeListState.success?.hasNextPage == true) {
          if (context.mounted) {
            adsShownTimeWatch.adsShownTimeListApi(context,isForPagination: true);
          }
        }
      },

    ): const Offstage();
  }
}
