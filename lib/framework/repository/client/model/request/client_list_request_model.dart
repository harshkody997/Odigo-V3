// To parse this JSON data, do
//
//     final clientListRequestModel = clientListRequestModelFromJson(jsonString);

import 'dart:convert';

ClientListRequestModel clientListRequestModelFromJson(String str) => ClientListRequestModel.fromJson(json.decode(str));

String clientListRequestModelToJson(ClientListRequestModel data) => json.encode(data.toJson());

class ClientListRequestModel {
  String? cityUuid;
  String? stateUuid;
  String? countryUuid;
  bool? activeRecords;
  String? searchKeyword;

  ClientListRequestModel({
    this.cityUuid,
    this.stateUuid,
    this.countryUuid,
    this.activeRecords,
    this.searchKeyword,
  });

  factory ClientListRequestModel.fromJson(Map<String, dynamic> json) => ClientListRequestModel(
    cityUuid: json['cityUuid'],
    stateUuid: json['stateUuid'],
    countryUuid: json['countryUuid'],
    activeRecords: json['activeRecords'],
    searchKeyword: json['searchKeyword'],
  );

  Map<String, dynamic> toJson() => {
    'cityUuid': cityUuid,
    'stateUuid': stateUuid,
    'countryUuid': countryUuid,
    'activeRecords': activeRecords,
    'searchKeyword': searchKeyword,
  };
}
