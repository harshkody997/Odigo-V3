// To parse this JSON data, do
//
//     final purchaseDetailsResponseModel = purchaseDetailsResponseModelFromJson(jsonString);

import 'dart:convert';

PurchaseDetailsResponseModel purchaseDetailsResponseModelFromJson(String str) => PurchaseDetailsResponseModel.fromJson(json.decode(str));

String purchaseDetailsResponseModelToJson(PurchaseDetailsResponseModel data) => json.encode(data.toJson());

class PurchaseDetailsResponseModel {
  String? message;
  PurchaseData? data;
  int? status;

  PurchaseDetailsResponseModel({
    this.message,
    this.data,
    this.status,
  });

  factory PurchaseDetailsResponseModel.fromJson(Map<String, dynamic> json) => PurchaseDetailsResponseModel(
    message: json['message'],
    data: json['data'] == null ? null : PurchaseData.fromJson(json['data']),
    status: json['status'],
  );

  Map<String, dynamic> toJson() => {
    'message': message,
    'data': data?.toJson(),
    'status': status,
  };
}

class PurchaseData {
  String? uuid;
  String? odigoClientUuid;
  String? odigoClientName;
  String? destinationUuid;
  String? destinationName;
  String? purchaseType;
  int? weeklyPrice;
  int? totalWeeks;
  String? paymentType;
  int? originalPrice;
  int? purchasePrice;
  String? remarks;
  String? status;
  DateTime? startDate;
  DateTime? endDate;
  List<PurchaseWeek>? purchaseWeeks;
  int? createdAt;

  PurchaseData({
    this.uuid,
    this.odigoClientUuid,
    this.odigoClientName,
    this.destinationUuid,
    this.destinationName,
    this.purchaseType,
    this.weeklyPrice,
    this.totalWeeks,
    this.paymentType,
    this.originalPrice,
    this.purchasePrice,
    this.remarks,
    this.status,
    this.startDate,
    this.endDate,
    this.purchaseWeeks,
    this.createdAt,
  });

  factory PurchaseData.fromJson(Map<String, dynamic> json) => PurchaseData(
    uuid: json['uuid'],
    odigoClientUuid: json['odigoClientUuid'],
    odigoClientName: json['odigoClientName'],
    destinationUuid: json['destinationUuid'],
    destinationName: json['destinationName'],
    purchaseType: json['purchaseType'],
    weeklyPrice: json['weeklyPrice'],
    totalWeeks: json['totalWeeks'],
    paymentType: json['paymentType'],
    originalPrice: json['originalPrice'],
    purchasePrice: json['purchasePrice'],
    remarks: json['remarks'],
    status: json['status'],
    startDate: json['startDate'] == null ? null : DateTime.parse(json['startDate']),
    endDate: json['endDate'] == null ? null : DateTime.parse(json['endDate']),
    purchaseWeeks: json['purchaseWeeks'] == null ? [] : List<PurchaseWeek>.from(json['purchaseWeeks']!.map((x) => PurchaseWeek.fromJson(x))),
    createdAt: json['createdAt'],
  );

  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'odigoClientUuid': odigoClientUuid,
    'odigoClientName': odigoClientName,
    'destinationUuid': destinationUuid,
    'destinationName': destinationName,
    'purchaseType': purchaseType,
    'weeklyPrice': weeklyPrice,
    'totalWeeks': totalWeeks,
    'paymentType': paymentType,
    'originalPrice': originalPrice,
    'purchasePrice': purchasePrice,
    'remarks': remarks,
    'status': status,
    'startDate': "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}",
    'endDate': "${endDate!.year.toString().padLeft(4, '0')}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}",
    'purchaseWeeks': purchaseWeeks == null ? [] : List<dynamic>.from(purchaseWeeks!.map((x) => x.toJson())),
    'createdAt': createdAt,
  };
}

class PurchaseWeek {
  String? uuid;
  String? purchaseYear;
  int? week;
  DateTime? startDate;
  DateTime? endDate;
  String? startDayOfWeek;

  PurchaseWeek({
    this.uuid,
    this.purchaseYear,
    this.week,
    this.startDate,
    this.endDate,
    this.startDayOfWeek,
  });

  factory PurchaseWeek.fromJson(Map<String, dynamic> json) => PurchaseWeek(
    uuid: json['uuid'],
    purchaseYear: json['purchaseYear'],
    week: json['week'],
    startDate: json['startDate'] == null ? null : DateTime.parse(json['startDate']),
    endDate: json['endDate'] == null ? null : DateTime.parse(json['endDate']),
    startDayOfWeek: json['startDayOfWeek'],
  );

  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'purchaseYear': purchaseYear,
    'week': week,
    'startDate': "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}",
    'endDate': "${endDate!.year.toString().padLeft(4, '0')}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}",
    'startDayOfWeek': startDayOfWeek,
  };
}
