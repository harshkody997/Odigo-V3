// To parse this JSON data, do
//
//     final totalNavigationRequestModel = totalNavigationRequestModelFromJson(jsonString);

import 'dart:convert';

TotalNavigationRequestModel totalNavigationRequestModelFromJson(String str) => TotalNavigationRequestModel.fromJson(json.decode(str));

String totalNavigationRequestModelToJson(TotalNavigationRequestModel data) => json.encode(data.toJson());

class TotalNavigationRequestModel {
  int? year;
  int? month;
  String? destinationUuid;
  String? storeUuid;

  TotalNavigationRequestModel({
    this.year,
    this.month,
    this.destinationUuid,
    this.storeUuid,
  });

  factory TotalNavigationRequestModel.fromJson(Map<String, dynamic> json) => TotalNavigationRequestModel(
    year: json['year'],
    month: json['month'],
    destinationUuid: json['destinationUuid'],
    storeUuid: json['storeUuid'],
  );

  Map<String, dynamic> toJson() => {
    'year': year,
    'month': month,
    'destinationUuid': destinationUuid,
    'storeUuid': storeUuid,
  };
}
