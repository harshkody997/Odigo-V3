// To parse this JSON data, do
//
//     final destinationDetailsResponseModel = destinationDetailsResponseModelFromJson(jsonString);

import 'dart:convert';

DestinationDetailsResponseModel destinationDetailsResponseModelFromJson(String str) => DestinationDetailsResponseModel.fromJson(json.decode(str));

String destinationDetailsResponseModelToJson(DestinationDetailsResponseModel data) => json.encode(data.toJson());

class DestinationDetailsResponseModel {
  String? message;
  DestinationData? data;
  int? status;

  DestinationDetailsResponseModel({
    this.message,
    this.data,
    this.status,
  });

  factory DestinationDetailsResponseModel.fromJson(Map<String, dynamic> json) => DestinationDetailsResponseModel(
    message: json['message'],
    data: json['data'] == null ? null : DestinationData.fromJson(json['data']),
    status: json['status'],
  );

  Map<String, dynamic> toJson() => {
    'message': message,
    'data': data?.toJson(),
    'status': status,
  };
}

class DestinationData {
  String? uuid;
  String? name;
  String? destinationTypeUuid;
  String? destinationTypeName;
  List<DestinationTimeValue>? destinationTimeValues;
  int? totalFloor;
  String? houseNumber;
  String? streetName;
  String? addressLine1;
  String? addressLine2;
  String? landmark;
  String? cityUuid;
  String? stateUuid;
  String? countryUuid;
  String? countryName;
  String? stateName;
  String? cityName;
  String? postalCode;
  dynamic imageUrl;
  String? email;
  String? contactNumber;
  bool? active;
  String? ownerName;
  String? passcode;
  bool? isEmergency;
  String? timeZone;
  String? currency;
  int? fillerPrice;
  int? premiumPrice;

  DestinationData({
    this.uuid,
    this.name,
    this.destinationTypeUuid,
    this.destinationTypeName,
    this.destinationTimeValues,
    this.totalFloor,
    this.houseNumber,
    this.streetName,
    this.addressLine1,
    this.addressLine2,
    this.landmark,
    this.cityUuid,
    this.stateUuid,
    this.countryUuid,
    this.countryName,
    this.stateName,
    this.cityName,
    this.postalCode,
    this.imageUrl,
    this.email,
    this.contactNumber,
    this.active,
    this.ownerName,
    this.passcode,
    this.isEmergency,
    this.timeZone,
    this.currency,
    this.fillerPrice,
    this.premiumPrice,
  });

  factory DestinationData.fromJson(Map<String, dynamic> json) => DestinationData(
    uuid: json['uuid'],
    name: json['name'],
    destinationTypeUuid: json['destinationTypeUuid'],
    destinationTypeName: json['destinationTypeName'],
    destinationTimeValues: json['destinationTimeValues'] == null ? [] : List<DestinationTimeValue>.from(json['destinationTimeValues']!.map((x) => DestinationTimeValue.fromJson(x))),
    totalFloor: json['totalFloor'],
    houseNumber: json['houseNumber'],
    streetName: json['streetName'],
    addressLine1: json['addressLine1'],
    addressLine2: json['addressLine2'],
    landmark: json['landmark'],
    cityUuid: json['cityUuid'],
    stateUuid: json['stateUuid'],
    countryUuid: json['countryUuid'],
    countryName: json['countryName'],
    stateName: json['stateName'],
    cityName: json['cityName'],
    postalCode: json['postalCode'],
    imageUrl: json['imageUrl'],
    email: json['email'],
    contactNumber: json['contactNumber'],
    active: json['active'],
    ownerName: json['ownerName'],
    passcode: json['passcode'],
    isEmergency: json['isEmergency'],
    timeZone: json['timeZone'],
    currency: json['currency'],
    fillerPrice: json['fillerPrice'],
    premiumPrice: json['premiumPrice'],
  );

  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'name': name,
    'destinationTypeUuid': destinationTypeUuid,
    'destinationTypeName': destinationTypeName,
    'destinationTimeValues': destinationTimeValues == null ? [] : List<dynamic>.from(destinationTimeValues!.map((x) => x.toJson())),
    'totalFloor': totalFloor,
    'houseNumber': houseNumber,
    'streetName': streetName,
    'addressLine1': addressLine1,
    'addressLine2': addressLine2,
    'landmark': landmark,
    'cityUuid': cityUuid,
    'stateUuid': stateUuid,
    'countryUuid': countryUuid,
    'countryName': countryName,
    'stateName': stateName,
    'cityName': cityName,
    'postalCode': postalCode,
    'imageUrl': imageUrl,
    'email': email,
    'contactNumber': contactNumber,
    'active': active,
    'ownerName': ownerName,
    'passcode': passcode,
    'isEmergency': isEmergency,
    'timeZone': timeZone,
    'currency': currency,
    'fillerPrice': fillerPrice,
    'premiumPrice': premiumPrice,
  };
}

class DestinationTimeValue {
  String? uuid;
  String? dayOfWeek;
  String? startHour;
  String? endHour;

  DestinationTimeValue({
    this.uuid,
    this.dayOfWeek,
    this.startHour,
    this.endHour,
  });

  factory DestinationTimeValue.fromJson(Map<String, dynamic> json) => DestinationTimeValue(
    uuid: json['uuid'],
    dayOfWeek: json['dayOfWeek'],
    startHour: json['startHour'],
    endHour: json['endHour'],
  );

  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'dayOfWeek': dayOfWeek?.toUpperCase(),
    'startHour': startHour,
    'endHour': endHour,
  };
}
