// To parse this JSON data, do
//
//     final changeMobileNumberRequestModel = changeMobileNumberRequestModelFromJson(jsonString);

import 'dart:convert';

ChangeMobileNumberRequestModel changeMobileNumberRequestModelFromJson(String str) => ChangeMobileNumberRequestModel.fromJson(json.decode(str));

String changeMobileNumberRequestModelToJson(ChangeMobileNumberRequestModel data) => json.encode(data.toJson());

class ChangeMobileNumberRequestModel {
  String? contactNumber;

  ChangeMobileNumberRequestModel({
    this.contactNumber,
  });

  factory ChangeMobileNumberRequestModel.fromJson(Map<String, dynamic> json) => ChangeMobileNumberRequestModel(
    contactNumber: json["contactNumber"],
  );

  Map<String, dynamic> toJson() => {
    "contactNumber": contactNumber,
  };
}
