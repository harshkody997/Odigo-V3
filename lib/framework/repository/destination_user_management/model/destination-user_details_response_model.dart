// To parse this JSON data, do
//
//     final destinationUserDetailsResponseModel = destinationUserDetailsResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:odigov3/framework/repository/destination_user_management/model/destination_user_list_response_model.dart';

DestinationUserDetailsResponseModel destinationUserDetailsResponseModelFromJson(String str) => DestinationUserDetailsResponseModel.fromJson(json.decode(str));

String destinationUserDetailsResponseModelToJson(DestinationUserDetailsResponseModel data) => json.encode(data.toJson());

class DestinationUserDetailsResponseModel {
  String? message;
  DestinationUserData? data;
  int? status;

  DestinationUserDetailsResponseModel({
    this.message,
    this.data,
    this.status,
  });

  factory DestinationUserDetailsResponseModel.fromJson(Map<String, dynamic> json) => DestinationUserDetailsResponseModel(
    message: json["message"],
    data: json["data"] == null ? null : DestinationUserData.fromJson(json["data"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data?.toJson(),
    "status": status,
  };
}

