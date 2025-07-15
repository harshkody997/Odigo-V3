// To parse this JSON data, do
//
//     final rolePermissionDetailsResponseModel = rolePermissionDetailsResponseModelFromJson(jsonString);

import 'dart:convert';

RolePermissionDetailsResponseModel rolePermissionDetailsResponseModelFromJson(String str) => RolePermissionDetailsResponseModel.fromJson(json.decode(str));

String rolePermissionDetailsResponseModelToJson(RolePermissionDetailsResponseModel data) => json.encode(data.toJson());

class RolePermissionDetailsResponseModel {
  String? message;
  RolePermissionModel? data;
  int? status;

  RolePermissionDetailsResponseModel({
    this.message,
    this.data,
    this.status,
  });

  factory RolePermissionDetailsResponseModel.fromJson(Map<String, dynamic> json) => RolePermissionDetailsResponseModel(
    message: json['message'],
    data: json['data'] == null ? null : RolePermissionModel.fromJson(json['data']),
    status: json['status'],
  );

  Map<String, dynamic> toJson() => {
    'message': message,
    'data': data?.toJson(),
    'status': status,
  };
}

class RolePermissionModel {
  String? uuid;
  String? name;
  String? description;
  bool? active;
  bool? isDefault;
  List<ModuleAndPermissionResponseDto>? moduleAndPermissionResponseDtOs;
  int? createdAt;
  int? updatedAt;

  RolePermissionModel({
    this.uuid,
    this.name,
    this.description,
    this.active,
    this.isDefault,
    this.moduleAndPermissionResponseDtOs,
    this.createdAt,
    this.updatedAt,
  });

  factory RolePermissionModel.fromJson(Map<String, dynamic> json) => RolePermissionModel(
    uuid: json['uuid'],
    name: json['name'],
    description: json['description'],
    active: json['active'],
    isDefault: json['isDefault'],
    moduleAndPermissionResponseDtOs: json['moduleAndPermissionResponseDTOs'] == null ? [] : List<ModuleAndPermissionResponseDto>.from(json['moduleAndPermissionResponseDTOs']!.map((x) => ModuleAndPermissionResponseDto.fromJson(x))),
    createdAt: json['createdAt'],
    updatedAt: json['updatedAt'],
  );

  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'name': name,
    'description': description,
    'active': active,
    'isDefault': isDefault,
    'moduleAndPermissionResponseDTOs': moduleAndPermissionResponseDtOs == null ? [] : List<dynamic>.from(moduleAndPermissionResponseDtOs!.map((x) => x.toJson())),
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };
}

class ModuleAndPermissionResponseDto {
  String? modulesUuid;
  String? modulesName;
  dynamic modulesNameEnglish;
  bool? canView;
  bool? canEdit;
  bool? canAdd;
  bool? canDelete;
  bool? canViewSidebar;

  ModuleAndPermissionResponseDto({
    this.modulesUuid,
    this.modulesName,
    this.modulesNameEnglish,
    this.canView,
    this.canEdit,
    this.canAdd,
    this.canDelete,
    this.canViewSidebar,
  });

  factory ModuleAndPermissionResponseDto.fromJson(Map<String, dynamic> json) => ModuleAndPermissionResponseDto(
    modulesUuid: json['modulesUuid'],
    modulesName: json['modulesName'],
    modulesNameEnglish: json['modulesNameEnglish'],
    canView: json['canView'],
    canEdit: json['canEdit'],
    canAdd: json['canAdd'],
    canDelete: json['canDelete'],
    canViewSidebar: json['canViewSidebar'],
  );

  Map<String, dynamic> toJson() => {
    'modulesUuid': modulesUuid,
    'modulesName': modulesName,
    'modulesNameEnglish': modulesNameEnglish,
    'canView': canView,
    'canEdit': canEdit,
    'canAdd': canAdd,
    'canDelete': canDelete,
    'canViewSidebar': canViewSidebar,
  };
}
