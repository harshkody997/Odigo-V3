// To parse this JSON data, do
//
//     final commonResponseModel = commonResponseModelFromJson(jsonString);

import 'dart:convert';

CommonResponseModel commonResponseModelFromJson(String str) => CommonResponseModel.fromJson(json.decode(str));

String commonResponseModelToJson(CommonResponseModel data) => json.encode(data.toJson());

class CommonResponseModel {
  String? message;
  int? status;

  CommonResponseModel({
    this.message,
    this.status,
  });

  factory CommonResponseModel.fromJson(Map<String, dynamic> json) => CommonResponseModel(
    message: json['message'],
    status: json['status'],
  );

  Map<String, dynamic> toJson() => {
    'message': message,
    'status': status,
  };
}
