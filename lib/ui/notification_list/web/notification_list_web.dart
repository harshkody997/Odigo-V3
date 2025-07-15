import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:odigov3/framework/controller/notification_list/notification_controller.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/drawer/web/base_drawer_page_widget.dart';
import 'package:odigov3/ui/notification_list/web/helper/notification_dashbaord_list_tile.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/theme/text_style.dart';
import 'package:odigov3/ui/utils/widgets/common_anim_loader.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';
import 'package:odigov3/ui/utils/widgets/common_confirmation_dialog.dart';
import 'package:odigov3/ui/utils/widgets/common_empty_state_widget.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class NotificationListWeb extends ConsumerStatefulWidget {
  const NotificationListWeb({Key? key}) : super(key: key);

  @override
  ConsumerState<NotificationListWeb> createState() => _NotificationWebState();
}

class _NotificationWebState extends ConsumerState<NotificationListWeb> {

  ///Init Override
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async{
      final notificationScreenWatch = ref.read(notificationController);
      notificationScreenWatch.disposeController(isNotify : true);
      await notificationScreenWatch.notificationListAPI(context,false);
      if(notificationScreenWatch.notificationListState.success?.status == ApiEndPoints.apiStatus_200){
        if(notificationScreenWatch.readAllNotificationState.success == null){
          if(mounted){
            await notificationScreenWatch.readAllNotificationAPI(context);
          }
        }
      }
      notificationScreenWatch.notificationListController.addListener(() async {
        if ((notificationScreenWatch.notificationListController.position.pixels >=
            notificationScreenWatch.notificationListController.position.maxScrollExtent - 100)) {
          if ((notificationScreenWatch.notificationListState.success?.hasNextPage ?? false) &&
              !(notificationScreenWatch.notificationListState.isLoadMore)) {
          //  notificationScreenWatch.increasePageNumber();
            await notificationScreenWatch.notificationListAPI(context,true);
          }
        }
      });
    });
    super.initState();

  }

  ///Dispose Override
  @override
  void dispose() {
    super.dispose();
  }

  ///Build Override
  @override
  Widget build(BuildContext context) {
    return BaseDrawerPageWidget(
      showNotification: false,
       showClearAll: false,
      clearAllTap: ()
      {

      },
      addButtonText: LocaleKeys.keyNotification.localized,
      body: _bodyWidget(),
    );
  }

  ///Body Widget
  Widget _bodyWidget() {
    final notificationWatch = ref.watch(notificationController);

    return Column(
      children: [
        Expanded(
          child:
          notificationWatch.notificationListState.isLoading
              ? const Center(child: CommonAnimLoader())
              : notificationWatch.notificationList.isEmpty
              ? const Center(child: CommonEmptyStateWidget())
              :   Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
              boxShadow: [
                // BoxShadow(color: AppColors.clr101828.withValues(alpha: 0.6), blurRadius: 2, offset: Offset(0, 1)),
                BoxShadow(color: AppColors.clr101828.withValues(alpha: 0.1), blurRadius: 8, offset: Offset(0, 4),),

              ],),
            child:  Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    controller: notificationWatch.notificationListController,
                    itemCount: notificationWatch.notificationList.length,
                    physics: const AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      var model =
                      notificationWatch.notificationList[index];
                      return NotificationDashboardListTile(model: model).paddingSymmetric(horizontal: 20,vertical: 14);
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(
                        height: 0,
                        color: AppColors.greyBEBEBE.withOpacity(.2),
                      );
                    },
                  ),
                ),
                notificationWatch.notificationListState.isLoadMore? CircularProgressIndicator(strokeWidth: 4,color: AppColors.primary,).paddingOnly(bottom: 15) : Offstage()

              ],
            )
          ),

        ),
        Visibility(
          visible: !notificationWatch.notificationListState.isLoading,
          child: Row(children: [
            Visibility(
              visible: notificationWatch.notificationList.isNotEmpty,
              child: CommonConfirmationOverlayWidget(
                title: LocaleKeys.keyNotification.localized,
                description: LocaleKeys.keyDeleteAllNotificationMessage.localized,
                positiveButtonText: LocaleKeys.keyYes.localized,

                onButtonTap: (isPositive) async{

                  if(isPositive)
                  {

                    await notificationWatch.deleteNotificationListAPI(context);
                    if(notificationWatch.deleteNotificationListState.success?.status==ApiEndPoints.apiStatus_200 && context.mounted)
                    {
                      notificationWatch.resetPagination();
                      await notificationWatch.notificationListAPI(context,false);
                    }
                  }

                },
                child:

                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child:
                        notificationWatch.deleteNotificationListState.isLoading?
                        LoadingAnimationWidget.waveDots(
                          color: AppColors.white,
                          size:  40,
                        ).paddingSymmetric(horizontal: 45,):
                    CommonText(
                      title: LocaleKeys.keyClearAll.localized,
                      style: TextStyles.medium.copyWith(color: AppColors.white, fontSize: 14),
                    ).paddingSymmetric(horizontal: 45,),
                  ),
                ),

              ),
            ),
              SizedBox(width: 20,),
            CommonButton(
             // height: 50,
              width: 150,
              buttonText: LocaleKeys.keyBack.localized,
              borderColor: AppColors.blackD0D5DD,
              backgroundColor: AppColors.white,
              buttonTextStyle:  TextStyles.medium.copyWith(color: AppColors.clr6A7282, fontSize: 14),
              onTap: () {
                Navigator.pop(context);
              },
            ),

          ],).paddingOnly(top: 25),
        )
      ],
    ).paddingSymmetric(horizontal: 18);

  }


}
