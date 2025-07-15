// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:odigov3/framework/controller/notification_list/notification_controller.dart';
// import 'package:odigov3/framework/provider/network/api_end_points.dart';
// import 'package:odigov3/framework/repository/notification/model/notification_list_response_model.dart';
// import 'package:odigov3/framework/utils/extension/extension.dart';
// import 'package:odigov3/framework/utils/extension/string_extension.dart';
// import 'package:odigov3/ui/utils/theme/app_colors.dart';
// import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
// import 'package:odigov3/ui/utils/theme/assets.gen.dart';
// import 'package:odigov3/ui/utils/theme/text_style.dart';
// import 'package:odigov3/ui/utils/widgets/common_confirmation_dialog.dart';
// import 'package:odigov3/ui/utils/widgets/common_svg.dart';
// import 'package:odigov3/ui/utils/widgets/common_text.dart';
//
// class NotificationContentListTile extends ConsumerWidget
//      {
//   final NotificationData? notificationData;
//   final bool? isFromHome;
//
//   NotificationContentListTile({super.key, this.notificationData,this.isFromHome});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final notificationScreenWatch = ref.watch(notificationController);
//     return InkWell(
//       onTap: (){
//         if(isFromHome??false){
//           Navigator.of(context).pop();
//         }
//        //  notificationScreenWatch.setNotificationRedirection(ref,isFromHome:isFromHome,moduleName: notificationData?.module,uuid:notificationData?.moduleUuid ,entityUuid: notificationData?.entityUuid,subEntityUuid: notificationData?.subEntityUuid,entityType:notificationData?.entityType ,subEntityType: notificationData?.subEntityType, destinationUuid: notificationData?.destinationUuid);
//       },
//       child: Row(
//         children: [
//           CommonSVG(
//             strIcon: Assets.svgs.svgNotificationList.path,
//             height: 40,
//             width: 40,
//           ),
//           SizedBox(width: 10,),
//           Expanded(
//             child: CommonText(title: notificationData?.message??'',
//                 style: TextStyles.medium.copyWith(color: AppColors.clr101828,fontSize: 14),maxLines: 5,),
//           ),
//
//        //   Spacer(),
//
//       CommonConfirmationOverlayWidget(
//           title: LocaleKeys.keyNotification.localized,
//           description: LocaleKeys.keyDeleteNotificationMessage.localized,
//           positiveButtonText: LocaleKeys.keyYes.localized,
//
//           onButtonTap: (isPositive) async {
//             if(isPositive)
//             {
//               await notificationScreenWatch.deleteNotificationAPI(context,notificationData?.uuid.toString()??'');
//               if(notificationScreenWatch.deleteNotificationState.success?.status == ApiEndPoints.apiStatus_200){
//                 if((notificationScreenWatch.notificationListState.success?.hasNextPage??false) && notificationScreenWatch.getNotificationListState()){
//                   if(context.mounted){
//                     if(isFromHome??false){
//                       notificationScreenWatch.notificationListAPI(context,initPageSize: 5,showLoading: false);
//                     }else{
//                       notificationScreenWatch.notificationListAPI(context,showLoading: false);
//                     }
//
//                   }
//                 }
//               }
//             }
//
//           },
//           child: CommonSVG(strIcon: Assets.svgs.svgNotificationDelete.path,
//           )
//       ),
//         ],
//       ).paddingSymmetric(horizontal: 20,vertical: 16),
//     );
//   }
// }
