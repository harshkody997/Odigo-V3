// To parse this JSON data, do
//
//     final purchaseTransactionsRequestModel = purchaseTransactionsRequestModelFromJson(jsonString);

import 'dart:convert';

PurchaseTransactionsRequestModel purchaseTransactionsRequestModelFromJson(String str) => PurchaseTransactionsRequestModel.fromJson(json.decode(str));

String purchaseTransactionsRequestModelToJson(PurchaseTransactionsRequestModel data) => json.encode(data.toJson());

class PurchaseTransactionsRequestModel {
  dynamic odigoClientUuid;
  String? destinationUuid;
  String? purchaseUuid;
  String? status;
  String? fromInstallmentDate;
  String? toInstallmentDate;
  dynamic fromInstallmentPaidDate;
  dynamic toInstallmentPaidDate;

  PurchaseTransactionsRequestModel({
    this.odigoClientUuid,
    this.destinationUuid,
    this.purchaseUuid,
    this.status,
    this.fromInstallmentDate,
    this.toInstallmentDate,
    this.fromInstallmentPaidDate,
    this.toInstallmentPaidDate,
  });

  factory PurchaseTransactionsRequestModel.fromJson(Map<String, dynamic> json) => PurchaseTransactionsRequestModel(
    odigoClientUuid: json["odigoClientUuid"],
    destinationUuid: json["destinationUuid"],
    purchaseUuid: json["purchaseUuid"],
    status: json["status"],
    fromInstallmentDate: json["fromInstallmentDate"],
    toInstallmentDate: json["toInstallmentDate"],
    fromInstallmentPaidDate: json["fromInstallmentPaidDate"],
    toInstallmentPaidDate: json["toInstallmentPaidDate"],
  );

  Map<String, dynamic> toJson() => {
    "odigoClientUuid": odigoClientUuid,
    "destinationUuid": destinationUuid,
    "purchaseUuid": purchaseUuid,
    "status": status,
    "fromInstallmentDate": fromInstallmentDate,
    "toInstallmentDate":toInstallmentDate,
    "fromInstallmentPaidDate": fromInstallmentPaidDate,
    "toInstallmentPaidDate": toInstallmentPaidDate,
  };
}
