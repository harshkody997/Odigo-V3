// To parse this JSON data, do
//
//     final mostRequestedStoreRequestModel = mostRequestedStoreRequestModelFromJson(jsonString);

import 'dart:convert';

MostRequestedStoreRequestModel mostRequestedStoreRequestModelFromJson(String str) => MostRequestedStoreRequestModel.fromJson(json.decode(str));

String mostRequestedStoreRequestModelToJson(MostRequestedStoreRequestModel data) => json.encode(data.toJson());

class MostRequestedStoreRequestModel {
  int? year;
  int? month;
  int? day;
  String? destinationUuid;
  String? categoryUuid;

  MostRequestedStoreRequestModel({
    this.year,
    this.month,
    this.day,
    this.destinationUuid,
    this.categoryUuid,
  });

  factory MostRequestedStoreRequestModel.fromJson(Map<String, dynamic> json) => MostRequestedStoreRequestModel(
    year: json['year'],
    month: json['month'],
    day: json['day'],
    destinationUuid: json['destinationUuid'],
    categoryUuid: json['categoryUuid'],
  );

  Map<String, dynamic> toJson() => {
    'year': year,
    'month': month,
    'day': day,
    'destinationUuid': destinationUuid,
    'categoryUuid': categoryUuid,
  };
}
