// To parse this JSON data, do
//
//     final uptimeResponseModel = uptimeResponseModelFromJson(jsonString);

import 'dart:convert';

UptimeResponseModel uptimeResponseModelFromJson(String str) => UptimeResponseModel.fromJson(json.decode(str));

String uptimeResponseModelToJson(UptimeResponseModel data) => json.encode(data.toJson());

class UptimeResponseModel {
  String? message;
  UptimeResponseData? data;
  int? status;

  UptimeResponseModel({
    this.message,
    this.data,
    this.status,
  });

  factory UptimeResponseModel.fromJson(Map<String, dynamic> json) => UptimeResponseModel(
    message: json['message'],
    data: json['data'] == null ? null : UptimeResponseData.fromJson(json['data']),
    status: json['status'],
  );

  Map<String, dynamic> toJson() => {
    'message': message,
    'data': data?.toJson(),
    'status': status,
  };
}

class UptimeResponseData {
  Charging? destinationUpTime;
  Charging? emergency;
  Charging? charging;

  UptimeResponseData({
    this.destinationUpTime,
    this.emergency,
    this.charging,
  });

  factory UptimeResponseData.fromJson(Map<String, dynamic> json) => UptimeResponseData(
    destinationUpTime: json['destinationUpTime'] == null ? null : Charging.fromJson(json['destinationUpTime']),
    emergency: json['emergency'] == null ? null : Charging.fromJson(json['emergency']),
    charging: json['charging'] == null ? null : Charging.fromJson(json['charging']),
  );

  Map<String, dynamic> toJson() => {
    'destinationUpTime': destinationUpTime?.toJson(),
    'emergency': emergency?.toJson(),
    'charging': charging?.toJson(),
  };
}

class Charging {
  double? totalTime;
  double? percentage;

  Charging({
    this.totalTime,
    this.percentage,
  });

  factory Charging.fromJson(Map<String, dynamic> json) => Charging(
    totalTime: json['totalTime'],
    percentage: json['percentage'],
  );

  Map<String, dynamic> toJson() => {
    'totalTime': totalTime,
    'percentage': percentage,
  };
}
