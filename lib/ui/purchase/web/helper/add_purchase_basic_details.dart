import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/destination/destination_controller.dart';
import 'package:odigov3/framework/controller/purchase/add_purchase_controller.dart';
import 'package:odigov3/framework/repository/destination/model/destination_details_response_model.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/form_validations.dart';
import 'package:odigov3/ui/utils/app_enums.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_searchable_dropdown.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class AddPurchaseBasicDetails extends ConsumerWidget {
  const AddPurchaseBasicDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final destinationWatch = ref.watch(destinationController);
    final addPurchaseWatch = ref.watch(addPurchaseController);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      padding: EdgeInsets.symmetric(vertical: context.height * 0.03, horizontal: context.width* 0.015),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// basic details text
          CommonText(
            title: LocaleKeys.keyBasicDetails.localized,
            style: TextStyles.semiBold.copyWith(fontSize: 14, color: AppColors.black),
          ).paddingOnly(bottom: context.height * 0.025),

          /// select destination
          CommonSearchableDropdown<DestinationData>(
            hintText: LocaleKeys.keySelectDestination.localized,
            hintTextStyle: TextStyles.regular.copyWith(fontSize: 14,color:AppColors.clr8D8D8D),
            onSelected: (value) async {
              addPurchaseWatch.updateSelectedDestination(value);
              await addPurchaseWatch.purchaseWeeksApi(destinationUuid: value.uuid);
              if(addPurchaseWatch.selectedWeeks.isNotEmpty){
                addPurchaseWatch.calculateWeeklyPrice(addPurchaseWatch.purchaseType==PurchaseType.PREMIUM?addPurchaseWatch.selectedDestination?.premiumPrice??0:addPurchaseWatch.selectedDestination?.fillerPrice??0);
              }
              },
            textEditingController: addPurchaseWatch.destinationTypeSearchCtr,
            items: destinationWatch.destinationList,
            validator: (value) => validateText(value, LocaleKeys.keyDestinationTypeIsRequired.localized),
            title: (value) {
              return value.name ?? '';
            },
            onScrollListener: () async {
              if (!destinationWatch.destinationListState.isLoadMore && destinationWatch.destinationListState.success?.hasNextPage == true) {
                await destinationWatch.getDestinationListApi(context,pagination: true, activeRecords: true);
              }
            },
          ).paddingOnly(bottom: context.height * 0.02),

          /// purchase type text
          CommonText(
            title: LocaleKeys.keyPurchaseType.localized,
            style: TextStyles.semiBold.copyWith(fontSize: 14, color: AppColors.black),
          ).paddingOnly(bottom: context.height * 0.02),

          /// purchase type widget
          Row(
            children: [
              Expanded(
                child: _commonPurchaseTypeWidget(ref, PurchaseType.PREMIUM),
              ),
              SizedBox(width: context.width * 0.01),
              Expanded(
                child: _commonPurchaseTypeWidget(ref, PurchaseType.FILLER),
              ),
            ],
          ),

        ],
      ),
    );
  }

  Widget _commonPurchaseTypeWidget(WidgetRef ref, PurchaseType purchaseType){
    final addPurchaseWatch = ref.watch(addPurchaseController);
    return InkWell(
      onTap: () {
        addPurchaseWatch.updatePurchaseType(purchaseType);
        if(addPurchaseWatch.selectedWeeks.isNotEmpty && addPurchaseWatch.selectedDestination!=null){
          addPurchaseWatch.calculateWeeklyPrice(addPurchaseWatch.purchaseType==PurchaseType.PREMIUM?addPurchaseWatch.selectedDestination?.premiumPrice??0:addPurchaseWatch.selectedDestination?.fillerPrice??0);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: addPurchaseWatch.purchaseType == purchaseType ? AppColors.clr2997FC : AppColors.clrEAEAEA,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CommonText(
              title: purchaseType == PurchaseType.PREMIUM ? LocaleKeys.keyPremium.localized : LocaleKeys.keyFiller.localized,
              style: TextStyles.regular.copyWith(
                fontSize: 14,
                color: addPurchaseWatch.purchaseType == purchaseType ? AppColors.clr2997FC : AppColors.clr7C7474,
              ),
            ),
            CommonSVG(
              strIcon: addPurchaseWatch.purchaseType == purchaseType ? Assets.svgs.svgCheckCircleRoundedSelected.keyName : Assets.svgs.svgCheckCircleRounded.keyName,
            ),
          ],
        ).paddingSymmetric(vertical: 13, horizontal: 18),
      ),
    );
  }
}
