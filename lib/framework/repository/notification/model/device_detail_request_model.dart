// To parse this JSON data, do
//
//     final deviceRegistrationRequestModel = deviceRegistrationRequestModelFromJson(jsonString);

import 'dart:convert';

DeviceRegistrationRequestModel deviceRegistrationRequestModelFromJson(String str) => DeviceRegistrationRequestModel.fromJson(json.decode(str));

String deviceRegistrationRequestModelToJson(DeviceRegistrationRequestModel data) => json.encode(data.toJson());

class DeviceRegistrationRequestModel {
  String? deviceId;
  String? userType;
  String? deviceType;
  String? uniqueDeviceId;

  DeviceRegistrationRequestModel({
    this.deviceId,
    this.userType,
    this.deviceType,
    this.uniqueDeviceId,
  });

  factory DeviceRegistrationRequestModel.fromJson(Map<String, dynamic> json) => DeviceRegistrationRequestModel(
    deviceId: json['deviceId'],
    userType: json['userType'],
    deviceType: json['deviceType'],
    uniqueDeviceId: json['uniqueDeviceId'],
  );

  Map<String, dynamic> toJson() => {
    'deviceId': deviceId,
    'userType': userType,
    'deviceType': deviceType,
    'uniqueDeviceId': uniqueDeviceId,
  };
}
