// To parse this JSON data, do
//
//     final profileNameChangeRequestModel = profileNameChangeRequestModelFromJson(jsonString);

import 'dart:convert';

ProfileNameChangeRequestModel profileNameChangeRequestModelFromJson(String str) => ProfileNameChangeRequestModel.fromJson(json.decode(str));

String profileNameChangeRequestModelToJson(ProfileNameChangeRequestModel data) => json.encode(data.toJson());

class ProfileNameChangeRequestModel {
  String? name;

  ProfileNameChangeRequestModel({
    this.name,
  });

  factory ProfileNameChangeRequestModel.fromJson(Map<String, dynamic> json) => ProfileNameChangeRequestModel(
    name: json['name'],
  );

  Map<String, dynamic> toJson() => {
    'name': name,
  };
}
