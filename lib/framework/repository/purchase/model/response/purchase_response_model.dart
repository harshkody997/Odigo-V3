// To parse this JSON data, do
//
//     final purchaseListResponseModel = purchaseListResponseModelFromJson(jsonString);

import 'dart:convert';

PurchaseListResponseModel purchaseListResponseModelFromJson(String str) => PurchaseListResponseModel.fromJson(json.decode(str));

String purchaseListResponseModelToJson(PurchaseListResponseModel data) => json.encode(data.toJson());

class PurchaseListResponseModel {
  int? pageNumber;
  List<PurchaseData>? data;
  bool? hasNextPage;
  int? totalPages;
  bool? hasPreviousPage;
  int? pageSize;
  String? message;
  int? totalCount;
  int? status;

  PurchaseListResponseModel({
    this.pageNumber,
    this.data,
    this.hasNextPage,
    this.totalPages,
    this.hasPreviousPage,
    this.pageSize,
    this.message,
    this.totalCount,
    this.status,
  });

  factory PurchaseListResponseModel.fromJson(Map<String, dynamic> json) => PurchaseListResponseModel(
    pageNumber: json['pageNumber'],
    data: json['data'] == null ? [] : List<PurchaseData>.from(json['data']!.map((x) => PurchaseData.fromJson(x))),
    hasNextPage: json['hasNextPage'],
    totalPages: json['totalPages'],
    hasPreviousPage: json['hasPreviousPage'],
    pageSize: json['pageSize'],
    message: json['message'],
    totalCount: json['totalCount'],
    status: json['status'],
  );

  Map<String, dynamic> toJson() => {
    'pageNumber': pageNumber,
    'data': data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    'hasNextPage': hasNextPage,
    'totalPages': totalPages,
    'hasPreviousPage': hasPreviousPage,
    'pageSize': pageSize,
    'message': message,
    'totalCount': totalCount,
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
    'createdAt': createdAt,
  };
}
