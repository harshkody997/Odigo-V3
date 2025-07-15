// To parse this JSON data, do
//
//     final generalSupportListResponseModel = generalSupportListResponseModelFromJson(jsonString);

import 'dart:convert';

ContactUsListResponseModel contactUsListResponseModelFromJson(String str) => ContactUsListResponseModel.fromJson(json.decode(str));

String contactUsListResponseModelToJson(ContactUsListResponseModel data) => json.encode(data.toJson());

class ContactUsListResponseModel {
  int? pageNumber;
  List<ContactDetail>? data;
  bool? hasNextPage;
  int? totalPages;
  bool? hasPreviousPage;
  int? pageSize;
  String? message;
  int? totalCount;
  int? status;

  ContactUsListResponseModel({
    this.pageNumber,
    this.data,
    this.hasNextPage,
    this.totalPages,
    this.hasPreviousPage,
    this.pageSize,
    this.message,
    this.totalCount,
    this.status,
  });

  factory ContactUsListResponseModel.fromJson(Map<String, dynamic> json) => ContactUsListResponseModel(
    pageNumber: json['pageNumber'],
    data: json['data'] == null ? [] : List<ContactDetail>.from(json['data']!.map((x) => ContactDetail.fromJson(x))),
    hasNextPage: json['hasNextPage'],
    totalPages: json['totalPages'],
    hasPreviousPage: json['hasPreviousPage'],
    pageSize: json['pageSize'],
    message: json['message'],
    totalCount: json['totalCount'],
    status: json['status'],
  );

  Map<String, dynamic> toJson() => {
    'pageNumber': pageNumber,
    'data': data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    'hasNextPage': hasNextPage,
    'totalPages': totalPages,
    'hasPreviousPage': hasPreviousPage,
    'pageSize': pageSize,
    'message': message,
    'totalCount': totalCount,
    'status': status,
  };
}

class ContactDetail {
  String? uuid;
  String? name;
  dynamic email;
  String? contactNumber;
  String? description;
  dynamic userId;
  dynamic entityType;
  bool? active;
  int? createdAt;
  dynamic entityUuid;
  dynamic isUserArchived;

  ContactDetail({
    this.uuid,
    this.name,
    this.email,
    this.contactNumber,
    this.description,
    this.userId,
    this.entityType,
    this.active,
    this.createdAt,
    this.entityUuid,
    this.isUserArchived,
  });

  factory ContactDetail.fromJson(Map<String, dynamic> json) => ContactDetail(
    uuid: json['uuid'],
    name: json['name'],
    email: json['email'],
    contactNumber: json['contactNumber'],
    description: json['description'],
    userId: json['userId'],
    entityType: json['entityType'],
    active: json['active'],
    createdAt: json['createdAt'],
    entityUuid: json['entityUuid'],
    isUserArchived: json['isUserArchived'],
  );

  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'name': name,
    'email': email,
    'contactNumber': contactNumber,
    'description': description,
    'userId': userId,
    'entityType': entityType,
    'active': active,
    'createdAt': createdAt,
    'entityUuid': entityUuid,
    'isUserArchived': isUserArchived,
  };
}
