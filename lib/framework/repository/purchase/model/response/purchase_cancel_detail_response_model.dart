// To parse this JSON data, do
//
//     final purchaseCancelDetailResponseModel = purchaseCancelDetailResponseModelFromJson(jsonString);

import 'dart:convert';

PurchaseCancelDetailResponseModel purchaseCancelDetailResponseModelFromJson(String str) => PurchaseCancelDetailResponseModel.fromJson(json.decode(str));

String purchaseCancelDetailResponseModelToJson(PurchaseCancelDetailResponseModel data) => json.encode(data.toJson());

class PurchaseCancelDetailResponseModel {
  String? message;
  PurchaseCancelDetailData? data;
  int? status;

  PurchaseCancelDetailResponseModel({
    this.message,
    this.data,
    this.status,
  });

  factory PurchaseCancelDetailResponseModel.fromJson(Map<String, dynamic> json) => PurchaseCancelDetailResponseModel(
    message: json['message'],
    data: json['data'] == null ? null : PurchaseCancelDetailData.fromJson(json['data']),
    status: json['status'],
  );

  Map<String, dynamic> toJson() => {
    'message': message,
    'data': data?.toJson(),
    'status': status,
  };
}

class PurchaseCancelDetailData {
  int? originalPrice;
  int? purchasePrice;
  double? usedPurchaseAmount;
  int? paidInstallmentAmount;
  int? pendingInstallmentAmount;
  String? transactionType;
  double? amount;

  PurchaseCancelDetailData({
    this.originalPrice,
    this.purchasePrice,
    this.usedPurchaseAmount,
    this.paidInstallmentAmount,
    this.pendingInstallmentAmount,
    this.transactionType,
    this.amount,
  });

  factory PurchaseCancelDetailData.fromJson(Map<String, dynamic> json) => PurchaseCancelDetailData(
    originalPrice: json['originalPrice'],
    purchasePrice: json['purchasePrice'],
    usedPurchaseAmount: json['usedPurchaseAmount']?.toDouble(),
    paidInstallmentAmount: json['paidInstallmentAmount'],
    pendingInstallmentAmount: json['pendingInstallmentAmount'],
    transactionType: json['transactionType'],
    amount: json['amount']?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'originalPrice': originalPrice,
    'purchasePrice': purchasePrice,
    'usedPurchaseAmount': usedPurchaseAmount,
    'paidInstallmentAmount': paidInstallmentAmount,
    'pendingInstallmentAmount': pendingInstallmentAmount,
    'transactionType': transactionType,
    'amount': amount,
  };
}
