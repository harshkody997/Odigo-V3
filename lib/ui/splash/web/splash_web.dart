import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/utils/session.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/widgets/common_functions.dart';

class SplashWeb extends ConsumerStatefulWidget {
  const SplashWeb({super.key});

  @override
  ConsumerState<SplashWeb> createState() => _SplashWebState();
}

class _SplashWebState extends ConsumerState<SplashWeb> {


  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async{

      try{
        await getDeviceIdPlatformWise();
        String? fcmToken;
        fcmToken = await FirebaseMessaging.instance.getToken();
        if(fcmToken != null){
          showLog('>>>>>token $fcmToken');
          Session.fcmToken = fcmToken;
          //await Session.saveLocalData(keyNewFCMToken, fcmToken);
        }
        // ignore: empty_catches
      }catch(e){}
    });
  }

  ///Build Override
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _bodyWidget());
  }

  ///Body Widget
  Widget _bodyWidget() {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Container(color: Colors.black),
    );
  }
}
