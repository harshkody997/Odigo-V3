// To parse this JSON data, do
//
//     final userDetailsResponseModel = userDetailsResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:odigov3/framework/repository/user_management/model/response/users_data.dart';

UserDetailsResponseModel userDetailsResponseModelFromJson(String str) =>
    UserDetailsResponseModel.fromJson(json.decode(str));

String userDetailsResponseModelToJson(UserDetailsResponseModel data) => json.encode(data.toJson());

class UserDetailsResponseModel {
  String? message;
  UserData? data;
  int? status;

  UserDetailsResponseModel({this.message, this.data, this.status});

  factory UserDetailsResponseModel.fromJson(Map<String, dynamic> json) => UserDetailsResponseModel(
    message: json['message'],
    data: json['data'] == null ? null : UserData.fromJson(json['data']),
    status: json['status'],
  );

  Map<String, dynamic> toJson() => {'message': message, 'data': data?.toJson(), 'status': status};
}
