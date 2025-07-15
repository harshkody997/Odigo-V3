// To parse this JSON data, do
//
//     final deploymentListResponseModel = deploymentListResponseModelFromJson(jsonString);

import 'dart:convert';

DeploymentListResponseModel deploymentListResponseModelFromJson(String str) => DeploymentListResponseModel.fromJson(json.decode(str));

String deploymentListResponseModelToJson(DeploymentListResponseModel data) => json.encode(data.toJson());

class DeploymentListResponseModel {
  int? pageNumber;
  List<DeploymentList>? data;
  bool? hasNextPage;
  int? totalPages;
  bool? hasPreviousPage;
  String? message;
  int? totalCount;
  int? status;

  DeploymentListResponseModel({
    this.pageNumber,
    this.data,
    this.hasNextPage,
    this.totalPages,
    this.hasPreviousPage,
    this.message,
    this.totalCount,
    this.status,
  });

  factory DeploymentListResponseModel.fromJson(Map<String, dynamic> json) => DeploymentListResponseModel(
    pageNumber: json['pageNumber'],
    data: json['data'] == null ? [] : List<DeploymentList>.from(json['data']!.map((x) => DeploymentList.fromJson(x))),
    hasNextPage: json['hasNextPage'],
    totalPages: json['totalPages'],
    hasPreviousPage: json['hasPreviousPage'],
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
    'message': message,
    'totalCount': totalCount,
    'status': status,
  };
}

class DeploymentList {
  String? uuid;
  double? version;
  String? buildType;
  String? technology;
  String? destinationUuid;
  String? destinationName;
  String? buildStatus;
  dynamic buildFile;
  String? buildFileUrl;
  String? serviceName;
  int? updatedAt;
  List<DeploymentResponseDto>? deploymentResponseDtOs;

  DeploymentList({
    this.uuid,
    this.version,
    this.buildType,
    this.technology,
    this.destinationUuid,
    this.destinationName,
    this.buildStatus,
    this.buildFile,
    this.buildFileUrl,
    this.serviceName,
    this.updatedAt,
    this.deploymentResponseDtOs,
  });

  factory DeploymentList.fromJson(Map<String, dynamic> json) => DeploymentList(
    uuid: json['uuid'],
    version: json['version'],
    buildType: json['buildType'],
    technology: json['technology'],
    destinationUuid: json['destinationUuid'],
    destinationName: json['destinationName'],
    buildStatus: json['buildStatus'],
    buildFile: json['buildFile'],
    buildFileUrl: json['buildFileUrl'],
    serviceName: json['serviceName'],
    updatedAt: json['updatedAt'],
    deploymentResponseDtOs: json['deploymentResponseDTOs'] == null ? [] : List<DeploymentResponseDto>.from(json['deploymentResponseDTOs']!.map((x) => DeploymentResponseDto.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'version': version,
    'buildType': buildType,
    'technology': technology,
    'destinationUuid': destinationUuid,
    'destinationName': destinationName,
    'buildStatus': buildStatus,
    'buildFile': buildFile,
    'buildFileUrl': buildFileUrl,
    'serviceName': serviceName,
    'updatedAt': updatedAt,
    'deploymentResponseDTOs': deploymentResponseDtOs == null ? [] : List<dynamic>.from(deploymentResponseDtOs!.map((x) => x.toJson())),
  };
}

class DeploymentResponseDto {
  String? uuid;
  bool? isDeployed;
  String? buildUrl;
  String? robotUuid;
  String? robotHostName;
  int? latestVersion;
  String? technology;
  String? buildType;
  String? buildStatus;

  DeploymentResponseDto({
    this.uuid,
    this.isDeployed,
    this.buildUrl,
    this.robotUuid,
    this.robotHostName,
    this.latestVersion,
    this.technology,
    this.buildType,
    this.buildStatus,
  });

  factory DeploymentResponseDto.fromJson(Map<String, dynamic> json) => DeploymentResponseDto(
    uuid: json['uuid'],
    isDeployed: json['isDeployed'],
    buildUrl: json['buildUrl'],
    robotUuid: json['robotUuid'],
    robotHostName: json['robotHostName'],
    latestVersion: json['latestVersion'],
    technology: json['technology'],
    buildType: json['buildType'],
    buildStatus: json['buildStatus'],
  );

  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'isDeployed': isDeployed,
    'buildUrl': buildUrl,
    'robotUuid': robotUuid,
    'robotHostName': robotHostName,
    'latestVersion': latestVersion,
    'technology': technology,
    'buildType': buildType,
    'buildStatus': buildStatus,
  };
}
