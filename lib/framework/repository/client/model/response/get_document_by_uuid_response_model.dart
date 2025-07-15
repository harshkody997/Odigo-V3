// To parse this JSON data, do
//
//     final getDocumentByUuidModel = getDocumentByUuidModelFromJson(jsonString);

import 'dart:convert';

GetDocumentByUuidModel getDocumentByUuidModelFromJson(String str) => GetDocumentByUuidModel.fromJson(json.decode(str));

String getDocumentByUuidModelToJson(GetDocumentByUuidModel data) => json.encode(data.toJson());

class GetDocumentByUuidModel {
  String? message;
  Data? data;
  int? status;

  GetDocumentByUuidModel({
    this.message,
    this.data,
    this.status,
  });

  factory GetDocumentByUuidModel.fromJson(Map<String, dynamic> json) => GetDocumentByUuidModel(
    message: json['message'],
    data: json['data'] == null ? null : Data.fromJson(json['data']),
    status: json['status'],
  );

  Map<String, dynamic> toJson() => {
    'message': message,
    'data': data?.toJson(),
    'status': status,
  };
}

class Data {
  String? clientUuid;
  List<DocumentData>? documents;

  Data({
    this.clientUuid,
    this.documents,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    clientUuid: json['clientUuid'],
    documents: json['documents'] == null ? [] : List<DocumentData>.from(json['documents']!.map((x) => DocumentData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    'clientUuid': clientUuid,
    'documents': documents == null ? [] : List<dynamic>.from(documents!.map((x) => x.toJson())),
  };
}

class DocumentData {
  String? uuid;
  String? name;
  String? originalDocument;
  String? url;

  DocumentData({
    this.uuid,
    this.name,
    this.originalDocument,
    this.url,
  });

  factory DocumentData.fromJson(Map<String, dynamic> json) => DocumentData(
    uuid: json['uuid'],
    name: json['name'],
    originalDocument: json['originalDocument'],
    url: json['url'],
  );

  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'name': name,
    'originalDocument': originalDocument,
    'url': url,
  };
}
