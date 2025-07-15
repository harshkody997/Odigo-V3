import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/session.dart';
import 'package:odigov3/ui/routing/delegate.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/widgets/show_notification_snackbar.dart';



/// Server Key for testing
///AAAAHS9V6H4:APA91bHzP1uOsoQUl9OdFNJYfJvOasfg-pBFWcaUZbGLt3fqYbJsp9oJLvndLSwuyWAbjBUR3tS3Lqv92RO-AOSv67f4KVeX3VQ6hk45lA5nyYmNUxWVHIbysGdHfHcQqYrYPqlKg7if
class FirebasePushNotificationManager {
  FirebasePushNotificationManager._privateConstructor();

  static final FirebasePushNotificationManager instance = FirebasePushNotificationManager._privateConstructor();

  factory FirebasePushNotificationManager() {
    return instance;
  }

  /// Initial code for main.dart void main
  Future<void> setupInteractedMessage(WidgetRef ref) async {

    //enableIOSNotifications();
    await registerNotificationListeners(ref);
  }

  Future<void> registerNotificationListeners(WidgetRef ref) async {
    /// Flutter Local Notification
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


    /// onMessage is called when the app is in foreground and a notification is received
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {

      showLog('${message?.data} Notification in foreground');
      final RemoteNotification? notification = message!.notification;
     // final AndroidNotification? android = message.notification?.android;
      final WebNotification? webNotification = message.notification?.web;
      /// If `onMessage` is triggered with a notification, construct our own
      /// local notification to show to users using the created channel.


        if(notification != null && webNotification!=null){
        showLog('Web notification we got:$webNotification');
        if(globalNavigatorKey.currentState!.context.isWebScreen && Session.userAccessToken.isEmpty){
          showNotificationSnackBar(
              globalNavigatorKey.currentState!.context,
              padding: EdgeInsets.only(left: globalNavigatorKey.currentState!.context.width*0.6,right: globalNavigatorKey.currentState!.context.width*0.04,bottom: globalNavigatorKey.currentState!.context.height*0.05),
              notificationTitle:message.notification?.title , notificationBody: message.notification?.body);
        }else{
          showNotificationSnackBar(globalNavigatorKey.currentState!.context, notificationTitle:message.notification?.title , notificationBody: message.notification?.body);
        }
      }
    });
  }



}