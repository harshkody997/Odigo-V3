// To parse this JSON data, do
//
//     final faqDetailsResponseModel = faqDetailsResponseModelFromJson(jsonString);

import 'dart:convert';

FaqDetailsResponseModel faqDetailsResponseModelFromJson(String str) => FaqDetailsResponseModel.fromJson(json.decode(str));

String faqDetailsResponseModelToJson(FaqDetailsResponseModel data) => json.encode(data.toJson());

class FaqDetailsResponseModel {
  String? message;
  FaqDetailsData? data;
  int? status;

  FaqDetailsResponseModel({
    this.message,
    this.data,
    this.status,
  });

  factory FaqDetailsResponseModel.fromJson(Map<String, dynamic> json) => FaqDetailsResponseModel(
    message: json["message"],
    data: json["data"] == null ? null : FaqDetailsData.fromJson(json["data"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data?.toJson(),
    "status": status,
  };
}

class FaqDetailsData {
  String? uuid;
  String? platformType;
  bool? active;
  List<FaqValue>? faqValues;

  FaqDetailsData({
    this.uuid,
    this.platformType,
    this.active,
    this.faqValues,
  });

  factory FaqDetailsData.fromJson(Map<String, dynamic> json) => FaqDetailsData(
    uuid: json["uuid"],
    platformType: json["platformType"],
    active: json["active"],
    faqValues: json["faqValues"] == null ? [] : List<FaqValue>.from(json["faqValues"]!.map((x) => FaqValue.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "platformType": platformType,
    "active": active,
    "faqValues": faqValues == null ? [] : List<dynamic>.from(faqValues!.map((x) => x.toJson())),
  };
}

class FaqValue {
  String? languageUuid;
  String? languageName;
  String? uuid;
  String? question;
  String? answer;

  FaqValue({
    this.languageUuid,
    this.languageName,
    this.uuid,
    this.question,
    this.answer,
  });

  factory FaqValue.fromJson(Map<String, dynamic> json) => FaqValue(
    languageUuid: json["languageUuid"],
    languageName: json["languageName"],
    uuid: json["uuid"],
    question: json["question"],
    answer: json["answer"],
  );

  Map<String, dynamic> toJson() => {
    "languageUuid": languageUuid,
    "languageName": languageName,
    "uuid": uuid,
    "question": question,
    "answer": answer,
  };
}
