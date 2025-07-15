// To parse this JSON data, do
//
//     final purchaseRefundDetailResponseModel = purchaseRefundDetailResponseModelFromJson(jsonString);

import 'dart:convert';

PurchaseRefundDetailResponseModel purchaseRefundDetailResponseModelFromJson(String str) => PurchaseRefundDetailResponseModel.fromJson(json.decode(str));

String purchaseRefundDetailResponseModelToJson(PurchaseRefundDetailResponseModel data) => json.encode(data.toJson());

class PurchaseRefundDetailResponseModel {
  String? message;
  PurchaseRefundDetailData? data;
  int? status;

  PurchaseRefundDetailResponseModel({
    this.message,
    this.data,
    this.status,
  });

  factory PurchaseRefundDetailResponseModel.fromJson(Map<String, dynamic> json) => PurchaseRefundDetailResponseModel(
    message: json['message'],
    data: json['data'] == null ? null : PurchaseRefundDetailData.fromJson(json['data']),
    status: json['status'],
  );

  Map<String, dynamic> toJson() => {
    'message': message,
    'data': data?.toJson(),
    'status': status,
  };
}

class PurchaseRefundDetailData {
  int? originalPrice;
  int? purchasePrice;
  double? systemCalculatedRefundPrice;

  PurchaseRefundDetailData({
    this.originalPrice,
    this.purchasePrice,
    this.systemCalculatedRefundPrice,
  });

  factory PurchaseRefundDetailData.fromJson(Map<String, dynamic> json) => PurchaseRefundDetailData(
    originalPrice: json['originalPrice'],
    purchasePrice: json['purchasePrice'],
    systemCalculatedRefundPrice: json['systemCalculatedRefundPrice']?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'originalPrice': originalPrice,
    'purchasePrice': purchasePrice,
    'systemCalculatedRefundPrice': systemCalculatedRefundPrice,
  };
}
