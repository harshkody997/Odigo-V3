// To parse this JSON data, do
//
//     final addEditFaqRequestModel = addEditFaqRequestModelFromJson(jsonString);

import 'dart:convert';

AddEditFaqRequestModel addEditFaqRequestModelFromJson(String str) => AddEditFaqRequestModel.fromJson(json.decode(str));

String addEditFaqRequestModelToJson(AddEditFaqRequestModel data) => json.encode(data.toJson());

class AddEditFaqRequestModel {
  String? uuid;
  String? platformType;
  List<FaqValueForAdd>? faqValues;

  AddEditFaqRequestModel({
    this.uuid,
    this.platformType,
    this.faqValues,
  });

  factory AddEditFaqRequestModel.fromJson(Map<String, dynamic> json) => AddEditFaqRequestModel(
    uuid: json["uuid"],
    platformType: json["platformType"],
    faqValues: json["faqValues"] == null ? [] : List<FaqValueForAdd>.from(json["faqValues"]!.map((x) => FaqValueForAdd.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "platformType": platformType,
    "faqValues": faqValues == null ? [] : List<dynamic>.from(faqValues!.map((x) => x.toJson())),
  };
}

class FaqValueForAdd {
  String? languageUuid;
  String? question;
  String? answer;

  FaqValueForAdd({
    this.languageUuid,
    this.question,
    this.answer,
  });

  factory FaqValueForAdd.fromJson(Map<String, dynamic> json) => FaqValueForAdd(
    languageUuid: json["languageUuid"],
    question: json["question"],
    answer: json["answer"],
  );

  Map<String, dynamic> toJson() => {
    "languageUuid": languageUuid,
    "question": question,
    "answer": answer,
  };
}
