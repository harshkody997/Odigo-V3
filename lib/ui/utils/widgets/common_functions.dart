
import 'package:flutter/foundation.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/session.dart';
import 'package:odigov3/ui/utils/app_constants.dart';


final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

getDeviceIdPlatformWise() async {
  if(kIsWeb){
    WebBrowserInfo webBrowserInfo = await deviceInfoPlugin.webBrowserInfo;
    Session.deviceId = '${webBrowserInfo.hardwareConcurrency.toString().removeWhiteSpace.toLowerCase()}${webBrowserInfo.appCodeName.toString().removeWhiteSpace.toLowerCase()}${Session.getUserUuid()}-admin';
    showLog('deviceid===========${Session.deviceId}');

  //  Session.saveLocalData(keyDeviceId, '${webBrowserInfo.hardwareConcurrency.toString().removeWhiteSpace.toLowerCase()}${webBrowserInfo.appCodeName.toString().removeWhiteSpace.toLowerCase()}${Session.getUserUuid()}-admin');
  }
}