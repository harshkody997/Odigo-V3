// To parse this JSON data, do
//
//     final ticketListResponseModel = ticketListResponseModelFromJson(jsonString);

import 'dart:convert';

TicketListResponseModel ticketListResponseModelFromJson(String str) => TicketListResponseModel.fromJson(json.decode(str));

String ticketListResponseModelToJson(TicketListResponseModel data) => json.encode(data.toJson());

class TicketListResponseModel {
  int? pageNumber;
  List<TicketDetails>? data;
  bool? hasNextPage;
  int? totalPages;
  bool? hasPreviousPage;
  int? pageSize;
  String? message;
  int? totalCount;
  int? status;

  TicketListResponseModel({
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

  factory TicketListResponseModel.fromJson(Map<String, dynamic> json) => TicketListResponseModel(
    pageNumber: json['pageNumber'],
    data: json['data'] == null ? [] : List<TicketDetails>.from(json['data']!.map((x) => TicketDetails.fromJson(x))),
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

class TicketDetails {
  String? uuid;
  String? ticketReason;
  String? ticketReasonUuid;
  int? entityId;
  String? entityUuid;
  bool? isUserArchived;
  String? userType;
  String? email;
  String? name;
  String? contactNumber;
  String? ticketStatus;
  List<String>? nextStatus;
  String? description;
  bool? active;
  int? createdAt;
  dynamic acknowledgeComment;
  dynamic acknowledgerName;
  bool? isAcknowledUserArchived;
  dynamic acknowledgerUuid;
  dynamic acknowledgedDate;
  dynamic resolverName;
  dynamic resolverUuid;
  bool? isResolverUserArchived;
  dynamic resolvedDate;
  dynamic resolveComment;

  TicketDetails({
    this.uuid,
    this.ticketReason,
    this.ticketReasonUuid,
    this.entityId,
    this.entityUuid,
    this.isUserArchived,
    this.userType,
    this.email,
    this.name,
    this.contactNumber,
    this.ticketStatus,
    this.nextStatus,
    this.description,
    this.active,
    this.createdAt,
    this.acknowledgeComment,
    this.acknowledgerName,
    this.isAcknowledUserArchived,
    this.acknowledgerUuid,
    this.acknowledgedDate,
    this.resolverName,
    this.resolverUuid,
    this.isResolverUserArchived,
    this.resolvedDate,
    this.resolveComment,
  });

  factory TicketDetails.fromJson(Map<String, dynamic> json) => TicketDetails(
    uuid: json['uuid'],
    ticketReason: json['ticketReason'],
    ticketReasonUuid: json['ticketReasonUuid'],
    entityId: json['entityId'],
    entityUuid: json['entityUuid'],
    isUserArchived: json['isUserArchived'],
    userType: json['userType'],
    email: json['email'],
    name: json['name'],
    contactNumber: json['contactNumber'],
    ticketStatus: json['ticketStatus'],
    nextStatus: json['nextStatus'] == null ? [] : List<String>.from(json['nextStatus']!.map((x) => x)),
    description: json['description'],
    active: json['active'],
    createdAt: json['createdAt'],
    acknowledgeComment: json['acknowledgeComment'],
    acknowledgerName: json['acknowledgerName'],
    isAcknowledUserArchived: json['isAcknowledUserArchived'],
    acknowledgerUuid: json['acknowledgerUuid'],
    acknowledgedDate: json['acknowledgedDate'],
    resolverName: json['resolverName'],
    resolverUuid: json['resolverUuid'],
    isResolverUserArchived: json['isResolverUserArchived'],
    resolvedDate: json['resolvedDate'],
    resolveComment: json['resolveComment'],
  );

  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'ticketReason': ticketReason,
    'ticketReasonUuid': ticketReasonUuid,
    'entityId': entityId,
    'entityUuid': entityUuid,
    'isUserArchived': isUserArchived,
    'userType': userType,
    'email': email,
    'name': name,
    'contactNumber': contactNumber,
    'ticketStatus': ticketStatus,
    'nextStatus': nextStatus == null ? [] : List<dynamic>.from(nextStatus!.map((x) => x)),
    'description': description,
    'active': active,
    'createdAt': createdAt,
    'acknowledgeComment': acknowledgeComment,
    'acknowledgerName': acknowledgerName,
    'isAcknowledUserArchived': isAcknowledUserArchived,
    'acknowledgerUuid': acknowledgerUuid,
    'acknowledgedDate': acknowledgedDate,
    'resolverName': resolverName,
    'resolverUuid': resolverUuid,
    'isResolverUserArchived': isResolverUserArchived,
    'resolvedDate': resolvedDate,
    'resolveComment': resolveComment,
  };
}
