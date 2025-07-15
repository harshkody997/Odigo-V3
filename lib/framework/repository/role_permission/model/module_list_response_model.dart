// To parse this JSON data, do
//
//     final moduleListResponseModel = moduleListResponseModelFromJson(jsonString);

// To parse this JSON data, do
//
//     final moduleListResponseModel = moduleListResponseModelFromJson(jsonString);

import 'dart:convert';

ModuleListResponseModel moduleListResponseModelFromJson(String str) => ModuleListResponseModel.fromJson(json.decode(str));

String moduleListResponseModelToJson(ModuleListResponseModel data) => json.encode(data.toJson());

class ModuleListResponseModel {
  int? pageNumber;
  List<ModuleModel>? data;
  bool? hasNextPage;
  int? totalPages;
  bool? hasPreviousPage;
  String? message;
  int? totalCount;
  int? status;

  ModuleListResponseModel({
    this.pageNumber,
    this.data,
    this.hasNextPage,
    this.totalPages,
    this.hasPreviousPage,
    this.message,
    this.totalCount,
    this.status,
  });

  factory ModuleListResponseModel.fromJson(Map<String, dynamic> json) => ModuleListResponseModel(
    pageNumber: json["pageNumber"],
    data: json["data"] == null ? [] : List<ModuleModel>.from(json["data"]!.map((x) => ModuleModel.fromJson(x))),
    hasNextPage: json["hasNextPage"],
    totalPages: json["totalPages"],
    hasPreviousPage: json["hasPreviousPage"],
    message: json["message"],
    totalCount: json["totalCount"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "pageNumber": pageNumber,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "hasNextPage": hasNextPage,
    "totalPages": totalPages,
    "hasPreviousPage": hasPreviousPage,
    "message": message,
    "totalCount": totalCount,
    "status": status,
  };
}

class ModuleModel {
  String? uuid;
  String? name;
  String? nameEnglish;
  bool? active;
  List<RequiredModuleList>? requiredModuleList;
  List<RequiredModuleList>? dependentModulesList;
  bool? canView;
  bool? canEdit;
  bool? canAdd;
  bool? canDelete;
  bool? isSelectedAll;

  ModuleModel({
    this.uuid,
    this.name,
    this.nameEnglish,
    this.active,
    this.requiredModuleList,
    this.dependentModulesList,
    this.canView,
    this.canEdit,
    this.canAdd,
    this.canDelete,
    this.isSelectedAll,
  });

  factory ModuleModel.fromJson(Map<String, dynamic> json) => ModuleModel(
    uuid: json["uuid"],
    name: json["name"],
    nameEnglish: json["nameEnglish"],
    active: json["active"],
    requiredModuleList: json["requiredModuleList"] == null ? [] : List<RequiredModuleList>.from(json["requiredModuleList"]!.map((x) => RequiredModuleList.fromJson(x))),
    dependentModulesList: json["dependentModulesList"] == null ? [] : List<RequiredModuleList>.from(json["dependentModulesList"]!.map((x) => RequiredModuleList.fromJson(x))),
    canView: json["canView"],
    canEdit: json["canEdit"],
    canAdd: json["canAdd"],
    canDelete: json["canDelete"],
    isSelectedAll: json["isSelectedAll"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
    "nameEnglish": nameEnglish,
    "active": active,
    "requiredModuleList": requiredModuleList == null ? [] : List<dynamic>.from(requiredModuleList!.map((x) => x.toJson())),
    "dependentModulesList": dependentModulesList == null ? [] : List<dynamic>.from(dependentModulesList!.map((x) => x.toJson())),
    "canView": canView,
    "canEdit": canEdit,
    "canAdd": canAdd,
    "canDelete": canDelete,
    "isSelectedAll": isSelectedAll,
  };
}

class RequiredModuleList {
  String? uuid;
  String? name;

  RequiredModuleList({
    this.uuid,
    this.name,
  });

  factory RequiredModuleList.fromJson(Map<String, dynamic> json) => RequiredModuleList(
    uuid: json["uuid"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
  };
}
