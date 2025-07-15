// To parse this JSON data, do
//
//     final dashboardPeakUsageRequestModel = dashboardPeakUsageRequestModelFromJson(jsonString);

import 'dart:convert';

DashboardPeakUsageRequestModel dashboardPeakUsageRequestModelFromJson(String str) => DashboardPeakUsageRequestModel.fromJson(json.decode(str));

String dashboardPeakUsageRequestModelToJson(DashboardPeakUsageRequestModel data) => json.encode(data.toJson());

class DashboardPeakUsageRequestModel {
  String? date;
  String? destinationUuid;
  String? interactionTypeUuid;
  String? interactionType;

  DashboardPeakUsageRequestModel({
    this.date,
    this.destinationUuid,
    this.interactionTypeUuid,
    this.interactionType,
  });

  factory DashboardPeakUsageRequestModel.fromJson(Map<String, dynamic> json) => DashboardPeakUsageRequestModel(
    date: json["date"],
    destinationUuid: json["destinationUuid"],
    interactionTypeUuid: json["interactionTypeUuid"],
    interactionType: json["interactionType"],
  );

  Map<String, dynamic> toJson() => {
    "date": date,
    "destinationUuid": destinationUuid,
    "interactionTypeUuid": interactionTypeUuid,
    "interactionType": interactionType,
  };
}
