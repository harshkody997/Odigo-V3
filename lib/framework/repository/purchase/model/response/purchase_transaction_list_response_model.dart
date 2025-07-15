// To parse this JSON data, do
//
//     final purchaseTransactionListResponseModel = purchaseTransactionListResponseModelFromJson(jsonString);

import 'dart:convert';

PurchaseTransactionListResponseModel purchaseTransactionListResponseModelFromJson(String str) => PurchaseTransactionListResponseModel.fromJson(json.decode(str));

String purchaseTransactionListResponseModelToJson(PurchaseTransactionListResponseModel data) => json.encode(data.toJson());

class PurchaseTransactionListResponseModel {
  int? pageNumber;
  List<PurchaseTransactionListData>? data;
  bool? hasNextPage;
  int? totalPages;
  bool? hasPreviousPage;
  int? pageSize;
  String? message;
  int? totalCount;
  int? status;

  PurchaseTransactionListResponseModel({
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

  factory PurchaseTransactionListResponseModel.fromJson(Map<String, dynamic> json) => PurchaseTransactionListResponseModel(
    pageNumber: json['pageNumber'],
    data: json['data'] == null ? [] : List<PurchaseTransactionListData>.from(json['data']!.map((x) => PurchaseTransactionListData.fromJson(x))),
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

class PurchaseTransactionListData {
  String? uuid;
  String? purchaseUuid;
  String? odigoClientUuid;
  String? odigoClientName;
  String? destinationUuid;
  String? destinationName;
  int? originalPrice;
  int? paidPrice;
  String? remarks;
  String? status;
  DateTime? installmentDate;
  DateTime? installmentPaidDate;
  int? createdAt;
  bool? isFromWallet;

  PurchaseTransactionListData({
    this.uuid,
    this.purchaseUuid,
    this.odigoClientUuid,
    this.odigoClientName,
    this.destinationUuid,
    this.destinationName,
    this.originalPrice,
    this.paidPrice,
    this.remarks,
    this.status,
    this.installmentDate,
    this.installmentPaidDate,
    this.createdAt,
    this.isFromWallet,
  });

  factory PurchaseTransactionListData.fromJson(Map<String, dynamic> json) => PurchaseTransactionListData(
    uuid: json['uuid'],
    purchaseUuid: json['purchaseUuid'],
    odigoClientUuid: json['odigoClientUuid'],
    odigoClientName: json['odigoClientName'],
    destinationUuid: json['destinationUuid'],
    destinationName: json['destinationName'],
    originalPrice: json['originalPrice'],
    paidPrice: json['paidPrice'],
    remarks: json['remarks'],
    status: json['status'],
    installmentDate: json['installmentDate'] == null ? null : DateTime.parse(json['installmentDate']),
    installmentPaidDate: json['installmentPaidDate'] == null ? null : DateTime.parse(json['installmentPaidDate']),
    createdAt: json['createdAt'],
    isFromWallet: json['isFromWallet'],
  );

  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'purchaseUuid': purchaseUuid,
    'odigoClientUuid': odigoClientUuid,
    'odigoClientName': odigoClientName,
    'destinationUuid': destinationUuid,
    'destinationName': destinationName,
    'originalPrice': originalPrice,
    'paidPrice': paidPrice,
    'remarks': remarks,
    'status': status,
    'installmentDate': "${installmentDate!.year.toString().padLeft(4, '0')}-${installmentDate!.month.toString().padLeft(2, '0')}-${installmentDate!.day.toString().padLeft(2, '0')}",
    'installmentPaidDate': "${installmentPaidDate!.year.toString().padLeft(4, '0')}-${installmentPaidDate!.month.toString().padLeft(2, '0')}-${installmentPaidDate!.day.toString().padLeft(2, '0')}",
    'createdAt': createdAt,
    'isFromWallet': isFromWallet,
  };
}
