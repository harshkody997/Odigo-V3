// To parse this JSON data, do
//
//     final sidebarListResponseModel = sidebarListResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:odigov3/framework/repository/drawer/model/drawer_model.dart';

SidebarListResponseModel sidebarListResponseModelFromJson(String str) => SidebarListResponseModel.fromJson(json.decode(str));

String sidebarListResponseModelToJson(SidebarListResponseModel data) => json.encode(data.toJson());

class SidebarListResponseModel {
  String? message;
  List<SidebarModel>? data;
  int? status;

  SidebarListResponseModel({
    this.message,
    this.data,
    this.status,
  });

  factory SidebarListResponseModel.fromJson(Map<String, dynamic> json) => SidebarListResponseModel(
    message: json['message'],
    data: json['data'] == null ? [] : List<SidebarModel>.from(json['data']!.map((x) => SidebarModel.fromJson(x))),
    status: json['status'],
  );

  Map<String, dynamic> toJson() => {
    'message': message,
    'data': data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    'status': status,
  };
}

class SidebarModel {
  String? modulesUuid;
  String? modulesName;
  String? modulesNameEnglish;
  bool? canView;
  bool? canEdit;
  bool? canAdd;
  bool? canDelete;
  bool? canViewSidebar;
  List<SubSidebarData>? children;
  DrawerModel? drawerMenuModel;

  SidebarModel({
    this.modulesUuid,
    this.modulesName,
    this.modulesNameEnglish,
    this.canView,
    this.canEdit,
    this.canAdd,
    this.canDelete,
    this.canViewSidebar,
    this.children,
    this.drawerMenuModel
  });

  factory SidebarModel.fromJson(Map<String, dynamic> json) => SidebarModel(
    modulesUuid: json['modulesUuid'],
    modulesName: json['modulesName'],
    modulesNameEnglish: json['modulesNameEnglish'],
    canView: json['canView'],
    canEdit: json['canEdit'],
    canAdd: json['canAdd'],
    canDelete: json['canDelete'],
    canViewSidebar: json['canViewSidebar'],
    drawerMenuModel: json['drawerMenuModel'],
    children: json['children'] == null ? [] : List<SubSidebarData>.from(json['children']!.map((x) => SubSidebarData.fromJson(x))),
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
    'drawerMenuModel': drawerMenuModel,
    'children': children == null ? [] : List<dynamic>.from(children!.map((x) => x.toJson())),
  };
}


class SubSidebarData {
  String? modulesUuid;
  String? modulesName;
  String? modulesNameEnglish;
  bool? canView;
  bool? canEdit;
  bool? canAdd;
  bool? canDelete;
  bool? canViewSidebar;
  DrawerModel? drawerMenuModel;

  SubSidebarData({
    this.modulesUuid,
    this.modulesName,
    this.modulesNameEnglish,
    this.canView,
    this.canEdit,
    this.canAdd,
    this.canDelete,
    this.canViewSidebar,
    this.drawerMenuModel,
  });

  factory SubSidebarData.fromJson(Map<String, dynamic> json) => SubSidebarData(
    modulesUuid: json['modulesUuid'],
    modulesName: json['modulesName'],
    modulesNameEnglish: json['modulesNameEnglish'],
    canView: json['canView'],
    canEdit: json['canEdit'],
    canAdd: json['canAdd'],
    canDelete: json['canDelete'],
    canViewSidebar: json['canViewSidebar'],
    drawerMenuModel: json['drawerMenuModel'],
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
    'homeMenuOperator': drawerMenuModel,
  };
}
