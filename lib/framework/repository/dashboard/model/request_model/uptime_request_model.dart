// To parse this JSON data, do
//
//     final uptimeRequestModel = uptimeRequestModelFromJson(jsonString);

import 'dart:convert';

UptimeRequestModel uptimeRequestModelFromJson(String str) => UptimeRequestModel.fromJson(json.decode(str));

String uptimeRequestModelToJson(UptimeRequestModel data) => json.encode(data.toJson());

class UptimeRequestModel {
  String? destinationUuid;
  String? robotUuid;
  String? requestDate;

  UptimeRequestModel({
    this.destinationUuid,
    this.robotUuid,
    this.requestDate,
  });

  factory UptimeRequestModel.fromJson(Map<String, dynamic> json) => UptimeRequestModel(
    destinationUuid: json["destinationUuid"],
    robotUuid: json["robotUuid"],
    requestDate: json["requestDate"],
  );

  Map<String, dynamic> toJson() => {
    "destinationUuid": destinationUuid,
    "robotUuid": robotUuid,
    "requestDate": requestDate,
  };
}
