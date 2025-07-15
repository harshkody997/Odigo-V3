// To parse this JSON data, do
//
//     final purchaseWeeksResponseModel = purchaseWeeksResponseModelFromJson(jsonString);

import 'dart:convert';

PurchaseWeeksResponseModel purchaseWeeksResponseModelFromJson(String str) => PurchaseWeeksResponseModel.fromJson(json.decode(str));

String purchaseWeeksResponseModelToJson(PurchaseWeeksResponseModel data) => json.encode(data.toJson());

class PurchaseWeeksResponseModel {
  String? message;
  List<PurchaseWeeksData>? data;
  int? status;

  PurchaseWeeksResponseModel({
    this.message,
    this.data,
    this.status,
  });

  factory PurchaseWeeksResponseModel.fromJson(Map<String, dynamic> json) => PurchaseWeeksResponseModel(
    message: json['message'],
    data: json['data'] == null ? [] : List<PurchaseWeeksData>.from(json['data']!.map((x) => PurchaseWeeksData.fromJson(x))),
    status: json['status'],
  );

  Map<String, dynamic> toJson() => {
    'message': message,
    'data': data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    'status': status,
  };
}

class PurchaseWeeksData {
  int? weekNumber;
  String? year;
  DateTime? startDate;
  DateTime? endDate;

  PurchaseWeeksData({
    this.weekNumber,
    this.year,
    this.startDate,
    this.endDate,
  });

  factory PurchaseWeeksData.fromJson(Map<String, dynamic> json) => PurchaseWeeksData(
    weekNumber: json['weekNumber'],
    year: json['year'],
    startDate: json['startDate'] == null ? null : DateTime.parse(json['startDate']),
    endDate: json['endDate'] == null ? null : DateTime.parse(json['endDate']),
  );

  Map<String, dynamic> toJson() => {
    'weekNumber': weekNumber,
    'year': year,
    'startDate': "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}",
    'endDate': "${endDate!.year.toString().padLeft(4, '0')}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}",
  };
}
