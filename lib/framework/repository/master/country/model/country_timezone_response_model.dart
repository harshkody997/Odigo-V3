// To parse this JSON data, do
//
//     final countryTimeZoneResponseModel = countryTimeZoneResponseModelFromJson(jsonString);

import 'dart:convert';

CountryTimeZoneResponseModel countryTimeZoneResponseModelFromJson(String str) => CountryTimeZoneResponseModel.fromJson(json.decode(str));

String countryTimeZoneResponseModelToJson(CountryTimeZoneResponseModel data) => json.encode(data.toJson());

class CountryTimeZoneResponseModel {
  String? message;
  List<String>? data;
  int? status;

  CountryTimeZoneResponseModel({
    this.message,
    this.data,
    this.status,
  });

  factory CountryTimeZoneResponseModel.fromJson(Map<String, dynamic> json) => CountryTimeZoneResponseModel(
    message: json['message'],
    data: json['data'] == null ? [] : List<String>.from(json['data']!.map((x) => x)),
    status: json['status'],
  );

  Map<String, dynamic> toJson() => {
    'message': message,
    'data': data == null ? [] : List<dynamic>.from(data!.map((x) => x)),
    'status': status,
  };
}
