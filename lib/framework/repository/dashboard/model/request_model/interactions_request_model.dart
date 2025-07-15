// To parse this JSON data, do
//
//     final interactionsRequestModel = interactionsRequestModelFromJson(jsonString);

import 'dart:convert';

InteractionsRequestModel interactionsRequestModelFromJson(String str) => InteractionsRequestModel.fromJson(json.decode(str));

String interactionsRequestModelToJson(InteractionsRequestModel data) => json.encode(data.toJson());

class InteractionsRequestModel {
  int? year;
  int? month;
  String? destinationUuid;
  String? interactionTypeUuid;
  String? interactionType;

  InteractionsRequestModel({
    this.year,
    this.month,
    this.destinationUuid,
    this.interactionTypeUuid,
    this.interactionType,
  });

  factory InteractionsRequestModel.fromJson(Map<String, dynamic> json) => InteractionsRequestModel(
    year: json["year"],
    month: json["month"],
    destinationUuid: json["destinationUuid"],
    interactionTypeUuid: json["interactionTypeUuid"],
    interactionType: json["interactionType"],
  );

  Map<String, dynamic> toJson() => {
    "year": year,
    "month": month,
    "destinationUuid": destinationUuid,
    "interactionTypeUuid": interactionTypeUuid,
    "interactionType": interactionType,
  };
}
