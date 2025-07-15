// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:odigov3/framework/controller/notification_list/notification_controller.dart';
// import 'package:odigov3/framework/repository/notification/model/notification_filter_model.dart';
// import 'package:odigov3/framework/repository/notification/model/notification_list_response_model.dart';
// import 'package:odigov3/framework/utils/extension/extension.dart';
// import 'package:odigov3/framework/utils/extension/string_extension.dart';
// import 'package:odigov3/ui/notification_list/web/helper/notification_content_list_tile.dart';
// import 'package:odigov3/ui/utils/theme/app_colors.dart';
// import 'package:odigov3/ui/utils/theme/text_style.dart';
// import 'package:odigov3/ui/utils/widgets/common_text.dart';
//
//
// class NotificationListTile extends ConsumerStatefulWidget {
//   final NotificationFilterModel model;
//
//   int? index;
//    NotificationListTile({super.key,this.index,required this.model});
//
//   @override
//   ConsumerState<NotificationListTile> createState() => _NotificationListTileTileState();
// }
//
// class _NotificationListTileTileState extends ConsumerState<NotificationListTile> {
//
//
//   @override
//   Widget build(BuildContext context) {
//     final notificationWatch = ref.watch(notificationController);
//
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         CommonText(
//           title:( widget.model.notificationDay??'').localized,
//           style: TextStyles.semiBold
//               .copyWith(color: AppColors.clr080808, fontSize: 14),
//         ).paddingOnly(top:( widget.index??0) % 2==1? 30:5,bottom: 30),
//
//         Container(
//     decoration: BoxDecoration(
//     borderRadius: BorderRadius.circular(8),
//     color: Colors.white,
//     boxShadow: [
//    // BoxShadow(color: AppColors.clr101828.withValues(alpha: 0.6), blurRadius: 2, offset: Offset(0, 1)),
//     BoxShadow(color: AppColors.clr101828.withValues(alpha: 0.1), blurRadius: 8, offset: Offset(0, 4),),
//
//     ],),
//           child: ListView.separated(
//             itemCount:  widget.model.notificationDayData?.length??0,
//             physics: const NeverScrollableScrollPhysics(),
//             shrinkWrap: true,
//             itemBuilder: (context, index) {
//               NotificationData? notificationData = widget.model.notificationDayData?[index];
//
//               return NotificationContentListTile(notificationData: notificationData,);
//
//             },
//             separatorBuilder: (BuildContext context, int index) {
//               return Divider(
//                 height: 0,
//                 color: AppColors.greyBEBEBE.withOpacity(.2),
//               );
//             },
//           ),
//         )
//       ],
//     );
//
//   }
//
//
//
//
// }
//
