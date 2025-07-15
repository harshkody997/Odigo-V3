// To parse this JSON data, do
//
//     final acceptRejectAdRequestModel = acceptRejectAdRequestModelFromJson(jsonString);

import 'dart:convert';

AcceptRejectAdRequestModel acceptRejectAdRequestModelFromJson(String str) => AcceptRejectAdRequestModel.fromJson(json.decode(str));

String acceptRejectAdRequestModelToJson(AcceptRejectAdRequestModel data) => json.encode(data.toJson());

class AcceptRejectAdRequestModel {
  String? adsUuid;
  String? verificationResultStatus;
  String? rejectReason;

  AcceptRejectAdRequestModel({
    this.adsUuid,
    this.verificationResultStatus,
    this.rejectReason,
  });

  factory AcceptRejectAdRequestModel.fromJson(Map<String, dynamic> json) => AcceptRejectAdRequestModel(
    adsUuid: json["adsUuid"],
    verificationResultStatus: json["verificationResultStatus"],
    rejectReason: json["rejectReason"],
  );

  Map<String, dynamic> toJson() => {
    "adsUuid": adsUuid,
    "verificationResultStatus": verificationResultStatus,
    "rejectReason": rejectReason,
  };
}
