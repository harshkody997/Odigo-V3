// To parse this JSON data, do
//
//     final companyDetailsResponseModel = companyDetailsResponseModelFromJson(jsonString);

import 'dart:convert';

CompanyDetailsResponseModel companyDetailsResponseModelFromJson(String str) => CompanyDetailsResponseModel.fromJson(json.decode(str));

String companyDetailsResponseModelToJson(CompanyDetailsResponseModel data) => json.encode(data.toJson());

class CompanyDetailsResponseModel {
  String? message;
  CompanyInfo? data;
  int? status;

  CompanyDetailsResponseModel({
    this.message,
    this.data,
    this.status,
  });

  factory CompanyDetailsResponseModel.fromJson(Map<String, dynamic> json) => CompanyDetailsResponseModel(
    message: json['message'],
    data: json['data'] == null ? null : CompanyInfo.fromJson(json['data']),
    status: json['status'],
  );

  Map<String, dynamic> toJson() => {
    'message': message,
    'data': data?.toJson(),
    'status': status,
  };
}

class CompanyInfo {
  String? uuid;
  String? gstNo;
  String? openingHoursFrom;
  String? openingHoursTo;
  String? companyEmail;
  String? companyContact;
  String? customerCareEmail;
  dynamic imageName;
  bool? active;
  double? latitude;
  double? longitude;
  String? stateName;
  String? cityName;
  List<CompanyValue>? companyValues;

  CompanyInfo({
    this.uuid,
    this.gstNo,
    this.openingHoursFrom,
    this.openingHoursTo,
    this.companyEmail,
    this.companyContact,
    this.customerCareEmail,
    this.imageName,
    this.active,
    this.latitude,
    this.longitude,
    this.stateName,
    this.cityName,
    this.companyValues,
  });

  factory CompanyInfo.fromJson(Map<String, dynamic> json) => CompanyInfo(
    uuid: json['uuid'],
    gstNo: json['gstNo'],
    openingHoursFrom: json['openingHoursFrom'],
    openingHoursTo: json['openingHoursTo'],
    companyEmail: json['companyEmail'],
    companyContact: json['companyContact'],
    customerCareEmail: json['customerCareEmail'],
    imageName: json['imageName'],
    active: json['active'],
    latitude: json['latitude']?.toDouble(),
    longitude: json['longitude']?.toDouble(),
    stateName: json['stateName'],
    cityName: json['cityName'],
    companyValues: json['companyValues'] == null ? [] : List<CompanyValue>.from(json['companyValues']!.map((x) => CompanyValue.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'gstNo': gstNo,
    'openingHoursFrom': openingHoursFrom,
    'openingHoursTo': openingHoursTo,
    'companyEmail': companyEmail,
    'companyContact': companyContact,
    'customerCareEmail': customerCareEmail,
    'imageName': imageName,
    'active': active,
    'latitude': latitude,
    'longitude': longitude,
    'stateName': stateName,
    'cityName': cityName,
    'companyValues': companyValues == null ? [] : List<dynamic>.from(companyValues!.map((x) => x.toJson())),
  };
}

class CompanyValue {
  String? languageUuid;
  String? languageName;
  String? uuid;
  String? companyName;
  String? companyAddress;

  CompanyValue({
    this.languageUuid,
    this.languageName,
    this.uuid,
    this.companyName,
    this.companyAddress,
  });

  factory CompanyValue.fromJson(Map<String, dynamic> json) => CompanyValue(
    languageUuid: json['languageUuid'],
    languageName: json['languageName'],
    uuid: json['uuid'],
    companyName: json['companyName'],
    companyAddress: json['companyAddress'],
  );

  Map<String, dynamic> toJson() => {
    'languageUuid': languageUuid,
    'languageName': languageName,
    'uuid': uuid,
    'companyName': companyName,
    'companyAddress': companyAddress,
  };
}
