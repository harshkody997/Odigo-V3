// To parse this JSON data, do
//
//     final addUpdateDeviceRequestModel = addUpdateDeviceRequestModelFromJson(jsonString);

import 'dart:convert';

import 'package:odigov3/framework/repository/device/model/device_list_model.dart';

AddUpdateDeviceRequestModel addUpdateDeviceRequestModelFromJson(String str) => AddUpdateDeviceRequestModel.fromJson(json.decode(str));

String addUpdateDeviceRequestModelToJson(AddUpdateDeviceRequestModel data) => json.encode(data.toJson());

class AddUpdateDeviceRequestModel {
  String? uuid;
  String? serialNumber;
  String? hostName;
  String? navigationVersion;
  String? powerBoardVersion;
  SensorDetails? sensorDetails;
  List<DeviceDetail>? deviceDetails;

  AddUpdateDeviceRequestModel({
    this.uuid,
    this.serialNumber,
    this.hostName,
    this.navigationVersion,
    this.powerBoardVersion,
    this.sensorDetails,
    this.deviceDetails,
  });

  factory AddUpdateDeviceRequestModel.fromJson(Map<String, dynamic> json) => AddUpdateDeviceRequestModel(
    uuid: json["uuid"],
    serialNumber: json["serialNumber"],
    hostName: json["hostName"],
    navigationVersion: json["navigationVersion"],
    powerBoardVersion: json["powerBoardVersion"],
    sensorDetails: json["sensorDetails"] == null ? null : SensorDetails.fromJson(json["sensorDetails"]),
    deviceDetails: json["deviceDetails"] == null ? [] : List<DeviceDetail>.from(json["deviceDetails"]!.map((x) => DeviceDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "serialNumber": serialNumber,
    "hostName": hostName,
    "navigationVersion": navigationVersion,
    "powerBoardVersion": powerBoardVersion,
    "sensorDetails": sensorDetails?.toJson(),
    "deviceDetails": deviceDetails == null ? [] : List<dynamic>.from(deviceDetails!.map((x) => x.toJson())),
  };
}


