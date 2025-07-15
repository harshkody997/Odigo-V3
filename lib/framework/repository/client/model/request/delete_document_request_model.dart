// To parse this JSON data, do
//
//     final deleteDocumentRequestModel = deleteDocumentRequestModelFromJson(jsonString);

import 'dart:convert';

DeleteDocumentRequestModel deleteDocumentRequestModelFromJson(String str) => DeleteDocumentRequestModel.fromJson(json.decode(str));

String deleteDocumentRequestModelToJson(DeleteDocumentRequestModel data) => json.encode(data.toJson());

class DeleteDocumentRequestModel {
  List<String>? uuidList;

  DeleteDocumentRequestModel({
    this.uuidList,
  });

  factory DeleteDocumentRequestModel.fromJson(Map<String, dynamic> json) => DeleteDocumentRequestModel(
    uuidList: json['uuidList'] == null ? [] : List<String>.from(json['uuidList']!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    'uuidList': uuidList == null ? [] : List<dynamic>.from(uuidList!.map((x) => x)),
  };
}
