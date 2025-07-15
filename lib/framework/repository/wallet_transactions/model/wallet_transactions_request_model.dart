// To parse this JSON data, do
//
//     final walletTransactionsRequestModel = walletTransactionsRequestModelFromJson(jsonString);

import 'dart:convert';

WalletTransactionsRequestModel walletTransactionsRequestModelFromJson(String str) => WalletTransactionsRequestModel.fromJson(json.decode(str));

String walletTransactionsRequestModelToJson(WalletTransactionsRequestModel data) => json.encode(data.toJson());

class WalletTransactionsRequestModel {
  String? purchaseUuid;
  String? odigoClientUuid;
  String? walletTransactionType;
  String? status;
  String? transactionType;
  String? fromDate;
  String? toDate;

  WalletTransactionsRequestModel({
    this.purchaseUuid,
    this.odigoClientUuid,
    this.walletTransactionType,
    this.status,
    this.transactionType,
    this.fromDate,
    this.toDate,
  });

  factory WalletTransactionsRequestModel.fromJson(Map<String, dynamic> json) => WalletTransactionsRequestModel(
    purchaseUuid: json["purchaseUuid"],
    odigoClientUuid: json["odigoClientUuid"],
    walletTransactionType: json["walletTransactionType"],
    status: json["status"],
    transactionType: json["transactionType"],
    fromDate: json["fromDate"],
    toDate: json["toDate"],
  );

  Map<String, dynamic> toJson() => {
    "purchaseUuid": purchaseUuid,
    "odigoClientUuid": odigoClientUuid,
    "walletTransactionType": walletTransactionType,
    "status": status,
    "transactionType": transactionType,
    "fromDate": fromDate,
    "toDate": toDate,
  };
}
