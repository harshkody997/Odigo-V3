import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/ads_sequence_preview/ads_sequence_preview_controller.dart';
import 'package:odigov3/framework/repository/ads_sequence/model/ads_sequence_preview_list_response_model.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';

import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/session.dart';
import 'package:odigov3/ui/routing/navigation_stack_item.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/app_enums.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_anim_loader.dart';
import 'package:odigov3/ui/utils/widgets/common_empty_state_widget.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_table_generator.dart';

class AdsSequencePreviewBottomWidget extends ConsumerWidget {
  const AdsSequencePreviewBottomWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final previewWatch = ref.watch(adsSequencePreviewController);
    return previewWatch.selectedDestination!=null || ((Session.getEntityType() == RoleType.DESTINATION.name) || (Session.getEntityType() == RoleType.DESTINATION_USER.name))? Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: AppColors.clr101828.withValues(alpha: 0.6), blurRadius: 2, offset: Offset(0, 1)),
          BoxShadow(color: AppColors.clr101828.withValues(alpha: 0.1), blurRadius: 3, offset: Offset(0, 1)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.greyFCFCFD,
              border: Border(bottom: BorderSide(color: AppColors.grayEAECF0)),
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
            ),
            child: Row(
              children: [
                /// Dragabale icon
                CommonSVG(
                  strIcon:  Assets.svgs.svgArrangeableIcon.keyName,
                ).paddingOnly(right: context.width*0.08),
                /// Slot Type
                CommonHeader(title:  LocaleKeys.keySlotType.localized),
                /// Slot No
                CommonHeader(title: LocaleKeys.keySlotNo.localized),
                /// Client name
                CommonHeader(title: LocaleKeys.keyClientName.localized,flex: 2),
                /// Preview date
                CommonHeader(title: LocaleKeys.keyPreviewDate.localized),
                /// Update slot
                CommonHeader(title: previewWatch.isReArrangeableEnable?LocaleKeys.keyUpdatedSlotNo.localized:''),
                /// Details
                CommonHeader(title: ''),

              ],
            ).paddingSymmetric(vertical: 13, horizontal: 24),
          ),

          Expanded(
            child:
            previewWatch.sequencePreviewListState.isLoading? CommonAnimLoader()
                : previewWatch.sequencePreviewList.isEmpty
                ? Center(child: CommonEmptyStateWidget())
                : Column(
              children: [
               (!previewWatch.isReArrangeableEnable)?
               Expanded(
                 child: ListView.separated(
                   shrinkWrap: true,
                   itemCount:  previewWatch.sequencePreviewList.length,
                   controller: previewWatch.scrollController,
                   itemBuilder: (context, index) {
                     SequencePreviewDto data = previewWatch.sequencePreviewList[index];
                     return Row(
                         children: [
                           /// Dragable icon
                           CommonSVG(
                             strIcon: Assets.svgs.svgArrangeableIcon.keyName,
                             colorFilter: ColorFilter.mode(AppColors.clrAFAFAF, BlendMode.srcATop),
                           ).paddingOnly(right: context.width * 0.08),
                           /// Slot type
                           CommonRow(title: data.slotType == SlotType.PURCHASE.name?LocaleKeys.keyPurchase.localized:LocaleKeys.keyDefault.localized),
                           /// slot number
                           CommonRow(title: data.slotNumber.toString()),
                           /// Client name
                           CommonRow(title: data.odigoClientName??'-',flex:2),
                           /// Preview Date
                           CommonRow(title:  DateFormat('dd/MM/yyyy').format(DateTime.parse(data.previewDate??AppConstants.appDefaultDate.toString()))),
                           /// Updated slot no
                           CommonRow(title: ''),
                           /// Details
                           CommonRow(widget: data.purchaseUuid != null?InkWell(
                               onTap:  (){
                                 ref.read(navigationStackController).push(NavigationStackItem.purchaseDetails(purchaseUuid: data.purchaseUuid??''));
                               },
                               child: SizedBox(
                                 height: 15,
                                 width: 30,
                                 child: Icon(Icons.arrow_forward_ios_outlined, size: 15).alignAtCenterRight(),
                               )
                           ): const Offstage(), title: ''),
                         ],
                       ).paddingSymmetric(vertical: 13).paddingSymmetric(horizontal: 24);
                   },
                   separatorBuilder: (_, __) => Divider(color: AppColors.grayEAECF0, height: 1),
                 ),
               ): Expanded(
                  child: ReorderableListView.builder(
                    buildDefaultDragHandles: false,
                    onReorder: (int oldIndex, int newIndex) {
                      previewWatch.reorderPreviewList(oldIndex,newIndex);
                    },
                    scrollController: previewWatch.scrollController,
                    shrinkWrap: true,
                    itemCount: previewWatch.reOrderSequencePreviewList.length,
                    itemBuilder: (context, index) {
                      SequencePreviewDto data = previewWatch.reOrderSequencePreviewList[index];
                      return Container(
                        key: ValueKey(data.slotNumber ?? '$index'),
                        decoration: BoxDecoration(
                          border: index < previewWatch.reOrderSequencePreviewList.length - 1
                              ? Border(bottom: BorderSide(color: AppColors.grayEAECF0))
                              : null,
                        ),
                        child: ReorderableDragStartListener(
                          index: index,
                          child: Row(
                              children: [
                                /// Dragabale icon
                                ReorderableDragStartListener(
                                  index: index,
                                  child: CommonSVG(
                                    strIcon: Assets.svgs.svgArrangeableIcon.keyName,
                                    colorFilter: ColorFilter.mode(AppColors.clr2997FC, BlendMode.srcATop),
                                  ).paddingOnly(right: context.width * 0.08),
                                ),
                                /// Slot type
                                CommonRow(title: data.slotType == SlotType.PURCHASE.name?LocaleKeys.keyPurchase.localized:LocaleKeys.keyDefault.localized),
                                /// Slot number
                                CommonRow(title: data.slotNumber.toString()),
                                /// Client name
                                CommonRow(title: data.odigoClientName??'-',flex: 2),
                                /// Preview date
                                CommonRow(title:  DateFormat('dd/MM/yyyy').format(DateTime.parse(data.previewDate??AppConstants.appDefaultDate.toString()))),
                                /// Updated Slotno
                                CommonRow(title: (index+1).toString()),
                                /// Details
                                CommonRow(widget: data.purchaseUuid != null?InkWell(
                                    onTap:  (){
                                      ref.read(navigationStackController).push(NavigationStackItem.purchaseDetails(purchaseUuid: data.purchaseUuid??''));
                                    },
                                    child: SizedBox(
                                      height: 15,
                                      width: 30,
                                      child: Icon(Icons.arrow_forward_ios_outlined, size: 15).alignAtCenterRight(),
                                    )
                                ): const Offstage(), title: ''),
                              ],
                            ).paddingSymmetric(vertical: 13).paddingSymmetric(horizontal: 24),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ]
      ),
    ): const Offstage();
  }
}
