// To parse this JSON data, do
//
//     final createTicketRequestModel = createTicketRequestModelFromJson(jsonString);

import 'dart:convert';

CreateTicketRequestModel createTicketRequestModelFromJson(String str) => CreateTicketRequestModel.fromJson(json.decode(str));

String createTicketRequestModelToJson(CreateTicketRequestModel data) => json.encode(data.toJson());

class CreateTicketRequestModel {
  String? ticketReasonUuid;
  String? description;

  CreateTicketRequestModel({
    this.ticketReasonUuid,
    this.description,
  });

  factory CreateTicketRequestModel.fromJson(Map<String, dynamic> json) => CreateTicketRequestModel(
    ticketReasonUuid: json['ticketReasonUuid'],
    description: json['description'],
  );

  Map<String, dynamic> toJson() => {
    'ticketReasonUuid': ticketReasonUuid,
    'description': description,
  };
}
