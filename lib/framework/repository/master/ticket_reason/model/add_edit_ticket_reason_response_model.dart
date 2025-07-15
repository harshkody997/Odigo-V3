// To parse this JSON data, do
//
//     final addEditTicketReasonResponseModel = addEditTicketReasonResponseModelFromJson(jsonString);

import 'dart:convert';

AddEditTicketReasonResponseModel addEditTicketReasonResponseModelFromJson(String str) => AddEditTicketReasonResponseModel.fromJson(json.decode(str));

String addEditTicketReasonResponseModelToJson(AddEditTicketReasonResponseModel data) => json.encode(data.toJson());

class AddEditTicketReasonResponseModel {
  String? message;
  AddEditTicketReasonModel? data;
  int? status;

  AddEditTicketReasonResponseModel({
    this.message,
    this.data,
    this.status,
  });

  factory AddEditTicketReasonResponseModel.fromJson(Map<String, dynamic> json) => AddEditTicketReasonResponseModel(
    message: json["message"],
    data: json["data"] == null ? null : AddEditTicketReasonModel.fromJson(json["data"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data?.toJson(),
    "status": status,
  };
}

class AddEditTicketReasonModel {
  String? uuid;
  String? platformType;
  bool? active;
  List<TicketReasonValue>? ticketReasonValues;

  AddEditTicketReasonModel({
    this.uuid,
    this.platformType,
    this.active,
    this.ticketReasonValues,
  });

  factory AddEditTicketReasonModel.fromJson(Map<String, dynamic> json) => AddEditTicketReasonModel(
    uuid: json["uuid"],
    platformType: json["platformType"],
    active: json["active"],
    ticketReasonValues: json["ticketReasonValues"] == null ? [] : List<TicketReasonValue>.from(json["ticketReasonValues"]!.map((x) => TicketReasonValue.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "platformType": platformType,
    "active": active,
    "ticketReasonValues": ticketReasonValues == null ? [] : List<dynamic>.from(ticketReasonValues!.map((x) => x.toJson())),
  };
}

class TicketReasonValue {
  String? languageUuid;
  String? languageName;
  String? uuid;
  String? reason;

  TicketReasonValue({
    this.languageUuid,
    this.languageName,
    this.uuid,
    this.reason,
  });

  factory TicketReasonValue.fromJson(Map<String, dynamic> json) => TicketReasonValue(
    languageUuid: json["languageUuid"],
    languageName: json["languageName"],
    uuid: json["uuid"],
    reason: json["reason"],
  );

  Map<String, dynamic> toJson() => {
    "languageUuid": languageUuid,
    "languageName": languageName,
    "uuid": uuid,
    "reason": reason,
  };
}
