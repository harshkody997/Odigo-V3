// To parse this JSON data, do
//
//     final clientListResponseModel = clientListResponseModelFromJson(jsonString);

import 'dart:convert';

ClientListResponseModel clientListResponseModelFromJson(String str) => ClientListResponseModel.fromJson(json.decode(str));

String clientListResponseModelToJson(ClientListResponseModel data) => json.encode(data.toJson());

class ClientListResponseModel {
  int? pageNumber;
  List<ClientData>? data;
  bool? hasNextPage;
  int? totalPages;
  bool? hasPreviousPage;
  int? pageSize;
  String? message;
  int? totalCount;
  int? status;

  ClientListResponseModel({
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

  factory ClientListResponseModel.fromJson(Map<String, dynamic> json) => ClientListResponseModel(
    pageNumber: json['pageNumber'],
    data: json['data'] == null ? [] : List<ClientData>.from(json['data']!.map((x) => ClientData.fromJson(x))),
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

class ClientData {
  String? uuid;
  String? name;
  String? email;
  String? contactNumber;
  dynamic password;
  String? houseNumber;
  String? streetName;
  String? addressLine1;
  String? addressLine2;
  String? landmark;
  String? cityUuid;
  String? stateUuid;
  String? countryUuid;
  String? countryName;
  String? countryCurrency;
  String? countryCode;
  String? stateName;
  String? cityName;
  String? postalCode;
  int? wallet;
  bool? active;

  ClientData({
    this.uuid,
    this.name,
    this.email,
    this.contactNumber,
    this.password,
    this.houseNumber,
    this.streetName,
    this.addressLine1,
    this.addressLine2,
    this.landmark,
    this.cityUuid,
    this.stateUuid,
    this.countryUuid,
    this.countryName,
    this.countryCurrency,
    this.countryCode,
    this.stateName,
    this.cityName,
    this.postalCode,
    this.wallet,
    this.active,
  });

  factory ClientData.fromJson(Map<String, dynamic> json) => ClientData(
    uuid: json['uuid'],
    name: json['name'],
    email: json['email'],
    contactNumber: json['contactNumber'],
    password: json['password'],
    houseNumber: json['houseNumber'],
    streetName: json['streetName'],
    addressLine1: json['addressLine1'],
    addressLine2: json['addressLine2'],
    landmark: json['landmark'],
    cityUuid: json['cityUuid'],
    stateUuid: json['stateUuid'],
    countryUuid: json['countryUuid'],
    countryName: json['countryName'],
    countryCurrency: json['countryCurrency'],
    countryCode: json['countryCode'],
    stateName: json['stateName'],
    cityName: json['cityName'],
    postalCode: json['postalCode'],
    wallet: json['wallet'],
    active: json['active'],
  );

  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'name': name,
    'email': email,
    'contactNumber': contactNumber,
    'password': password,
    'houseNumber': houseNumber,
    'streetName': streetName,
    'addressLine1': addressLine1,
    'addressLine2': addressLine2,
    'landmark': landmark,
    'cityUuid': cityUuid,
    'stateUuid': stateUuid,
    'countryUuid': countryUuid,
    'countryName': countryName,
    'countryCurrency': countryCurrency,
    'countryCode': countryCode,
    'stateName': stateName,
    'cityName': cityName,
    'postalCode': postalCode,
    'wallet': wallet,
    'active': active,
  };
}
