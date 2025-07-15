import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/destination/destination_details_controller.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/drawer/web/base_drawer_page_widget.dart';
import 'package:odigov3/ui/profile/web/helper/dot_lines_widget.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';

class MoreInfoWeb extends ConsumerStatefulWidget {
  const MoreInfoWeb({Key? key}) : super(key: key);

  @override
  ConsumerState<MoreInfoWeb> createState() => _MoreInfoWebState();
}

class _MoreInfoWebState extends ConsumerState<MoreInfoWeb> {
  ///Build Override
  @override
  Widget build(BuildContext context) {
    return BaseDrawerPageWidget(body: _bodyWidget());
  }

  ///Body Widget
  Widget _bodyWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _leftContent()),

        SizedBox(width: context.width * 0.025),

        Expanded(child: _rightContent()),
      ],
    );
  }

  _leftContent() {
    final destinationDetailWatch = ref.watch(destinationDetailsController);
    final destinationData = destinationDetailWatch.destinationDetailsState.success?.data;
    return Container(
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(8)),
      child: destinationDetailWatch.destinationDetailsState.isLoading
          ? Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                decoration: BoxDecoration(color: AppColors.black, borderRadius: BorderRadius.circular(8)),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(title: LocaleKeys.keyDestinationDetails.localized, fontSize: 14, fontWeight: TextStyles.fwSemiBold),

                  commonContent(LocaleKeys.keyDestinationName.localized, destinationData?.name ?? ''),
                  commonContent(LocaleKeys.keyDestinationType.localized, destinationData?.destinationTypeName ?? ''),
                  commonContent(LocaleKeys.keyPasscode.localized, destinationData?.passcode ?? ''),
                  commonContent(LocaleKeys.keyFloorNo.localized, destinationData?.totalFloor.toString() ?? ''),

                  DotLinesWidget().paddingSymmetric(vertical: context.height * 0.04),

                  CommonText(title: LocaleKeys.keyOwnerDetails.localized, fontSize: 14, fontWeight: TextStyles.fwSemiBold),

                  commonContent(LocaleKeys.keyOwnerName.localized, destinationData?.ownerName ?? ''),
                  commonContent(LocaleKeys.keyEmailID.localized, destinationData?.email ?? ''),
                  commonContent(LocaleKeys.keyContact.localized, destinationData?.contactNumber ?? ''),
                  commonContent(
                    LocaleKeys.keyAddress.localized,
                      '${destinationData?.houseNumber ?? '-'} ${destinationData?.addressLine1 ?? '-'} ${destinationData?.addressLine2 ?? '-'} ${destinationData?.streetName ?? '-'}  ${destinationData?.landmark ?? '-'} ${destinationData?.cityName ?? '-'} ${destinationData?.stateName ?? '-'} ${destinationData?.postalCode ?? '-'}'
                  ),

                  DotLinesWidget().paddingSymmetric(vertical: context.height * 0.04),
                  CommonText(title: LocaleKeys.keyPriceDetails.localized, fontSize: 14, fontWeight: TextStyles.fwSemiBold),
                  commonContent(
                    LocaleKeys.keyFillerPrice.localized,
                    '${AppConstants.currency}${destinationData?.fillerPrice ?? ''}',
                  ),
                  commonContent(
                    LocaleKeys.keyPremiumPrice.localized,
                    '${AppConstants.currency}${destinationData?.premiumPrice ?? ''}',
                  ),
                ],
              ).paddingAll(context.height * 0.025),
            ),
    );
  }

  _rightContent() {
    final destinationDetailWatch = ref.watch(destinationDetailsController);
    final destinationData = destinationDetailWatch.destinationDetailsState.success?.data;
    return Container(
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(8)),
      child: destinationDetailWatch.destinationDetailsState.isLoading
      ? Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          decoration: BoxDecoration(color: AppColors.black, borderRadius: BorderRadius.circular(8)),
        ),
      ) : Container(
        height: context.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CommonText(title: LocaleKeys.keyDestinationTimingDetails.localized, fontSize: 14, fontWeight: TextStyles.fwSemiBold),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CommonText(title: LocaleKeys.keyDay.localized, style: TextStyles.regular.copyWith(fontSize: 16, color: AppColors.clr7C7474),),
                CommonText(title: LocaleKeys.keyTime.localized, style: TextStyles.regular.copyWith(fontSize: 16, color: AppColors.clr7C7474),),
              ],
            ).paddingOnly(top: context.height * 0.03),

            ...List.generate(destinationData?.destinationTimeValues?.length ?? 0, (index) {
              return commonContent(
                destinationData?.destinationTimeValues?[index].dayOfWeek?.toLowerCase().capsFirstLetterOfSentence ?? '',
                '${(DateFormat("h:mm a").format(DateFormat("HH:mm:ss").parse(destinationData?.destinationTimeValues?[index].startHour ?? '')))} - ${(DateFormat("h:mm a").format(DateFormat("HH:mm:ss").parse(destinationData?.destinationTimeValues?[index].endHour ?? '')))}',titleStyle: TextStyles.regular.copyWith(fontSize: 16, color: AppColors.black)
              );
            }),

            Container(),
          ],
        ).paddingAll(context.height * 0.025),
      ),
    );
  }

  commonContent(String title, String subTitle, {TextStyle? titleStyle}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CommonText(
          title: title,
          style: titleStyle ?? TextStyles.regular.copyWith(fontSize: 16, color: AppColors.clr7C7474),
        ),
        Spacer(),
        Expanded(
          child: CommonText(
            title: subTitle,
            maxLines: 2,
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.regular.copyWith(fontSize: 16, color: AppColors.black),
          ),
        ),
      ],
    ).paddingOnly(top: context.height * 0.031);
  }
}
