// To parse this JSON data, do
//
//     final destinationListResponseModel = destinationListResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:odigov3/framework/repository/destination/model/destination_details_response_model.dart';

DestinationListResponseModel destinationListResponseModelFromJson(String str) => DestinationListResponseModel.fromJson(json.decode(str));

String destinationListResponseModelToJson(DestinationListResponseModel data) => json.encode(data.toJson());

class DestinationListResponseModel {
  int pageNumber;
  List<DestinationData> data;
  bool hasNextPage;
  int totalPages;
  bool hasPreviousPage;
  int pageSize;
  String message;
  int totalCount;
  int status;

  DestinationListResponseModel({
    required this.pageNumber,
    required this.data,
    required this.hasNextPage,
    required this.totalPages,
    required this.hasPreviousPage,
    required this.pageSize,
    required this.message,
    required this.totalCount,
    required this.status,
  });

  factory DestinationListResponseModel.fromJson(Map<String, dynamic> json) => DestinationListResponseModel(
    pageNumber: json['pageNumber'],
    data: List<DestinationData>.from(json['data'].map((x) => DestinationData.fromJson(x))),
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
    'data': List<dynamic>.from(data.map((x) => x.toJson())),
    'hasNextPage': hasNextPage,
    'totalPages': totalPages,
    'hasPreviousPage': hasPreviousPage,
    'pageSize': pageSize,
    'message': message,
    'totalCount': totalCount,
    'status': status,
  };
}
