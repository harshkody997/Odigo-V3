// To parse this JSON data, do
//
//     final countryListResponseModel = countryListResponseModelFromJson(jsonString);

import 'dart:convert';

CountryListResponseModel countryListResponseModelFromJson(String str) => CountryListResponseModel.fromJson(json.decode(str));

String countryListResponseModelToJson(CountryListResponseModel data) => json.encode(data.toJson());

class CountryListResponseModel {
  int? pageNumber;
  List<CountryModel>? data;
  bool? hasNextPage;
  int? totalPages;
  bool? hasPreviousPage;
  int? pageSize;
  String? message;
  int? totalCount;
  int? status;

  CountryListResponseModel({
    this.pageNumber,
    this.data,
    this.hasNextPage,
    this.totalPages,
    this.hasPreviousPage,
    this.pageSize,
    this.message,
    this.totalCount,
    this.status,
  });

  factory CountryListResponseModel.fromJson(Map<String, dynamic> json) => CountryListResponseModel(
    pageNumber: json['pageNumber'],
    data: json['data'] == null ? [] : List<CountryModel>.from(json['data']!.map((x) => CountryModel.fromJson(x))),
    hasNextPage: json['hasNextPage'],
    totalPages: json['totalPages'],
    hasPreviousPage: json['hasPreviousPage'],
    pageSize: json['pageSize'],
    message: json['message'],
    totalCount: json['totalCount'],
    status: json['status'],
  );

  Map<String, dynamic> toJson() => {
    'pageNumber': pageNumber,
    'data': data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    'hasNextPage': hasNextPage,
    'totalPages': totalPages,
    'hasPreviousPage': hasPreviousPage,
    'pageSize': pageSize,
    'message': message,
    'totalCount': totalCount,
    'status': status,
  };
}

class CountryModel {
  String? uuid;
  String? name;
  String? currency;
  String? code;
  bool? active;

  CountryModel({
    this.uuid,
    this.name,
    this.currency,
    this.code,
    this.active,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) => CountryModel(
    uuid: json['uuid'],
    name: json['name'],
    currency: json['currency'],
    code: json['code'],
    active: json['active'],
  );

  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'name': name,
    'currency': currency,
    'code': code,
    'active': active,
  };
}
