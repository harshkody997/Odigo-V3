// To parse this JSON data, do
//
//     final destinationTypeListResponseModel = destinationTypeListResponseModelFromJson(jsonString);

import 'dart:convert';

DestinationTypeListResponseModel destinationTypeListResponseModelFromJson(String str) => DestinationTypeListResponseModel.fromJson(json.decode(str));

String destinationTypeListResponseModelToJson(DestinationTypeListResponseModel data) => json.encode(data.toJson());

class DestinationTypeListResponseModel {
  int? pageNumber;
  List<DestinationType>? data;
  bool? hasNextPage;
  int? totalPages;
  bool? hasPreviousPage;
  int? pageSize;
  String? message;
  int? totalCount;
  int? status;

  DestinationTypeListResponseModel({this.pageNumber, this.data, this.hasNextPage, this.totalPages, this.hasPreviousPage, this.pageSize, this.message, this.totalCount, this.status});

  factory DestinationTypeListResponseModel.fromJson(Map<String, dynamic> json) => DestinationTypeListResponseModel(
    pageNumber: json['pageNumber'],
    data: json['data'] == null ? [] : List<DestinationType>.from(json['data']!.map((x) => DestinationType.fromJson(x))),
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

class DestinationType {
  String? uuid;
  bool? active;
  String? name;

  DestinationType({this.uuid, this.active, this.name});

  factory DestinationType.fromJson(Map<String, dynamic> json) => DestinationType(uuid: json['uuid'], active: json['active'], name: json['name']);

  Map<String, dynamic> toJson() => {'uuid': uuid, 'active': active, 'name': name};
}
