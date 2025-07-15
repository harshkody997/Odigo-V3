// To parse this JSON data, do
//
//     final walletTransactionsListResponseModel = walletTransactionsListResponseModelFromJson(jsonString);

import 'dart:convert';

WalletTransactionsListResponseModel walletTransactionsListResponseModelFromJson(String str) => WalletTransactionsListResponseModel.fromJson(json.decode(str));

String walletTransactionsListResponseModelToJson(WalletTransactionsListResponseModel data) => json.encode(data.toJson());

class WalletTransactionsListResponseModel {
  int? pageNumber;
  List<WalletData>? data;
  bool? hasNextPage;
  int? totalPages;
  bool? hasPreviousPage;
  int? pageSize;
  String? message;
  int? totalCount;
  int? status;

  WalletTransactionsListResponseModel({
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

  factory WalletTransactionsListResponseModel.fromJson(Map<String, dynamic> json) => WalletTransactionsListResponseModel(
    pageNumber: json["pageNumber"],
    data: json["data"] == null ? [] : List<WalletData>.from(json["data"]!.map((x) => WalletData.fromJson(x))),
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

class WalletData {
  String? uuid;
  String? odigoClientUuid;
  String? odigoClientName;
  String? purchaseUuid;
  double? originalPrice;
  int? paidPrice;
  String? remarks;
  String? walletTransactionType;
  String? status;
  int? currentBalance;
  String? transactionType;
  int? createdAt;

  WalletData({
    this.uuid,
    this.odigoClientUuid,
    this.odigoClientName,
    this.purchaseUuid,
    this.originalPrice,
    this.paidPrice,
    this.remarks,
    this.walletTransactionType,
    this.status,
    this.currentBalance,
    this.transactionType,
    this.createdAt,
  });

  factory WalletData.fromJson(Map<String, dynamic> json) => WalletData(
    uuid: json["uuid"],
    odigoClientUuid: json["odigoClientUuid"],
    odigoClientName: json["odigoClientName"],
    purchaseUuid: json["purchaseUuid"],
    originalPrice: json["originalPrice"]?.toDouble(),
    paidPrice: json["paidPrice"],
    remarks: json["remarks"],
    walletTransactionType: json["walletTransactionType"],
    status: json["status"],
    currentBalance: json["currentBalance"],
    transactionType: json["transactionType"],
    createdAt: json["createdAt"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "odigoClientUuid": odigoClientUuid,
    "odigoClientName": odigoClientName,
    "purchaseUuid": purchaseUuid,
    "originalPrice": originalPrice,
    "paidPrice": paidPrice,
    "remarks": remarks,
    "walletTransactionType": walletTransactionType,
    "status": status,
    "currentBalance": currentBalance,
    "transactionType": transactionType,
    "createdAt": createdAt,
  };
}
