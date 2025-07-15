// To parse this JSON data, do
//
//     final purchaseListRequestModel = purchaseListRequestModelFromJson(jsonString);

import 'dart:convert';

PurchaseListRequestModel purchaseListRequestModelFromJson(String str) => PurchaseListRequestModel.fromJson(json.decode(str));

String purchaseListRequestModelToJson(PurchaseListRequestModel data) => json.encode(data.toJson());

class PurchaseListRequestModel {
  String? odigoClientUuid;
  String? destinationUuid;
  String? purchaseType;
  String? paymentType;
  String? status;
  String? searchKeyword;
  String? fromDate;
  String? toDate;

  PurchaseListRequestModel({
    this.odigoClientUuid,
    this.destinationUuid,
    this.purchaseType,
    this.searchKeyword,
    this.paymentType,
    this.status,
    this.fromDate,
    this.toDate,
  });

  factory PurchaseListRequestModel.fromJson(Map<String, dynamic> json) => PurchaseListRequestModel(
    odigoClientUuid: json['odigoClientUuid'],
    destinationUuid: json['destinationUuid'],
    searchKeyword: json['searchKeyword'],
    purchaseType: json['purchaseType'],
    paymentType: json['paymentType'],
    status: json['status'],
    fromDate: json['fromDate'],
    toDate: json['toDate'],
  );

  Map<String, dynamic> toJson() => {
    'odigoClientUuid': odigoClientUuid,
    'destinationUuid': destinationUuid,
    'searchKeyword': searchKeyword,
    'purchaseType': purchaseType,
    'paymentType': paymentType,
    'status': status,
    'fromDate': fromDate,
    'toDate': toDate,
  };
}
