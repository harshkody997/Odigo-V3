// To parse this JSON data, do
//
//     final updateSequencePreviewRequestModel = updateSequencePreviewRequestModelFromJson(jsonString);

import 'dart:convert';

UpdateSequencePreviewRequestModel updateSequencePreviewRequestModelFromJson(String str) => UpdateSequencePreviewRequestModel.fromJson(json.decode(str));

String updateSequencePreviewRequestModelToJson(UpdateSequencePreviewRequestModel data) => json.encode(data.toJson());

class UpdateSequencePreviewRequestModel {
  String? destinationUuid;
  List<AdsSequencePreviewUpdateDto>? adsSequencePreviewUpdateDtOs;

  UpdateSequencePreviewRequestModel({
    this.destinationUuid,
    this.adsSequencePreviewUpdateDtOs,
  });

  factory UpdateSequencePreviewRequestModel.fromJson(Map<String, dynamic> json) => UpdateSequencePreviewRequestModel(
    destinationUuid: json["destinationUuid"],
    adsSequencePreviewUpdateDtOs: json["adsSequencePreviewUpdateDTOs"] == null ? [] : List<AdsSequencePreviewUpdateDto>.from(json["adsSequencePreviewUpdateDTOs"]!.map((x) => AdsSequencePreviewUpdateDto.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "destinationUuid": destinationUuid,
    "adsSequencePreviewUpdateDTOs": adsSequencePreviewUpdateDtOs == null ? [] : List<dynamic>.from(adsSequencePreviewUpdateDtOs!.map((x) => x.toJson())),
  };
}

class AdsSequencePreviewUpdateDto {
  String? uuid;
  int? slotNumber;

  AdsSequencePreviewUpdateDto({
    this.uuid,
    this.slotNumber,
  });

  factory AdsSequencePreviewUpdateDto.fromJson(Map<String, dynamic> json) => AdsSequencePreviewUpdateDto(
    uuid: json["uuid"],
    slotNumber: json["slotNumber"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "slotNumber": slotNumber,
  };
}
