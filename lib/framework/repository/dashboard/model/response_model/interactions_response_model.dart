// To parse this JSON data, do
//
//     final averageInteractionResponseModel = averageInteractionResponseModelFromJson(jsonString);

import 'dart:convert';

AverageInteractionResponseModel averageInteractionResponseModelFromJson(String str) => AverageInteractionResponseModel.fromJson(json.decode(str));

String averageInteractionResponseModelToJson(AverageInteractionResponseModel data) => json.encode(data.toJson());

class AverageInteractionResponseModel {
  String? message;
  Map<String, AverageInteractionData>? data;
  int? status;

  AverageInteractionResponseModel({
    this.message,
    this.data,
    this.status,
  });

  factory AverageInteractionResponseModel.fromJson(Map<String, dynamic> json) => AverageInteractionResponseModel(
        message: json["message"],
        data: Map.from(json["data"]!).map((k, v) => MapEntry<String, AverageInteractionData>(k, AverageInteractionData.fromJson(v))),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": Map.from(data!).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
        "status": status,
      };
}

class AverageInteractionData {
  String? dayOfWeek;
  double? count;

  AverageInteractionData({
    this.dayOfWeek,
    this.count,
  });

  factory AverageInteractionData.fromJson(Map<String, dynamic> json) => AverageInteractionData(
        dayOfWeek: json["dayOfWeek"],
        count: json["count"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "dayOfWeek": dayOfWeek,
        "count": count,
      };
}
