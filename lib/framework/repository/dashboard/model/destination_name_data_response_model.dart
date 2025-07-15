// To parse this JSON data, do
//
//     final destinationNameDataResponseModel = destinationNameDataResponseModelFromJson(jsonString);

import 'dart:convert';

DestinationNameDataResponseModel destinationNameDataResponseModelFromJson(String str) => DestinationNameDataResponseModel.fromJson(json.decode(str));

String destinationNameDataResponseModelToJson(DestinationNameDataResponseModel data) => json.encode(data.toJson());

class DestinationNameDataResponseModel {
  int? pageNumber;
  List<DestinationNameData>? data;
  bool? hasNextPage;
  int? totalPages;
  bool? hasPreviousPage;
  int? pageSize;
  String? message;
  int? totalCount;
  int? status;

  DestinationNameDataResponseModel({
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

  factory DestinationNameDataResponseModel.fromJson(Map<String, dynamic> json) => DestinationNameDataResponseModel(
    pageNumber: json["pageNumber"],
    data: json["data"] == null ? [] : List<DestinationNameData>.from(json["data"]!.map((x) => DestinationNameData.fromJson(x))),
    hasNextPage: json["hasNextPage"],
    totalPages: json["totalPages"],
    hasPreviousPage: json["hasPreviousPage"],
    pageSize: json["pageSize"],
    message: json["message"],
    totalCount: json["totalCount"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "pageNumber": pageNumber,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "hasNextPage": hasNextPage,
    "totalPages": totalPages,
    "hasPreviousPage": hasPreviousPage,
    "pageSize": pageSize,
    "message": message,
    "totalCount": totalCount,
    "status": status,
  };
}

class DestinationNameData {
  String? uuid;
  String? name;

  DestinationNameData({
    this.uuid,
    this.name,
  });

  factory DestinationNameData.fromJson(Map<String, dynamic> json) => DestinationNameData(
    uuid: json["uuid"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
  };
}
