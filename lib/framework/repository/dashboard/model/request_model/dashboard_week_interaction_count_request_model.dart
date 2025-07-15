// To parse this JSON data, do
//
//     final dashboardWeekInteractionCountRequestModel = dashboardWeekInteractionCountRequestModelFromJson(jsonString);

import 'dart:convert';

DashboardWeekInteractionCountRequestModel dashboardWeekInteractionCountRequestModelFromJson(String str) => DashboardWeekInteractionCountRequestModel.fromJson(json.decode(str));

String dashboardWeekInteractionCountRequestModelToJson(DashboardWeekInteractionCountRequestModel data) => json.encode(data.toJson());

class DashboardWeekInteractionCountRequestModel {
  String? startDate;
  String? endDate;
  String? destinationUuid;
  String? interactionTypeUuid;
  String? interactionType;

  DashboardWeekInteractionCountRequestModel({
    this.startDate,
    this.endDate,
    this.destinationUuid,
    this.interactionTypeUuid,
    this.interactionType,
  });

  factory DashboardWeekInteractionCountRequestModel.fromJson(Map<String, dynamic> json) => DashboardWeekInteractionCountRequestModel(
    startDate: json["startDate"],
    endDate: json["endDate"],
    destinationUuid: json["destinationUuid"],
    interactionTypeUuid: json["interactionTypeUuid"],
    interactionType: json["interactionType"],
  );

  Map<String, dynamic> toJson() => {
    "startDate": startDate,
    "endDate": endDate,
    "destinationUuid": destinationUuid,
    "interactionTypeUuid": interactionTypeUuid,
    "interactionType": interactionType,
  };
}
