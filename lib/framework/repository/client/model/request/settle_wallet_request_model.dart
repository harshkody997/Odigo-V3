// To parse this JSON data, do
//
//     final settleWalletRequestModel = settleWalletRequestModelFromJson(jsonString);

import 'dart:convert';

SettleWalletRequestModel settleWalletRequestModelFromJson(String str) => SettleWalletRequestModel.fromJson(json.decode(str));

String settleWalletRequestModelToJson(SettleWalletRequestModel data) => json.encode(data.toJson());

class SettleWalletRequestModel {
  String? odigoClientUuid;
  int? amount;
  String? transactionType;
  String? remarks;

  SettleWalletRequestModel({
    this.odigoClientUuid,
    this.amount,
    this.transactionType,
    this.remarks,
  });

  factory SettleWalletRequestModel.fromJson(Map<String, dynamic> json) => SettleWalletRequestModel(
    odigoClientUuid: json["odigoClientUuid"],
    amount: json["amount"],
    transactionType: json["transactionType"],
    remarks: json["remarks"],
  );

  Map<String, dynamic> toJson() => {
    "odigoClientUuid": odigoClientUuid,
    "amount": amount,
    "transactionType": transactionType,
    "remarks": remarks,
  };
}
