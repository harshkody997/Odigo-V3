import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/purchase/purchase_details_controller.dart';
import 'package:odigov3/framework/repository/purchase/model/response/purchase_details_response_model.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/client/web/helper/client_details_header_content_widget.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/app_enums.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';
import 'package:shimmer/shimmer.dart';

class PurchaseDetailsWidget extends ConsumerWidget {

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final purchaseDetailsWatch = ref.watch(purchaseDetailsController);
    PurchaseData? purchaseData = purchaseDetailsWatch.purchaseDetailState.success?.data;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Back Button
        InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: CommonSVG(strIcon: Assets.svgs.svgBackArrow.path),
        ).paddingOnly(left: context.width*0.01, top: context.height*0.01, right: context.width*0.015),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ///Client Name & Premium/Filler
              Row(
                children: [
                  ///Client Name
                  CommonText(title: purchaseData?.odigoClientName ?? '', style: TextStyles.bold.copyWith(fontSize: 22)),
          
                  SizedBox(width: context.width * 0.01),
          
                  /// Premium/Filler Button
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: context.width*0.008, vertical: context.height*0.006),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: purchaseData?.purchaseType==PurchaseType.FILLER.name?[AppColors.clr3F51B5, AppColors.clr1A237E]:[AppColors.clr8E2DE2, AppColors.clr4A00E0],
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        ///SVG
                        CommonSVG(
                          strIcon: purchaseData?.purchaseType==PurchaseType.FILLER.name?Assets.svgs.svgFilledRightArrow.keyName:Assets.svgs.svgCrown.keyName,
                          height: 12,
                          width: 12,
                          boxFit: BoxFit.scaleDown,
                        ), // You may use a custom crown icon instead
                        SizedBox(width: context.width*0.006),
                        ///Text
                        CommonText(
                          title: purchaseData?.purchaseType==PurchaseType.FILLER.name?LocaleKeys.keyFiller.localized:LocaleKeys.keyPremium.localized,
                          style: TextStyles.medium.copyWith(
                            color: AppColors.white,
                            fontSize: 12
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: context.height * 0.025),

              Wrap(
                children: [
                  ///Destination
                  _commonHeaderText(LocaleKeys.keyDestination.localized),
                  _commonValueText(purchaseData?.destinationName??''),
                  Container(height: 20, width: 1, color: AppColors.clr7C7474.withValues(alpha: 0.2)).paddingSymmetric(horizontal: context.height*0.01),

                  ///Payment Type
                  _commonHeaderText(LocaleKeys.keyPaymentType.localized),
                  _commonValueText(getAllLocalizeText(purchaseData?.paymentType ?? '-')),
                  Container(height: 20, width: 1, color: AppColors.clr7C7474.withValues(alpha: 0.2)).paddingSymmetric(horizontal: context.height*0.01),

                  ///Original Price
                  _commonHeaderText(LocaleKeys.keyOriginalPrice.localized),
                  _commonValueText('${AppConstants.currency}${purchaseData?.originalPrice ?? '-'}'),
                  Container(height: 20, width: 1, color: AppColors.clr7C7474.withValues(alpha: 0.2)).paddingSymmetric(horizontal: context.height*0.01),

                  ///Purchased Price
                  _commonHeaderText(LocaleKeys.keyPurchasedPrice.localized),
                  _commonValueText('${AppConstants.currency}${purchaseData?.purchasePrice ?? '-'}'),],
              ),
          
              ///Remark
              Visibility(
                  visible: purchaseData?.remarks!=''&& purchaseData?.remarks!=null,
                  child: ClientDetailsHeaderContentWidget(LocaleKeys.keyRemark.localized, purchaseData?.remarks??'-',isExpandedSubTitle: true).paddingOnly(top: context.height * 0.03)),
          
             ],
          ),
        ),
      ],
    );
  }

  _commonHeaderText(String title){
    return CommonText(
      title: '${title} : ',
      style: TextStyles.regular.copyWith(color: AppColors.clr7C7474, fontSize: 16),
    );
  }

  _commonValueText(String subTitle, {Color? subTitleColor}){
   return CommonText(
      title: subTitle,
      style: TextStyles.regular.copyWith(color: subTitleColor ?? AppColors.primary, fontSize: 16),
    );
  }
}
