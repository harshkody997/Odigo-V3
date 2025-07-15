// To parse this JSON data, do
//
//     final manageDestinationRequestModel = manageDestinationRequestModelFromJson(jsonString);

import 'dart:convert';

import 'package:odigov3/framework/repository/destination/model/destination_details_response_model.dart';

ManageDestinationRequestModel manageDestinationRequestModelFromJson(String str) => ManageDestinationRequestModel.fromJson(json.decode(str));

String manageDestinationRequestModelToJson(ManageDestinationRequestModel data) => json.encode(data.toJson());

class ManageDestinationRequestModel {
  List<Map<String, dynamic>>? destinationValues;
  String? ownerName;
  List<DestinationTimeValue>? destinationTimeValues;
  String? destinationUuid;
  String? destinationTypeUuid;
  int? totalFloor;
  String? houseNumber;
  String? streetName;
  String? addressLine1;
  String? addressLine2;
  String? landmark;
  String? cityUuid;
  String? stateUuid;
  String? countryUuid;
  String? postalCode;
  String? email;
  String? contactNumber;
  String? timeZone;
  String? password;
  String? passcode;
  String? fillerPrice;
  String? premiumPrice;

  ManageDestinationRequestModel({
    this.destinationValues,
    this.ownerName,
    this.destinationTimeValues,
    this.destinationUuid,
    this.destinationTypeUuid,
    this.totalFloor,
    this.houseNumber,
    this.streetName,
    this.addressLine1,
    this.addressLine2,
    this.landmark,
    this.cityUuid,
    this.stateUuid,
    this.countryUuid,
    this.postalCode,
    this.email,
    this.contactNumber,
    this.timeZone,
    this.password,
    this.passcode,
    this.fillerPrice,
    this.premiumPrice,
  });

  factory ManageDestinationRequestModel.fromJson(Map<String, dynamic> json) => ManageDestinationRequestModel(
    destinationUuid: json['uuid'],
    destinationValues: json['destinationValues'],
    ownerName: json['ownerName'],
    destinationTimeValues: json['destinationTimeValues'] == null ? [] : List<DestinationTimeValue>.from(json['destinationTimeValues']!.map((x) => DestinationTimeValue.fromJson(x))),
    destinationTypeUuid: json['destinationTypeUuid'],
    totalFloor: json['totalFloor'],
    houseNumber: json['houseNumber'],
    streetName: json['streetName'],
    addressLine1: json['addressLine1'],
    addressLine2: json['addressLine2'],
    landmark: json['landmark'],
    cityUuid: json['cityUuid'],
    stateUuid: json['stateUuid'],
    countryUuid: json['countryUuid'],
    postalCode: json['postalCode'],
    email: json['email'],
    contactNumber: json['contactNumber'],
    timeZone: json['timeZone'],
    password: json['password'],
    passcode: json['passcode'],
    fillerPrice: json['fillerPrice'],
    premiumPrice: json['premiumPrice'],
  );

  Map<String, dynamic> toJson() => {
    'uuid': destinationUuid,
    'destinationValues': destinationValues,
    'ownerName': ownerName,
    'destinationTimeValues': destinationTimeValues == null ? [] : List<dynamic>.from(destinationTimeValues!.map((x) => x.toJson())),
    'destinationTypeUuid': destinationTypeUuid,
    'totalFloor': totalFloor,
    'houseNumber': houseNumber,
    'streetName': streetName,
    'addressLine1': addressLine1,
    'addressLine2': addressLine2,
    'landmark': landmark,
    'cityUuid': cityUuid,
    'stateUuid': stateUuid,
    'countryUuid': countryUuid,
    'postalCode': postalCode,
    'email': email,
    'contactNumber': contactNumber,
    'timeZone': timeZone,
    'password': password,
    'passcode': passcode,
    'fillerPrice': double.parse(fillerPrice ?? '0'),
    'premiumPrice': double.parse(premiumPrice ?? '0'),
  };

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

class DestinationValue {
  String? languageUuid;
  String? name;

  DestinationValue({this.languageUuid, this.name});

  factory DestinationValue.fromJson(Map<String, dynamic> json) => DestinationValue(languageUuid: json['languageUuid'], name: json['name']);

  Map<String, dynamic> toJson() => {'languageUuid': languageUuid, 'name': name};
}
