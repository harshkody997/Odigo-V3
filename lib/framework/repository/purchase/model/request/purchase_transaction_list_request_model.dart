// To parse this JSON data, do
//
//     final purchaseTransactionListRequestModel = purchaseTransactionListRequestModelFromJson(jsonString);

import 'dart:convert';

PurchaseTransactionListRequestModel purchaseTransactionListRequestModelFromJson(String str) => PurchaseTransactionListRequestModel.fromJson(json.decode(str));

String purchaseTransactionListRequestModelToJson(PurchaseTransactionListRequestModel data) => json.encode(data.toJson());

class PurchaseTransactionListRequestModel {
  dynamic odigoClientUuid;
  String? destinationUuid;
  String? purchaseUuid;
  String? status;
  DateTime? fromInstallmentDate;
  DateTime? toInstallmentDate;
  dynamic fromInstallmentPaidDate;
  dynamic toInstallmentPaidDate;

  PurchaseTransactionListRequestModel({
    this.odigoClientUuid,
    this.destinationUuid,
    this.purchaseUuid,
    this.status,
    this.fromInstallmentDate,
    this.toInstallmentDate,
    this.fromInstallmentPaidDate,
    this.toInstallmentPaidDate,
  });

  factory PurchaseTransactionListRequestModel.fromJson(Map<String, dynamic> json) => PurchaseTransactionListRequestModel(
    odigoClientUuid: json['odigoClientUuid'],
    destinationUuid: json['destinationUuid'],
    purchaseUuid: json['purchaseUuid'],
    status: json['status'],
    fromInstallmentDate: json['fromInstallmentDate'] == null ? null : DateTime.parse(json['fromInstallmentDate']),
    toInstallmentDate: json['toInstallmentDate'] == null ? null : DateTime.parse(json['toInstallmentDate']),
    fromInstallmentPaidDate: json['fromInstallmentPaidDate'],
    toInstallmentPaidDate: json['toInstallmentPaidDate'],
  );

  Map<String, dynamic> toJson() => {
    'odigoClientUuid': odigoClientUuid,
    'destinationUuid': destinationUuid,
    'purchaseUuid': purchaseUuid,
    'status': status,
    'fromInstallmentDate': fromInstallmentDate != null
        ? "${fromInstallmentDate!.year.toString().padLeft(4, '0')}-${fromInstallmentDate!.month.toString().padLeft(2, '0')}-${fromInstallmentDate!.day.toString().padLeft(2, '0')}"
        : null,
    'toInstallmentDate': toInstallmentDate != null
        ? "${toInstallmentDate!.year.toString().padLeft(4, '0')}-${toInstallmentDate!.month.toString().padLeft(2, '0')}-${toInstallmentDate!.day.toString().padLeft(2, '0')}"
        : null,
    'fromInstallmentPaidDate': fromInstallmentPaidDate,
    'toInstallmentPaidDate': toInstallmentPaidDate,
  };
}
