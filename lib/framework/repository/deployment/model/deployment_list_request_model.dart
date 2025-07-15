// To parse this JSON data, do
//
//     final deploymentListRequestModel = deploymentListRequestModelFromJson(jsonString);

import 'dart:convert';

DeploymentListRequestModel deploymentListRequestModelFromJson(String str) => DeploymentListRequestModel.fromJson(json.decode(str));

String deploymentListRequestModelToJson(DeploymentListRequestModel data) => json.encode(data.toJson());

class DeploymentListRequestModel {
  String? technology;
  String? buildType;
  String? buildStatus;
  String? searchKeyword;
  String? destiationUuid;

  DeploymentListRequestModel({
    this.technology,
    this.buildType,
    this.buildStatus,
    this.searchKeyword,
    this.destiationUuid,
  });

  factory DeploymentListRequestModel.fromJson(Map<String, dynamic> json) => DeploymentListRequestModel(
    technology: json['technology'],
    buildType: json['buildType'],
    buildStatus: json['buildStatus'],
    searchKeyword: json['searchKeyword'],
    destiationUuid: json['destiationUuid'],
  );

  Map<String, dynamic> toJson() => {
    'technology': technology,
    'buildType': buildType,
    'buildStatus': buildStatus,
    'searchKeyword': searchKeyword,
    'destiationUuid': destiationUuid,
  };
}
