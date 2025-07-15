// To parse this JSON data, do
//
//     final ticketStatusUpdateRequestModel = ticketStatusUpdateRequestModelFromJson(jsonString);

import 'dart:convert';

TicketStatusUpdateRequestModel ticketStatusUpdateRequestModelFromJson(String str) => TicketStatusUpdateRequestModel.fromJson(json.decode(str));

String ticketStatusUpdateRequestModelToJson(TicketStatusUpdateRequestModel data) => json.encode(data.toJson());

class TicketStatusUpdateRequestModel {
  String? ticketStatus;
  String? comment;

  TicketStatusUpdateRequestModel({
    this.ticketStatus,
    this.comment,
  });

  factory TicketStatusUpdateRequestModel.fromJson(Map<String, dynamic> json) => TicketStatusUpdateRequestModel(
    ticketStatus: json['ticketStatus'],
    comment: json['comment'],
  );

  Map<String, dynamic> toJson() => {
    'ticketStatus': ticketStatus,
    'comment': comment,
  };
}
