// To parse this JSON data, do
//
//     final dashboardWeekInteractionCountResponseModel = dashboardWeekInteractionCountResponseModelFromJson(jsonString);

import 'dart:convert';

DashboardWeekInteractionCountResponseModel dashboardWeekInteractionCountResponseModelFromJson(String str) => DashboardWeekInteractionCountResponseModel.fromJson(json.decode(str));

String dashboardWeekInteractionCountResponseModelToJson(DashboardWeekInteractionCountResponseModel data) => json.encode(data.toJson());

class DashboardWeekInteractionCountResponseModel {
  String? message;
  DashboardWeekInteractionCountData? data;
  int? status;

  DashboardWeekInteractionCountResponseModel({
    this.message,
    this.data,
    this.status,
  });

  factory DashboardWeekInteractionCountResponseModel.fromJson(Map<String, dynamic> json) => DashboardWeekInteractionCountResponseModel(
    message: json["message"],
    data: json["data"] == null ? null : DashboardWeekInteractionCountData.fromJson(json["data"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data?.toJson(),
    "status": status,
  };
}

class DashboardWeekInteractionCountData {
  List<WeekWiseInteractionResponse>? weekWiseInteractionResponse;

  DashboardWeekInteractionCountData({
    this.weekWiseInteractionResponse,
  });

  factory DashboardWeekInteractionCountData.fromJson(Map<String, dynamic> json) => DashboardWeekInteractionCountData(
    weekWiseInteractionResponse: json["weekWiseInteractionResponse"] == null ? [] : List<WeekWiseInteractionResponse>.from(json["weekWiseInteractionResponse"]!.map((x) => WeekWiseInteractionResponse.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "weekWiseInteractionResponse": weekWiseInteractionResponse == null ? [] : List<dynamic>.from(weekWiseInteractionResponse!.map((x) => x.toJson())),
  };
}

class WeekWiseInteractionResponse {
  String? dayOfWeek;
  int? date;
  int? interactionCount;

  WeekWiseInteractionResponse({
    this.dayOfWeek,
    this.date,
    this.interactionCount,
  });

  factory WeekWiseInteractionResponse.fromJson(Map<String, dynamic> json) => WeekWiseInteractionResponse(
    dayOfWeek: json["dayOfWeek"],
    date: json["date"],
    interactionCount: json["interactionCount"],
  );

  Map<String, dynamic> toJson() => {
    "dayOfWeek": dayOfWeek,
    "date": date,
    "interactionCount": interactionCount,
  };
}
