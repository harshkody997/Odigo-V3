// To parse this JSON data, do
//
//     final companyUpdateRequestModel = companyUpdateRequestModelFromJson(jsonString);

import 'dart:convert';

CompanyUpdateRequestModel companyUpdateRequestModelFromJson(String str) => CompanyUpdateRequestModel.fromJson(json.decode(str));

String companyUpdateRequestModelToJson(CompanyUpdateRequestModel data) => json.encode(data.toJson());

class CompanyUpdateRequestModel {
  String? uuid;
  String? gstNo;
  String? openingHoursFrom;
  String? openingHoursTo;
  String? companyEmail;
  String? companyContact;
  String? customerCareEmail;
  String? stateName;
  String? cityName;
  bool? active;
  List<CompanyRequestValue>? companyValues;

  CompanyUpdateRequestModel({
    this.uuid,
    this.gstNo,
    this.openingHoursFrom,
    this.openingHoursTo,
    this.companyEmail,
    this.companyContact,
    this.customerCareEmail,
    this.cityName,
    this.stateName,
    this.active,
    this.companyValues,
  });

  factory CompanyUpdateRequestModel.fromJson(Map<String, dynamic> json) => CompanyUpdateRequestModel(
    uuid: json["uuid"],
    gstNo: json["gstNo"],
    openingHoursFrom: json["openingHoursFrom"],
    openingHoursTo: json["openingHoursTo"],
    companyEmail: json["companyEmail"],
    companyContact: json["companyContact"],
    customerCareEmail: json["customerCareEmail"],
    cityName: json["cityName"],
    stateName: json["stateName"],
    active: json["active"],
    companyValues: json["companyValues"] == null ? [] : List<CompanyRequestValue>.from(json["companyValues"]!.map((x) => CompanyRequestValue.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "gstNo": gstNo,
    "openingHoursFrom": openingHoursFrom,
    "openingHoursTo": openingHoursTo,
    "companyEmail": companyEmail,
    "companyContact": companyContact,
    "customerCareEmail": customerCareEmail,
    "stateName": stateName,
    "cityName": cityName,
    "active": active,
    "companyValues": companyValues == null ? [] : List<dynamic>.from(companyValues!.map((x) => x.toJson())),
  };
}

class CompanyRequestValue {
  String? languageUuid;
  String? companyName;
  String? companyAddress;

  CompanyRequestValue({
    this.languageUuid,
    this.companyName,
    this.companyAddress,
  });

  factory CompanyRequestValue.fromJson(Map<String, dynamic> json) => CompanyRequestValue(
    languageUuid: json["languageUuid"],
    companyName: json["companyName"],
    companyAddress: json["companyAddress"],
  );

  Map<String, dynamic> toJson() => {
    "languageUuid": languageUuid,
    "companyName": companyName,
    "companyAddress": companyAddress,
  };
}
