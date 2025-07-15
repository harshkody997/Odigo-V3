// To parse this JSON data, do
//
//     final purchaseRefundRequestModel = purchaseRefundRequestModelFromJson(jsonString);

import 'dart:convert';

PurchaseRefundRequestModel purchaseRefundRequestModelFromJson(String str) => PurchaseRefundRequestModel.fromJson(json.decode(str));

String purchaseRefundRequestModelToJson(PurchaseRefundRequestModel data) => json.encode(data.toJson());

class PurchaseRefundRequestModel {
  String? uuid;
  int? refundedPrice;
  String? remarks;

  PurchaseRefundRequestModel({
    this.uuid,
    this.refundedPrice,
    this.remarks,
  });

  factory PurchaseRefundRequestModel.fromJson(Map<String, dynamic> json) => PurchaseRefundRequestModel(
    uuid: json['uuid'],
    refundedPrice: json['refundedPrice'],
    remarks: json['remarks'],
  );

  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'refundedPrice': refundedPrice,
    'remarks': remarks,
  };
}
