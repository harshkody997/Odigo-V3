// To parse this JSON data, do
//
//     final destinationPriceHistoryResponseModel = destinationPriceHistoryResponseModelFromJson(jsonString);

import 'dart:convert';

DestinationPriceHistoryResponseModel destinationPriceHistoryResponseModelFromJson(String str) => DestinationPriceHistoryResponseModel.fromJson(json.decode(str));

String destinationPriceHistoryResponseModelToJson(DestinationPriceHistoryResponseModel data) => json.encode(data.toJson());

class DestinationPriceHistoryResponseModel {
  int? pageNumber;
  List<PriceHistoryData>? data;
  bool? hasNextPage;
  int? totalPages;
  bool? hasPreviousPage;
  int? pageSize;
  String? message;
  int? totalCount;
  int? status;

  DestinationPriceHistoryResponseModel({
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

  factory DestinationPriceHistoryResponseModel.fromJson(Map<String, dynamic> json) => DestinationPriceHistoryResponseModel(
    pageNumber: json['pageNumber'],
    data: json['data'] == null ? [] : List<PriceHistoryData>.from(json['data']!.map((x) => PriceHistoryData.fromJson(x))),
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

class PriceHistoryData {
  String? uuid;
  int? fillerPrice;
  int? premiumPrice;
  String? destinationUuid;
  String? destinationName;
  int? createdAt;

  PriceHistoryData({
    this.uuid,
    this.fillerPrice,
    this.premiumPrice,
    this.destinationUuid,
    this.destinationName,
    this.createdAt,
  });

  factory PriceHistoryData.fromJson(Map<String, dynamic> json) => PriceHistoryData(
    uuid: json['uuid'],
    fillerPrice: json['fillerPrice'],
    premiumPrice: json['premiumPrice'],
    destinationUuid: json['destinationUuid'],
    destinationName: json['destinationName'],
    createdAt: json['createdAt'],
  );

  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'fillerPrice': fillerPrice,
    'premiumPrice': premiumPrice,
    'destinationUuid': destinationUuid,
    'destinationName': destinationName,
    'createdAt': createdAt,
  };
}
