import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/ads_sequence_preview/ads_sequence_preview_controller.dart';
import 'package:odigov3/framework/controller/destination/destination_controller.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/repository/dashboard/model/sidemenu_list_response_model.dart';
import 'package:odigov3/framework/repository/destination/model/destination_details_response_model.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/session.dart';
import 'package:odigov3/ui/utils/app_enums.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';
import 'package:odigov3/ui/utils/widgets/common_searchable_dropdown.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';
import 'package:odigov3/ui/utils/widgets/common_toast_widget.dart';

class AdsSequencePreviewTopWidget extends ConsumerWidget {
  const AdsSequencePreviewTopWidget({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final adsSequencePreviewWatch = ref.watch(adsSequencePreviewController);
    SubSidebarData? selectedSubMenu = ref.read(drawerController).selectedSubScreen;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        (selectedSubMenu?.canEdit??false) && adsSequencePreviewWatch.selectedDestination != null && adsSequencePreviewWatch.sequencePreviewList.isNotEmpty && (Session.getEntityType() != RoleType.DESTINATION.name) && (Session.getEntityType() != RoleType.DESTINATION_USER.name)?
       adsSequencePreviewWatch.isReArrangeableEnable?
       Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CommonButton(
              height: 43,
              width: 110,
              borderRadius: BorderRadius.circular(7),
              buttonText: LocaleKeys.keyCancel.localized,
              backgroundColor: AppColors.transparent,
              borderColor: AppColors.clrEDEDED,
              buttonTextColor: AppColors.black,
              onTap: (){
                adsSequencePreviewWatch.updateReArrangeableStatus(false);
              },
            ).paddingOnly(right: 20),
            CommonButton(
              height: 43,
              width: 110,
              borderRadius: BorderRadius.circular(7),
              buttonText: LocaleKeys.keySave.localized,
              loaderSize: 28,
              onTap: ()async{
                adsSequencePreviewWatch.updateAdsSequenceApi().then((value){
                  if(adsSequencePreviewWatch.updateSequenceState.success?.status == ApiEndPoints.apiStatus_200){
                    showToast(context: context,message: '${LocaleKeys.keyAdsSequence.localized} ${LocaleKeys.keyUpdatedSuccessMsg.localized}');
                    adsSequencePreviewWatch.updateReArrangeableStatus(false);
                    adsSequencePreviewWatch.adsSequencePreviewListApi();
                  }
                });
              },
              buttonTextStyle: TextStyles.medium.copyWith(
                fontSize:14,
                color:AppColors.white,
              ),
            ).paddingOnly(right: 20),

          ],
        ).paddingOnly(bottom: 20)
           : Row(
              mainAxisAlignment:  MainAxisAlignment.end,
             children: [
               InkWell(
                        onTap: (){
               adsSequencePreviewWatch.updateReArrangeableStatus(true);
                         },
                         child: Container(
                height: 43,
                width:context.width*0.15,
                decoration: BoxDecoration(
                  color: AppColors.black,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CommonSVG(
                      strIcon:  Assets.svgs.svgArrangeableIcon.keyName,
                    ).paddingOnly(right: 10),
                    CommonText(
                      title: LocaleKeys.keyArrangeSequence.localized,
                      style: TextStyles.medium.copyWith(
                        color: AppColors.white,
                        fontSize: 14
                      ),
                    )

                  ],
                ),
                         ).paddingOnly(bottom: 20),
                       ),
             ],
           ):const Offstage(),
        (Session.getEntityType() == RoleType.SUPER_ADMIN.name) || (Session.getEntityType() == RoleType.USER.name)? CommonSearchableDropdown<DestinationData>(
          textEditingController: adsSequencePreviewWatch.selectDestinationCtr,
          hintText: LocaleKeys.keyDestination.localized,
          onSelected: (destination) async{
            adsSequencePreviewWatch.updateSelectedDestination(destination);
            adsSequencePreviewWatch.updateReArrangeableStatus(false);
            adsSequencePreviewWatch.adsSequencePreviewListApi();
          },
          items: ref.watch(destinationController).destinationList,
          title: (value) {
            return value.name ?? '';
          },
          onScrollListener: () async{
            if (!ref.watch(destinationController).destinationListState.isLoadMore && ref.watch(destinationController).destinationListState.success?.hasNextPage == true) {
              ref.watch(destinationController).getDestinationListApi(context,isReset: false,pagination: true,activeRecords: true).then((value) {
                if(ref.read(destinationController).destinationListState.success?.status == ApiEndPoints.apiStatus_200){
                  ref.read(searchController).notifyListeners();
                }
              });
            }
          },
        ).paddingOnly(bottom: 20): const Offstage(),
      ],
    );
  }
}
