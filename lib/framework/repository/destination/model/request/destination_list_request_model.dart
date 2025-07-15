// To parse this JSON data, do
//
//     final destinationListRequestModel = destinationListRequestModelFromJson(jsonString);

import 'dart:convert';

DestinationListRequestModel destinationListRequestModelFromJson(String str) => DestinationListRequestModel.fromJson(json.decode(str));

String destinationListRequestModelToJson(DestinationListRequestModel data) => json.encode(data.toJson());

class DestinationListRequestModel {
  String? searchKeyword;
  String? destinationTypeUuid;
  String? cityUuid;
  String? stateUuid;
  String? countryUuid;
  bool? activeRecords;
  String? storeUuid;

  DestinationListRequestModel({this.searchKeyword, this.destinationTypeUuid, this.cityUuid, this.stateUuid, this.countryUuid, this.activeRecords, this.storeUuid});

  factory DestinationListRequestModel.fromJson(Map<String, dynamic> json) => DestinationListRequestModel(
    searchKeyword: json['searchKeyword'],
    destinationTypeUuid: json['destinationTypeUuid'],
    cityUuid: json['cityUuid'],
    stateUuid: json['stateUuid'],
    countryUuid: json['countryUuid'],
    activeRecords: json['activeRecords'],
    storeUuid: json['storeUuid'],
  );

  String toJson() => jsonEncode({
    'searchKeyword': searchKeyword,
    'destinationTypeUuid': destinationTypeUuid,
    'cityUuid': cityUuid,
    'stateUuid': stateUuid,
    'countryUuid': countryUuid,
    'activeRecords': activeRecords,
    'storeUuid': storeUuid,
  });
}
