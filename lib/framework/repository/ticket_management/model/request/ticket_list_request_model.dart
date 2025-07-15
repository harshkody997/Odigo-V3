// To parse this JSON data, do
//
//     final ticketListRequestModel = ticketListRequestModelFromJson(jsonString);

import 'dart:convert';

TicketListRequestModel ticketListRequestModelFromJson(String str) => TicketListRequestModel.fromJson(json.decode(str));

String ticketListRequestModelToJson(TicketListRequestModel data) => json.encode(data.toJson());

class TicketListRequestModel {
  int? fromDate;
  int? toDate;
  String? status;
  String? searchKeyword;

  TicketListRequestModel({
    this.fromDate,
    this.toDate,
    this.status,
    this.searchKeyword,
  });

  factory TicketListRequestModel.fromJson(Map<String, dynamic> json) => TicketListRequestModel(
    fromDate: json['fromDate'],
    toDate: json['toDate'],
    status: json['status'],
    searchKeyword: json['searchKeyword'],
  );

  Map<String, dynamic> toJson() => {
    'fromDate': fromDate,
    'toDate': toDate,
    'status': status,
    'searchKeyword': searchKeyword,
  };
}
