// To parse this JSON data, do
//
//     final sequenceHistoryListRequestModel = sequenceHistoryListRequestModelFromJson(jsonString);

import 'dart:convert';

SequenceHistoryListRequestModel sequenceHistoryListRequestModelFromJson(String str) => SequenceHistoryListRequestModel.fromJson(json.decode(str));

String sequenceHistoryListRequestModelToJson(SequenceHistoryListRequestModel data) => json.encode(data.toJson());

class SequenceHistoryListRequestModel {
  String? destinationUuid;
  String? odigoClientUuid;
  String? purchaseUuid;
  String? adsUuid;
  String? defaultAdsUuid;
  DateTime? date;

  SequenceHistoryListRequestModel({
    this.destinationUuid,
    this.odigoClientUuid,
    this.purchaseUuid,
    this.adsUuid,
    this.defaultAdsUuid,
    this.date,
  });

  factory SequenceHistoryListRequestModel.fromJson(Map<String, dynamic> json) => SequenceHistoryListRequestModel(
    destinationUuid: json['destinationUuid'],
    odigoClientUuid: json['odigoClientUuid'],
    purchaseUuid: json['purchaseUuid'],
    adsUuid: json['adsUuid'],
    defaultAdsUuid: json['defaultAdsUuid'],
    date: json['date'] == null ? null : DateTime.parse(json['date']),
  );

  Map<String, dynamic> toJson() => {
    'destinationUuid': destinationUuid,
    'odigoClientUuid': odigoClientUuid,
    'purchaseUuid': purchaseUuid,
    'adsUuid': adsUuid,
    'defaultAdsUuid': defaultAdsUuid,
    'date': date?.toIso8601String(),
    // 'date': "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
  };
}
