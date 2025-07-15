// To parse this JSON data, do
//
//     final purchaseTransactionsListResponseModel = purchaseTransactionsListResponseModelFromJson(jsonString);

import 'dart:convert';

PurchaseTransactionsListResponseModel purchaseTransactionsListResponseModelFromJson(String str) => PurchaseTransactionsListResponseModel.fromJson(json.decode(str));

String purchaseTransactionsListResponseModelToJson(PurchaseTransactionsListResponseModel data) => json.encode(data.toJson());

class PurchaseTransactionsListResponseModel {
  int? pageNumber;
  List<PurchaseTransactionData>? data;
  bool? hasNextPage;
  int? totalPages;
  bool? hasPreviousPage;
  int? pageSize;
  String? message;
  int? totalCount;
  int? status;

  PurchaseTransactionsListResponseModel({
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

  factory PurchaseTransactionsListResponseModel.fromJson(Map<String, dynamic> json) => PurchaseTransactionsListResponseModel(
    pageNumber: json["pageNumber"],
    data: json["data"] == null ? [] : List<PurchaseTransactionData>.from(json["data"]!.map((x) => PurchaseTransactionData.fromJson(x))),
    hasNextPage: json["hasNextPage"],
    totalPages: json["totalPages"],
    hasPreviousPage: json["hasPreviousPage"],
    pageSize: json["pageSize"],
    message: json["message"],
    totalCount: json["totalCount"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "pageNumber": pageNumber,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "hasNextPage": hasNextPage,
    "totalPages": totalPages,
    "hasPreviousPage": hasPreviousPage,
    "pageSize": pageSize,
    "message": message,
    "totalCount": totalCount,
    "status": status,
  };
}

class PurchaseTransactionData {
  String? uuid;
  String? purchaseUuid;
  String? odigoClientUuid;
  String? odigoClientName;
  String? destinationUuid;
  String? destinationName;
  int? originalPrice;
  int? paidPrice;
  dynamic remarks;
  String? status;
  dynamic installmentDate;
  dynamic installmentPaidDate;
  int? createdAt;
  bool? isFromWallet;

  PurchaseTransactionData({
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

  factory PurchaseTransactionData.fromJson(Map<String, dynamic> json) => PurchaseTransactionData(
    uuid: json["uuid"],
    purchaseUuid: json["purchaseUuid"],
    odigoClientUuid: json["odigoClientUuid"],
    odigoClientName: json["odigoClientName"],
    destinationUuid: json["destinationUuid"],
    destinationName: json["destinationName"],
    originalPrice: json["originalPrice"],
    paidPrice: json["paidPrice"],
    remarks: json["remarks"],
    status: json["status"],
    installmentDate: json["installmentDate"],
    installmentPaidDate: json["installmentPaidDate"],
    createdAt: json["createdAt"],
    isFromWallet: json["isFromWallet"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "purchaseUuid": purchaseUuid,
    "odigoClientUuid": odigoClientUuid,
    "odigoClientName": odigoClientName,
    "destinationUuid": destinationUuid,
    "destinationName": destinationName,
    "originalPrice": originalPrice,
    "paidPrice": paidPrice,
    "remarks": remarks,
    "status": status,
    "installmentDate": installmentDate,
    "installmentPaidDate": installmentPaidDate,
    "createdAt": createdAt,
    "isFromWallet": isFromWallet,
  };
}
