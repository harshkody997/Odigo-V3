// To parse this JSON data, do
//
//     final addUpdateRoleRequestModel = addUpdateRoleRequestModelFromJson(jsonString);

import 'dart:convert';

AddUpdateRoleRequestModel addUpdateRoleRequestModelFromJson(String str) => AddUpdateRoleRequestModel.fromJson(json.decode(str));

String addUpdateRoleRequestModelToJson(AddUpdateRoleRequestModel data) => json.encode(data.toJson());

class AddUpdateRoleRequestModel {
  String? uuid;
  String? name;
  String? description;
  String? userType;
  List<ModuleAndPermissionDto>? moduleAndPermissionDtOs;

  AddUpdateRoleRequestModel({
    this.uuid,
    this.name,
    this.description,
    this.userType,
    this.moduleAndPermissionDtOs,
  });

  factory AddUpdateRoleRequestModel.fromJson(Map<String, dynamic> json) => AddUpdateRoleRequestModel(
    uuid: json["uuid"],
    name: json["name"],
    description: json["description"],
    userType: json["userType"],
    moduleAndPermissionDtOs: json["moduleAndPermissionDTOs"] == null ? [] : List<ModuleAndPermissionDto>.from(json["moduleAndPermissionDTOs"]!.map((x) => ModuleAndPermissionDto.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
    "description": description,
    "userType": userType,
    "moduleAndPermissionDTOs": moduleAndPermissionDtOs == null ? [] : List<dynamic>.from(moduleAndPermissionDtOs!.map((x) => x.toJson())),
  };
}

class ModuleAndPermissionDto {
  String? modulesUuid;
  bool? canView;
  bool? canEdit;
  bool? canAdd;
  bool? canDelete;

  ModuleAndPermissionDto({
    this.modulesUuid,
    this.canView,
    this.canEdit,
    this.canAdd,
    this.canDelete,
  });

  factory ModuleAndPermissionDto.fromJson(Map<String, dynamic> json) => ModuleAndPermissionDto(
    modulesUuid: json["modulesUuid"],
    canView: json["canView"],
    canEdit: json["canEdit"],
    canAdd: json["canAdd"],
    canDelete: json["canDelete"],
  );

  Map<String, dynamic> toJson() => {
    "modulesUuid": modulesUuid,
    "canView": canView,
    "canEdit": canEdit,
    "canAdd": canAdd,
    "canDelete": canDelete,
  };
}
