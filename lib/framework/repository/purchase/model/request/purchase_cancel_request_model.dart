// To parse this JSON data, do
//
//     final purchaseCancelRequestModel = purchaseCancelRequestModelFromJson(jsonString);

import 'dart:convert';

PurchaseCancelRequestModel purchaseCancelRequestModelFromJson(String str) => PurchaseCancelRequestModel.fromJson(json.decode(str));

String purchaseCancelRequestModelToJson(PurchaseCancelRequestModel data) => json.encode(data.toJson());

class PurchaseCancelRequestModel {
  String? uuid;
  double? cancelledPrice;
  String? remarks;

  PurchaseCancelRequestModel({
    this.uuid,
    this.cancelledPrice,
    this.remarks,
  });

  factory PurchaseCancelRequestModel.fromJson(Map<String, dynamic> json) => PurchaseCancelRequestModel(
    uuid: json['uuid'],
    cancelledPrice: json['cancelledPrice']?.toDouble(),
    remarks: json['remarks'],
  );

  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'cancelledPrice': cancelledPrice,
    'remarks': remarks,
  };
}
