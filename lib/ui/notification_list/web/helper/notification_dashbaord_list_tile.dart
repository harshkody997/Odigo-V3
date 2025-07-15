import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/notification_list/notification_controller.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/repository/notification/model/notification_list_response_model.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/text_style.dart';
import 'package:odigov3/ui/utils/widgets/common_confirmation_dialog.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class NotificationDashboardListTile extends ConsumerWidget
{
  final NotificationData model;
  final bool? isFromHome;

  NotificationDashboardListTile({super.key,required this.model,this.isFromHome });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationScreenWatch = ref.watch(notificationController);

    return InkWell(
      onTap: ()
      {
        notificationScreenWatch.setNotificationRedirection(ref,moduleName: model.module,entityUuid: model.moduleUuid);

      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Circular Icon Background
          CommonSVG(
            strIcon: Assets.svgs.svgNotificationList.path,
            height: 40,
            width: 40,
          ),
          const SizedBox(width: 12),

          // Message + Time
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonText(title: model.module??'',
                            style: TextStyles.semiBold.copyWith(color: AppColors.clr2997FC,fontSize: 14,),),
                          const SizedBox(height: 6),
                          CommonText(title: model.message??'',
                            style: TextStyles.medium.copyWith(color: AppColors.clr101828,fontSize: 12,),maxLines: 4,),
                        ],
                      ),
                    ),

                    CommonConfirmationOverlayWidget(
                        title: LocaleKeys.keyNotification.localized,
                        description: LocaleKeys.keyDeleteNotificationMessage.localized,
                        positiveButtonText: LocaleKeys.keyYes.localized,

                        onButtonTap: (isPositive) async {
                          if(isPositive)
                          {
                            await notificationScreenWatch.deleteNotificationAPI(context,model.uuid.toString());
                            if(notificationScreenWatch.deleteNotificationState.success?.status == ApiEndPoints.apiStatus_200){
                                if(context.mounted){
                                  notificationScreenWatch.resetPagination();
                                  notificationScreenWatch.notificationListAPI(context,false);
                                }

                            }
                          }

                        },
                        child: CommonSVG(strIcon: Assets.svgs.svgCloseNotificationTile.path,
                        ).paddingOnly(top: 20,left: 20)
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                CommonText(title: getTimeAgoFromTimestamp(model.createdAt??0),
                  style: TextStyles.semiBold.copyWith(color: AppColors.clrB7B7B7,fontSize: 12,),)
              ],
            ),
          ),
        ],
      ).paddingSymmetric(vertical: 12),
    );

  }
}
