// To parse this JSON data, do
//
//     final destinationDetailsMultiLanguageResponseModel = destinationDetailsMultiLanguageResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:odigov3/framework/repository/destination/model/destination_details_response_model.dart';
import 'package:odigov3/framework/repository/destination/model/request/manage_destination_request_model.dart';

DestinationDetailsMultiLanguageResponseModel destinationDetailsMultiLanguageResponseModelFromJson(String str) => DestinationDetailsMultiLanguageResponseModel.fromJson(json.decode(str));

String destinationDetailsMultiLanguageResponseModelToJson(DestinationDetailsMultiLanguageResponseModel data) => json.encode(data.toJson());

class DestinationDetailsMultiLanguageResponseModel {
  String? message;
  DestinationDetailsMultiLanguage? data;
  int? status;

  DestinationDetailsMultiLanguageResponseModel({this.message, this.data, this.status});

  factory DestinationDetailsMultiLanguageResponseModel.fromJson(Map<String, dynamic> json) =>
      DestinationDetailsMultiLanguageResponseModel(message: json['message'], data: json['data'] == null ? null : DestinationDetailsMultiLanguage.fromJson(json['data']), status: json['status']);

  Map<String, dynamic> toJson() => {'message': message, 'data': data?.toJson(), 'status': status};
}

class DestinationDetailsMultiLanguage {
  String? uuid;
  List<DestinationValue>? destinationValues;
  String? destinationTypeUuid;
  List<DestinationTimeValue>? destinationTimeValues;
  String? timeZone;
  int? totalFloor;
  String? houseNumber;
  String? streetName;
  String? addressLine1;
  String? addressLine2;
  String? landmark;
  String? countryUuid;
  String? cityUuid;
  String? stateUuid;
  String? postalCode;
  dynamic imageUrl;
  String? email;
  String? contactNumber;
  dynamic password;
  bool? active;
  String? ownerName;
  String? passcode;
  int? fillerPrice;
  int? premiumPrice;
  String? destinationTypeName;
  String? countryName;
  String? stateName;
  String? cityName;
  bool? isEmergency;
  String? currency;

  DestinationDetailsMultiLanguage({
    this.uuid,
    this.destinationValues,
    this.destinationTypeUuid,
    this.destinationTimeValues,
    this.timeZone,
    this.totalFloor,
    this.houseNumber,
    this.streetName,
    this.addressLine1,
    this.addressLine2,
    this.landmark,
    this.countryUuid,
    this.cityUuid,
    this.stateUuid,
    this.postalCode,
    this.imageUrl,
    this.email,
    this.contactNumber,
    this.password,
    this.active,
    this.ownerName,
    this.passcode,
    this.fillerPrice,
    this.premiumPrice,
    this.destinationTypeName,
    this.countryName,
    this.stateName,
    this.cityName,
    this.isEmergency,
    this.currency,
  });

  factory DestinationDetailsMultiLanguage.fromJson(Map<String, dynamic> json) => DestinationDetailsMultiLanguage(
    uuid: json['uuid'],
    destinationValues: json['destinationValues'] == null ? [] : List<DestinationValue>.from(json['destinationValues']!.map((x) => DestinationValue.fromJson(x))),
    destinationTypeUuid: json['destinationTypeUuid'],
    destinationTimeValues: json['destinationTimeValues'] == null ? [] : List<DestinationTimeValue>.from(json['destinationTimeValues']!.map((x) => DestinationTimeValue.fromJson(x))),
    timeZone: json['timeZone'],
    totalFloor: json['totalFloor'],
    houseNumber: json['houseNumber'],
    streetName: json['streetName'],
    addressLine1: json['addressLine1'],
    addressLine2: json['addressLine2'],
    landmark: json['landmark'],
    countryUuid: json['countryUuid'],
    cityUuid: json['cityUuid'],
    stateUuid: json['stateUuid'],
    postalCode: json['postalCode'],
    imageUrl: json['imageUrl'],
    email: json['email'],
    contactNumber: json['contactNumber'],
    password: json['password'],
    active: json['active'],
    ownerName: json['ownerName'],
    passcode: json['passcode'],
    fillerPrice: json['fillerPrice'],
    premiumPrice: json['premiumPrice'],
    destinationTypeName: json['destinationTypeName'],
    countryName: json['countryName'],
    stateName: json['stateName'],
    cityName: json['cityName'],
    isEmergency: json['isEmergency'],
    currency: json['currency'],
  );

  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'destinationValues': destinationValues == null ? [] : List<dynamic>.from(destinationValues!.map((x) => x.toJson())),
    'destinationTypeUuid': destinationTypeUuid,
    'destinationTimeValues': destinationTimeValues == null ? [] : List<dynamic>.from(destinationTimeValues!.map((x) => x.toJson())),
    'timeZone': timeZone,
    'totalFloor': totalFloor,
    'houseNumber': houseNumber,
    'streetName': streetName,
    'addressLine1': addressLine1,
    'addressLine2': addressLine2,
    'landmark': landmark,
    'countryUuid': countryUuid,
    'cityUuid': cityUuid,
    'stateUuid': stateUuid,
    'postalCode': postalCode,
    'imageUrl': imageUrl,
    'email': email,
    'contactNumber': contactNumber,
    'password': password,
    'active': active,
    'ownerName': ownerName,
    'passcode': passcode,
    'fillerPrice': fillerPrice,
    'premiumPrice': premiumPrice,
    'destinationTypeName': destinationTypeName,
    'countryName': countryName,
    'stateName': stateName,
    'cityName': cityName,
    'isEmergency': isEmergency,
    'currency': currency,
  };
}
