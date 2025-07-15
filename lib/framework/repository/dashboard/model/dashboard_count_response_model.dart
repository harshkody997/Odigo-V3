// To parse this JSON data, do
//
//     final dashboardCountResponseModel = dashboardCountResponseModelFromJson(jsonString);

import 'dart:convert';

DashboardCountResponseModel dashboardCountResponseModelFromJson(String str) => DashboardCountResponseModel.fromJson(json.decode(str));

String dashboardCountResponseModelToJson(DashboardCountResponseModel data) => json.encode(data.toJson());

class DashboardCountResponseModel {
  String? message;
  DashboardCountData? data;
  int? status;

  DashboardCountResponseModel({
    this.message,
    this.data,
    this.status,
  });

  factory DashboardCountResponseModel.fromJson(Map<String, dynamic> json) => DashboardCountResponseModel(
    message: json["message"],
    data: json["data"] == null ? null : DashboardCountData.fromJson(json["data"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data?.toJson(),
    "status": status,
  };
}

class DashboardCountData {
  int? totalDestination;
  int? activeDestination;
  int? deactiveDestination;
  int? totalRobot;
  int? activeRobot;
  int? deactiveRobot;
  int? totalClient;
  int? activeClient;
  int? deactiveClient;

  DashboardCountData({
    this.totalDestination,
    this.activeDestination,
    this.deactiveDestination,
    this.totalRobot,
    this.activeRobot,
    this.deactiveRobot,
    this.totalClient,
    this.activeClient,
    this.deactiveClient,
  });

  factory DashboardCountData.fromJson(Map<String, dynamic> json) => DashboardCountData(
    totalDestination: json["totalDestination"],
    activeDestination: json["activeDestination"],
    deactiveDestination: json["deactiveDestination"],
    totalRobot: json["totalRobot"],
    activeRobot: json["activeRobot"],
    deactiveRobot: json["deactiveRobot"],
    totalClient: json["totalClient"],
    activeClient: json["activeClient"],
    deactiveClient: json["deactiveClient"],
  );

  Map<String, dynamic> toJson() => {
    "totalDestination": totalDestination,
    "activeDestination": activeDestination,
    "deactiveDestination": deactiveDestination,
    "totalRobot": totalRobot,
    "activeRobot": activeRobot,
    "deactiveRobot": deactiveRobot,
    "totalClient": totalClient,
    "activeClient": activeClient,
    "deactiveClient": deactiveClient,
  };
}
