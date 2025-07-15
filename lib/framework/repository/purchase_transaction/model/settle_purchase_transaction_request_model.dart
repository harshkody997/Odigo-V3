// To parse this JSON data, do
//
//     final settlePurchaseTransactionRequestModel = settlePurchaseTransactionRequestModelFromJson(jsonString);

import 'dart:convert';

SettlePurchaseTransactionRequestModel settlePurchaseTransactionRequestModelFromJson(String str) => SettlePurchaseTransactionRequestModel.fromJson(json.decode(str));

String settlePurchaseTransactionRequestModelToJson(SettlePurchaseTransactionRequestModel data) => json.encode(data.toJson());

class SettlePurchaseTransactionRequestModel {
  String? uuid;
  DateTime? installmentDate;
  String? paymentStatus;
  String? remarks;

  SettlePurchaseTransactionRequestModel({
    this.uuid,
    this.installmentDate,
    this.paymentStatus,
    this.remarks,
  });

  factory SettlePurchaseTransactionRequestModel.fromJson(Map<String, dynamic> json) => SettlePurchaseTransactionRequestModel(
    uuid: json["uuid"],
    installmentDate: json["installmentDate"] == null ? null : DateTime.parse(json["installmentDate"]),
    paymentStatus: json["paymentStatus"],
    remarks: json["remarks"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "installmentDate": "${installmentDate!.year.toString().padLeft(4, '0')}-${installmentDate!.month.toString().padLeft(2, '0')}-${installmentDate!.day.toString().padLeft(2, '0')}",
    "paymentStatus": paymentStatus,
    "remarks": remarks,
  };
}
