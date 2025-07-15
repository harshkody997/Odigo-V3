import 'package:flutter/material.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/widgets/show_notification.dart';

showNotificationSnackBar(BuildContext context,{double? width,EdgeInsetsGeometry? padding, String? notificationTitle, String? notificationBody}){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      width: width,
      elevation: 0,
      padding: padding??EdgeInsets.only(bottom: context.height*0.08, left: 20, right: 20),
      backgroundColor: AppColors.transparent,
      content: ShowNotification(
        notificationTitle:notificationTitle ,
        notificationBody: notificationBody,
        onCloseTap: (){
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    ),
  );
}