// To parse this JSON data, do
//
//     final adsSequencePreviewListResponseModel = adsSequencePreviewListResponseModelFromJson(jsonString);

import 'dart:convert';

AdsSequencePreviewListResponseModel adsSequencePreviewListResponseModelFromJson(String str) => AdsSequencePreviewListResponseModel.fromJson(json.decode(str));

String adsSequencePreviewListResponseModelToJson(AdsSequencePreviewListResponseModel data) => json.encode(data.toJson());

class AdsSequencePreviewListResponseModel {
  String? message;
  List<SequencePreviewDto>? data;
  int? status;

  AdsSequencePreviewListResponseModel({
    this.message,
    this.data,
    this.status,
  });

  factory AdsSequencePreviewListResponseModel.fromJson(Map<String, dynamic> json) => AdsSequencePreviewListResponseModel(
    message: json["message"],
    data: json["data"] == null ? [] : List<SequencePreviewDto>.from(json["data"]!.map((x) => SequencePreviewDto.fromJson(x))),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "status": status,
  };
}

class SequencePreviewDto {
  String? uuid;
  String? odigoClientUuid;
  String? odigoClientName;
  String? destinationUuid;
  String? destinationName;
  String? purchaseUuid;
  String? slotType;
  int? slotNumber;
  int? updatedSlotNumber;
  String? previewDate;

  SequencePreviewDto({
    this.uuid,
    this.odigoClientUuid,
    this.odigoClientName,
    this.destinationUuid,
    this.destinationName,
    this.purchaseUuid,
    this.slotType,
    this.slotNumber,
    this.previewDate,
    this.updatedSlotNumber,
  });

  factory SequencePreviewDto.fromJson(Map<String, dynamic> json) =>
      SequencePreviewDto(
        uuid: json["uuid"],
        odigoClientUuid: json["odigoClientUuid"],
        odigoClientName: json["odigoClientName"],
        destinationUuid:json["destinationUuid"],
        destinationName: json["destinationName"],
        purchaseUuid: json["purchaseUuid"],
        slotType: json["slotType"],
        slotNumber: json["slotNumber"],
        updatedSlotNumber: json["updatedSlotNumber"],
        previewDate: json["previewDate"],
      );

  Map<String, dynamic> toJson() =>
      {
        "uuid": uuid,
        "odigoClientUuid": odigoClientUuid,
        "odigoClientName": odigoClientName,
        "destinationUuid": destinationUuid,
        "destinationName": destinationName,
        "purchaseUuid": purchaseUuid,
        "slotType":slotType,
        "slotNumber": slotNumber,
        "updatedSlotNumber": updatedSlotNumber,
        "previewDate":previewDate,
      };
}
