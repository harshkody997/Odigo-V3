// To parse this JSON data, do
//
//     final sequenceHistoryListResponseModel = sequenceHistoryListResponseModelFromJson(jsonString);

import 'dart:convert';

SequenceHistoryListResponseModel sequenceHistoryListResponseModelFromJson(String str) => SequenceHistoryListResponseModel.fromJson(json.decode(str));

String sequenceHistoryListResponseModelToJson(SequenceHistoryListResponseModel data) => json.encode(data.toJson());

class SequenceHistoryListResponseModel {
  int? pageNumber;
  List<AdsSequenceHistoryData>? data;
  bool? hasNextPage;
  int? totalPages;
  bool? hasPreviousPage;
  int? pageSize;
  String? message;
  int? totalCount;
  int? status;

  SequenceHistoryListResponseModel({
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

  factory SequenceHistoryListResponseModel.fromJson(Map<String, dynamic> json) => SequenceHistoryListResponseModel(
    pageNumber: json['pageNumber'],
    data: json['data'] == null ? [] : List<AdsSequenceHistoryData>.from(json['data']!.map((x) => AdsSequenceHistoryData.fromJson(x))),
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

class AdsSequenceHistoryData {
  String? uuid;
  dynamic odigoClientUuid;
  dynamic odigoClientName;
  String? destinationUuid;
  String? destinationName;
  dynamic purchaseUuid;
  dynamic adsUuid;
  dynamic adsName;
  String? defualtAdsUuid;
  String? defualtAdsName;
  int? setNumber;
  int? slotNumber;
  DateTime? sequenceDate;

  AdsSequenceHistoryData({
    this.uuid,
    this.odigoClientUuid,
    this.odigoClientName,
    this.destinationUuid,
    this.destinationName,
    this.purchaseUuid,
    this.adsUuid,
    this.adsName,
    this.defualtAdsUuid,
    this.defualtAdsName,
    this.setNumber,
    this.slotNumber,
    this.sequenceDate,
  });

  factory AdsSequenceHistoryData.fromJson(Map<String, dynamic> json) => AdsSequenceHistoryData(
    uuid: json['uuid'],
    odigoClientUuid: json['odigoClientUuid'],
    odigoClientName: json['odigoClientName'],
    destinationUuid: json['destinationUuid'],
    destinationName: json['destinationName'],
    purchaseUuid: json['purchaseUuid'],
    adsUuid: json['adsUuid'],
    adsName: json['adsName'],
    defualtAdsUuid: json['defualtAdsUuid'],
    defualtAdsName: json['defualtAdsName'],
    setNumber: json['setNumber'],
    slotNumber: json['slotNumber'],
    sequenceDate: json['sequenceDate'] == null ? null : DateTime.parse(json['sequenceDate']),
  );

  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'odigoClientUuid': odigoClientUuid,
    'odigoClientName': odigoClientName,
    'destinationUuid': destinationUuid,
    'destinationName': destinationName,
    'purchaseUuid': purchaseUuid,
    'adsUuid': adsUuid,
    'adsName': adsName,
    'defualtAdsUuid': defualtAdsUuid,
    'defualtAdsName': defualtAdsName,
    'setNumber': setNumber,
    'slotNumber': slotNumber,
    'sequenceDate': "${sequenceDate!.year.toString().padLeft(4, '0')}-${sequenceDate!.month.toString().padLeft(2, '0')}-${sequenceDate!.day.toString().padLeft(2, '0')}",
  };
}
