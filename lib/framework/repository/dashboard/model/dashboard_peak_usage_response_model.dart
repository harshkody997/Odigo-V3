// To parse this JSON data, do
//
//     final dashboardPeakUsageResponseModel = dashboardPeakUsageResponseModelFromJson(jsonString);

import 'dart:convert';

DashboardPeakUsageResponseModel dashboardPeakUsageResponseModelFromJson(String str) => DashboardPeakUsageResponseModel.fromJson(json.decode(str));

String dashboardPeakUsageResponseModelToJson(DashboardPeakUsageResponseModel data) => json.encode(data.toJson());

class DashboardPeakUsageResponseModel {
  String? message;
  Data? data;
  int? status;

  DashboardPeakUsageResponseModel({
    this.message,
    this.data,
    this.status,
  });

  factory DashboardPeakUsageResponseModel.fromJson(Map<String, dynamic> json) => DashboardPeakUsageResponseModel(
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data?.toJson(),
    "status": status,
  };
}

class Data {
  List<PeakUsageDto>? peakUsageDtOs;

  Data({
    this.peakUsageDtOs,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    peakUsageDtOs: json["peakUsageDTOs"] == null ? [] : List<PeakUsageDto>.from(json["peakUsageDTOs"]!.map((x) => PeakUsageDto.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "peakUsageDTOs": peakUsageDtOs == null ? [] : List<dynamic>.from(peakUsageDtOs!.map((x) => x.toJson())),
  };
}

class PeakUsageDto {
  int? startHour;
  int? endHour;
  int? count;

  PeakUsageDto({
    this.startHour,
    this.endHour,
    this.count,
  });

  factory PeakUsageDto.fromJson(Map<String, dynamic> json) => PeakUsageDto(
    startHour: json["startHour"],
    endHour: json["endHour"],
    count: json["count"],
  );

  Map<String, dynamic> toJson() => {
    "startHour": startHour,
    "endHour": endHour,
    "count": count,
  };
}
