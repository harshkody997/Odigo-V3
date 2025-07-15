import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/dashboard/dashboard_controller.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/session.dart';
import 'package:odigov3/framework/controller/notification_list/notification_controller.dart';
import 'package:odigov3/ui/notification_list/web/helper/notification_dashbaord_list_tile.dart';
import 'package:odigov3/ui/routing/navigation_stack_item.dart';
import 'package:odigov3/ui/routing/navigation_stack_keys.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/app_enums.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_anim_loader.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';
import 'package:odigov3/ui/utils/widgets/common_confirmation_dialog.dart';
import 'package:odigov3/ui/utils/widgets/common_empty_state_widget.dart';
import 'package:odigov3/ui/utils/widgets/common_search_form_field.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_switch_widget.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class CommonAppbar extends ConsumerWidget {
  ///Total item count(Country : 5)
  final int? totalCount;

  ///List Name (Countries)
  final String? listName;

  ///Search Controller
  final TextEditingController? searchController;

  ///Search Place holder Text
  final String? searchPlaceHolderText;

  ///Add Button Text
  final String? addButtonText;

  ///show add icon in button (default-true)
  final bool showAddIconInButton;

  ///Search On Changed
  final Function(dynamic text)? searchOnChanged;

  ///Search OnTap
  final void Function()? searchOnTap;

  ///Import OnTap
  final void Function()? importOnTap;

  ///Export OnTap
  final void Function()? exportOnTap;

  final void Function()? clearAllTap;

  ///Add Button OnTap
  final void Function()? addButtonOnTap;

  ///Filter Button OnTap
  final void Function()? filterButtonOnTap;

  ///Show Search Bar
  final bool? showSearchBar;

  ///Show Export
  final bool? showExport;

  ///Show Import
  final bool? showImport;

  ///Show Filters
  final bool? showFilters;

  ///Show Add Button
  final bool? showAddButton;

  final bool? showClearAll;

  ///Show Emergency Mode
  final bool? showEmergencyMode;

  ///Emergency Mode Switch On Changed
  final void Function()? emergencyModeOnChanged;

  ///Emergency Mode Value
  final bool? emergencyModeValue;

  ///Show More Info
  final bool? showMoreInfo;

  ///More Info On Changed
  final void Function()? moreInfoOnTap;

  ///show settings
  final bool? showSettings;

  ///show profile
  final bool? showProfile;

  final bool? showNotification;

  ///set searchbarWidth
  final double? searchbarWidth;

  ///set addButtonTextFontSize
  final double? addButtonTextFontSize;

  /// Set if filter is applied
  final bool? isFilterApplied;

  const CommonAppbar({
    super.key,
    this.totalCount,
    this.listName,
    this.searchController,
    this.searchPlaceHolderText,
    this.searchOnChanged,
    this.searchOnTap,
    this.showSearchBar,
    this.searchbarWidth,
    this.importOnTap,
    this.exportOnTap,
    this.clearAllTap,
    this.addButtonOnTap,
    this.addButtonText,
    this.showExport,
    this.showImport,
    this.showFilters,
    this.showAddIconInButton = true,
    this.showAddButton,
    this.showClearAll,
    this.filterButtonOnTap,
    this.emergencyModeOnChanged,
    this.emergencyModeValue,
    this.moreInfoOnTap,
    this.showEmergencyMode,
    this.showMoreInfo,
    this.showSettings,
    this.showProfile,
    this.showNotification,
    this.addButtonTextFontSize,
    this.isFilterApplied,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.clrD8D8D8)),
        color: AppColors.white,
      ),
      child: Row(
        children: [
          ///Odigo Icon
          SizedBox(
            height: context.height * 0.06,
            child: CommonSVG(
              strIcon: Assets.svgs.svgOdigoIcon.path,
              boxFit: BoxFit.scaleDown,
              colorFilter: ColorFilter.mode(AppColors.black, BlendMode.srcIn),
            ).paddingOnly(left: context.width * 0.0012, right: context.width * 0.030),
          ),

          ///Icon
          CommonSVG(strIcon: Assets.svgs.svgSidebar.path).paddingOnly(right: context.width * 0.008),

          ///Current Page Title
          /*CommonText(
            title: drawerWatch.selectedMainScreen?.screenName.name == ScreenName.master.name
                ? drawerWatch.selectedSubScreen?.title.localized ?? ''
                : drawerWatch.selectedMainScreen?.menuName.localized ?? '',
            style: TextStyles.bold.copyWith(color: AppColors.black, fontSize: 14),
          ).paddingOnly(right: context.width * 0.008),*/
          ...List.generate(NavigationStackKeyMapper.mapper.keysList.length, (index) {
            String key = NavigationStackKeyMapper.mapper.keysList[index];
            return Row(
              children: [
                if (index != 0)
                  CommonText(
                    title: '/',
                    style: TextStyles.medium.copyWith(color: AppColors.black.withValues(alpha: 0.4), fontSize: 18),
                  ).paddingSymmetric(horizontal: context.width * 0.005),
                InkWell(
                  onTap: (key == NavigationStackKeyMapper.mapper.currentKey)
                      ? null
                      : () {
                          int loopIndex = NavigationStackKeyMapper.mapper.keysList.length - (index + 1);
                          while (loopIndex > 0) {
                            ref.read(dashboardController).notifyListeners();
                            AppConstants.constant.globalRef?.read(navigationStackController).pop();
                            ref.read(drawerController).notifyListeners();
                            loopIndex--;
                          }
                        },
                  child: CommonText(
                    title: '${NavigationStackKeyMapper.value(key)=='CMS'?cmsPage:NavigationStackKeyMapper.value(key)}'.localized,
                    style: (key == NavigationStackKeyMapper.mapper.currentKey)
                        ? TextStyles.bold.copyWith(color: AppColors.black, fontSize: 14)
                        : TextStyles.medium.copyWith(color: AppColors.black.withValues(alpha: 0.4), fontSize: 14),
                  ),
                ),
              ],
            );
          }),

          ///Total count & List Name
          Visibility(
            visible: !(totalCount == 0 || totalCount == null || listName == '' || listName == null),
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(40), color: AppColors.clrF4F7FE),
              child: CommonText(
                title: '${totalCount} ${listName}',
                style: TextStyles.semiBold.copyWith(color: AppColors.clr2997FC, fontSize: 10),
              ).paddingSymmetric(horizontal: context.width * 0.008, vertical: context.height * 0.005),
            ).paddingOnly(left: context.width * 0.007),
          ),

          Spacer(),

          ///Search bar
          Visibility(
            visible: showSearchBar ?? false,
            child: SizedBox(
              width: searchbarWidth ?? context.width * 0.25,
              height: context.height * 0.06,
              child: CommonSearchFormField(
                controller: searchController,
                backgroundColor: AppColors.greyF7F7F7,
                borderRadius: BorderRadius.circular(8),
                placeholder: searchPlaceHolderText,
                onChanged:  searchOnChanged,
                onTap: searchOnTap,
              ),
            ).paddingOnly(right: context.width * 0.01),
          ),

          ///Export Button
          Visibility(
            visible: showExport ?? false,
            child: InkWell(
              onTap: (totalCount ?? 0) < 1
                  ? null /// Disable tap if totalCount is null or less than 1
                  : exportOnTap, /// Call exportOnTap only if data is available
              child: Opacity(
                opacity: (totalCount ?? 0) < 1
                    ? 0.5 /// Reduce opacity (make it look disabled) if totalCount is null or less than 1
                    : 1.0, /// Full opacity when data is available
                child: Container(
                  height: context.height * 0.06,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    border: Border.all(color: AppColors.blackD0D5DD),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      ///Export Icon
                      CommonSVG(strIcon: Assets.svgs.svgUpload.path, boxFit: BoxFit.scaleDown).paddingOnly(right: context.width * 0.008),

                      ///Import Text
                      CommonText(
                        title: LocaleKeys.keyExport.localized,
                        style: TextStyles.medium.copyWith(color: AppColors.clr344054, fontSize: 14),
                      ),
                    ],
                  ).paddingSymmetric(horizontal: context.width * 0.008),
                ),
              ),
            ).paddingOnly(right: context.width * 0.01),
          ),

          ///Import Button
          Visibility(
            visible: showImport ?? false,
            child: InkWell(
              onTap: importOnTap,
              child: Container(
                height: context.height * 0.06,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border.all(color: AppColors.blackD0D5DD),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    ///Import Icon
                    CommonSVG(strIcon: Assets.svgs.svgIn.path, boxFit: BoxFit.scaleDown).paddingOnly(right: context.width * 0.008),

                    ///Import Text
                    CommonText(
                      title: LocaleKeys.keyImport.localized,
                      style: TextStyles.medium.copyWith(color: AppColors.clr344054, fontSize: 14),
                    ),
                  ],
                ).paddingSymmetric(horizontal: context.width * 0.008),
              ),
            ).paddingOnly(right: showAddButton == false ? 0 : context.width * 0.01),
          ),

          ///Filters Button
          Visibility(
            visible: showFilters ?? false,
            child: InkWell(
              onTap: filterButtonOnTap,
              child: Container(
                height: context.height * 0.06,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border.all(color: AppColors.blackD0D5DD),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [

                    isFilterApplied??false?Container(height:9,width:9,decoration: BoxDecoration(shape: BoxShape.circle,color: AppColors.clr03A12B),).paddingOnly(right: 4):const Offstage(),

                    ///Filter Icon
                    CommonSVG(strIcon: Assets.svgs.svgFilters.path, boxFit: BoxFit.scaleDown).paddingOnly(right: context.width * 0.008),

                    ///Filter Text
                    CommonText(
                      title: LocaleKeys.keyFilters.localized,
                      style: TextStyles.medium.copyWith(color: AppColors.clr344054, fontSize: 14),
                    ),
                  ],
                ).paddingSymmetric(horizontal: context.width * 0.008),
              ),
            ).paddingOnly(right: context.width * 0.01),
          ),

         Visibility(
           visible: showNotification??false,
           child: Consumer(
                builder: (context,ref,child) {
                 final notificationWatch = ref.watch(notificationController);
                  return Stack(
                    children: [
                      IgnorePointer(
                        ignoring: false,
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                          ),
                          child: PopupMenuButton<SampleItem>(
                            tooltip:'',
                            padding: EdgeInsets.zero,
                            clipBehavior: Clip.hardEdge,
                            elevation: 5,
                            constraints: BoxConstraints.expand(
                               height: context.height * 0.80,
                                width: context.width * 0.35
                            ),
                            iconSize: 60,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20.0),
                              ),
                            ),
                            offset: Offset(0, 50),
                            color: AppColors.white,
                            surfaceTintColor: AppColors.white,
                            shadowColor: AppColors.white,
                            onOpened: () async{
                              notificationWatch.disposeController(isNotify:true);

                              await notificationWatch.notificationListAPI(context,false);
                              if(notificationWatch.notificationListState.success?.status == ApiEndPoints.apiStatus_200){
                                if(context.mounted){
                                  await notificationWatch.readAllNotificationAPI(context);
                                }
                              }
                            },
                            icon:

                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                CommonSVG(
                                  strIcon: Assets.svgs.svgNotificationDashbaord.path,
                                  boxFit: BoxFit.scaleDown,
                                  height: context.height * 0.06,

                                ),
                                Visibility(
                                  visible: (notificationWatch.notificationUnReadCountState.success?.data??0)>0,
                                  child: Positioned(
                                    top: -1,
                                    left: -2,
                                    child: Container(
                                      height: 16,
                                      width: 16,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.clr2997FC,
                                      ),
                                      child: CommonText(
                                        title: notificationWatch.notificationUnReadCountState.success?.data.toString()??'',
                                        style: TextStyles.regular.copyWith(
                                          fontSize: 10,
                                          color: AppColors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            ),

                            itemBuilder: (BuildContext context) => <PopupMenuEntry<SampleItem>>[
                              PopupMenuItem<SampleItem>(
                                padding: EdgeInsets.zero,
                                child:
                                Consumer(
                                    builder: (BuildContext context, WidgetRef ref, Widget? child) {
                                      final notificationScreenWatch = ref.watch(notificationController);
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                             CommonText(
                                               title: LocaleKeys.keyNotification.localized,
                                               style: TextStyles.semiBold.copyWith(fontSize: 14,color: AppColors.clr101828),
                                             ),
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  notificationScreenWatch.notificationList.isEmpty
                                                      ?const Offstage():   CommonConfirmationOverlayWidget(
                                                      title: LocaleKeys.keyNotification.localized,
                                                      description: LocaleKeys.keyDeleteAllNotificationMessage.localized,
                                                      positiveButtonText: LocaleKeys.keyYes.localized,

                                                      onButtonTap: (isPositive) async {

                                                        if(isPositive)
                                                          {

                                                            await notificationScreenWatch.deleteNotificationListAPI(context);
                                                            if(notificationScreenWatch.deleteNotificationListState.success?.status==ApiEndPoints.apiStatus_200 && context.mounted)
                                                            {
                                                              notificationScreenWatch.resetPagination();
                                                              await notificationScreenWatch.notificationListAPI(context,false);
                                                            }
                                                          }

                                                      },
                                                      child:Visibility(
                                                        visible:notificationScreenWatch.notificationList.isNotEmpty,
                                                        child: CommonText(
                                                          title: LocaleKeys.keyClearAll.localized,
                                                          style: TextStyles.medium.copyWith(fontSize: 12,color: AppColors.clr2997FC,decoration: TextDecoration.underline,decorationColor: AppColors.clr2997FC),
                                                        ),
                                                      ),
                                                  ),
                                                  SizedBox(width: 25,),
                                                  CommonSVG(strIcon: Assets.svgs.svgClose.path,
                                                  height: 30,
                                                  width: 30,)
                                                ],
                                              )
                                            ],
                                          ).paddingSymmetric(vertical: 12,horizontal: 16),

                                          Divider(color: AppColors.clrE5E7EB, height: 1),

                                          /// List
                                          SizedBox(
                                            height: context.height * 0.60,
                                            child: notificationWatch.notificationListState.isLoading
                                                ? const Center(child: CommonAnimLoader()):   notificationWatch.limitedList.isEmpty ? Center(child: CommonEmptyStateWidget())
                                                :ListView.builder(
                                              itemCount:notificationScreenWatch.limitedList.length,
                                              shrinkWrap: true,
                                              physics: const AlwaysScrollableScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                var model =
                                                notificationScreenWatch.limitedList[index];
                                               return NotificationDashboardListTile(model: model);
                                              },
                                            ).paddingSymmetric(vertical: 5)
                                          ).paddingSymmetric(horizontal: 16),
                                          Visibility(
                                            visible: notificationScreenWatch.notificationList.isNotEmpty,
                                            child: CommonButton(buttonText: LocaleKeys.keyViewAll.localized,
                                                onTap: ()
                                                {
                                                  Navigator.pop(context);
                                                  notificationWatch.disposeController(isNotify:true);

                                                  ref.read(navigationStackController).push(NavigationStackItem.notificationList());
                                                },
                                                backgroundColor: AppColors.transparent,
                                                borderRadius: BorderRadius.circular(8),borderColor: AppColors.clrD1D5DC,
                                                buttonTextStyle: TextStyles.semiBold.copyWith(color: AppColors.black6A7282,fontSize: 16)).paddingOnly(left: 16,right: 16),
                                          )

                                        ],
                                      );
                                    }
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Visibility(
                      //   visible:(notificationWatch.notificationUnReadCountState.success?.data??0)>0,
                      //   //visible:(notificationWatch.notificationUnReadCountState.success?.data??0)>0,
                      //   child: Container(
                      //     height: 20.h,
                      //     width: 20.w,
                      //     alignment: Alignment.center,
                      //     decoration: const BoxDecoration(
                      //         shape: BoxShape.circle,
                      //         color: Colors.red
                      //     ),
                      //     child: CommonText(title:notificationWatch.notificationUnReadCountState.success?.data.toString()??'',
                      //       textStyle: TextStyles.regular.copyWith(color: AppColors.white,fontSize: 12.sp),),),
                      // )
                    ],
                  ).paddingOnly(right: context.width * 0.01);
                }
            ),
         ),


          ///Setting button
          Visibility(
            visible: (showSettings ?? false) && Session.getRoleType() == 'SUPER_ADMIN',
            child: InkWell(
              onTap: () {
                ref.read(navigationStackController).push(NavigationStackItem.settings());
              },
              child: CommonSVG(height: context.height * 0.06, strIcon: Assets.svgs.svgSettingsCircular.path, boxFit: BoxFit.scaleDown),
            ).paddingOnly(right: context.width * 0.01),
          ),
          ///Profile button
          Visibility(
            visible: (showProfile ?? false),
            child: InkWell(
              onTap: () {
                ref.read(navigationStackController).push(NavigationStackItem.profile());
              },
              child: CommonSVG(height: context.height * 0.06, strIcon: Assets.svgs.svgProfileRounded.path, boxFit: BoxFit.scaleDown),
            ).paddingOnly(right: context.width * 0.016),
          ),

          ///Deployment button
          Visibility(
            visible: (showProfile ?? false) && Session.getRoleType() == 'SUPER_ADMIN',
            child: CommonButton(
              buttonText: LocaleKeys.keyDeployment.localized,
              width: context.width * 0.09,
              onTap: () {
                ref.read(navigationStackController).push(NavigationStackItem.deploymentList());
              }
            ).paddingOnly(right: context.width * 0.01),
          ),
          // Visibility(
          //   visible: showClearAll ?? false,
          //   child:
          //   CommonConfirmationOverlayWidget(
          //     title: LocaleKeys.keyNotification.localized,
          //     description: LocaleKeys.keyDeleteAllNotificationMessage.localized,
          //     positiveButtonText: LocaleKeys.keyYes.localized,
          //
          //     onButtonTap: (isPositive) async{
          //
          //       if(isPositive)
          //         {
          //
          //         }
          //
          //     },
          //     child: Container(
          //       decoration: BoxDecoration(
          //         color: AppColors.white,
          //         border: Border.all(color: AppColors.blackD0D5DD),
          //         borderRadius: BorderRadius.circular(8),
          //       ),
          //       child: CommonText(
          //         title: LocaleKeys.keyClearAll.localized,
          //         style: TextStyles.medium.copyWith(color: AppColors.clr6A7282, fontSize: 14),
          //       ).paddingSymmetric(horizontal: 45,vertical: 10),
          //     ),),
          //
          // ),

          ///Add Button
          Visibility(
            visible: showAddButton ?? false,
            child: InkWell(
              onTap: addButtonOnTap,
              child: Container(
                height: context.height * 0.06,
                decoration: BoxDecoration(color: AppColors.black, borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    ///Add Icon
                    if(showAddIconInButton)
                      CommonSVG(strIcon: Assets.svgs.svgPlus.path, boxFit: BoxFit.scaleDown).paddingOnly(right: context.width * 0.008),

                    ///Text
                    CommonText(
                      title: addButtonText ?? '',
                      style: TextStyles.medium.copyWith(color: AppColors.white, fontSize: addButtonTextFontSize ?? 12),
                    ),
                  ],
                ).paddingSymmetric(horizontal: context.width * 0.006),
              ),
            ),
          ),

          ///Show Emergency Mode
          Visibility(
            visible: showEmergencyMode ?? false,
            child: Row(
              children: [
                ///Emergency Mode
                CommonText(
                  title: LocaleKeys.keyEmergencyMode.localized,
                  style: TextStyles.medium.copyWith(color: AppColors.black, fontSize: 14),
                ),

                SizedBox(width: context.width * 0.005),

                ///Emergency Switch
                CommonCupertinoSwitch(
                  switchValue: emergencyModeValue ?? false,
                  onChanged: (status) {
                    emergencyModeOnChanged?.call();
                  },
                ),
              ],
            ).paddingOnly(right: context.width * 0.025),
          ),

          ///Show More Info
          Visibility(
            visible: showMoreInfo ?? false,
            child: Row(
              children: [
                ///Emergency Mode
                CommonText(
                  title: LocaleKeys.keyMoreInfo.localized,
                  style: TextStyles.medium.copyWith(color: AppColors.black, fontSize: 14),
                ),

                SizedBox(width: context.width * 0.005),

                ///More Info
                InkWell(
                  onTap: moreInfoOnTap,
                  child: CommonSVG(strIcon: Assets.svgs.svgMoreInfo.path, boxFit: BoxFit.scaleDown),
                ),
              ],
            ),
          ),
        ],
      ).paddingSymmetric(horizontal: context.width * 0.018, vertical: context.height * 0.025),
    );
  }
}

///Usage
/*BaseDrawerPageWidget(
    body: _bodyWidget(),
    totalCount: 07,
    listName: 'Countries',
    searchPlaceHolderText: 'Search state, currency...',
    addButtonText: 'Add Country',
    searchController: TextEditingController(),
    showExport: false, ///Show Export Button
    showImport: false, ///Show Import Button
    showSearchBar: false, ///Show Search Bar
    showAddButton: false, ///Show Add Button
    showAppBar: true, ///Show App Bar
    showFilters: false, ///Show Filters Button
    showEmergencyMode: true, ///Show Emergency Mode
    showMoreInfo: true, ///Show More Info
    emergencyModeValue: true, ///Emergency Mode Switch Value
    exportOnTap: (){}, ///Export On Tap
    importOnTap: (){}, ///Import On Tap
    addButtonOnTap: (){}, ///Add Button On Tap
    searchOnChanged: (value){}, ///Search OnChanged
    searchOnTap: (){}, ///Search On Tap
    moreInfoOnTap: (){}, ///More Info on Tap
    emergencyModeOnChanged: (){}, ///Emergency switch on changed
);*/
