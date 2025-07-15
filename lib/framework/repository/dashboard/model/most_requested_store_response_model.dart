// To parse this JSON data, do
//
//     final mostRequestedStoreResponseModel = mostRequestedStoreResponseModelFromJson(jsonString);

import 'dart:convert';

MostRequestedStoreResponseModel mostRequestedStoreResponseModelFromJson(String str) => MostRequestedStoreResponseModel.fromJson(json.decode(str));

String mostRequestedStoreResponseModelToJson(MostRequestedStoreResponseModel data) => json.encode(data.toJson());

class MostRequestedStoreResponseModel {
  String? message;
  Data? data;
  int? status;

  MostRequestedStoreResponseModel({
    this.message,
    this.data,
    this.status,
  });

  factory MostRequestedStoreResponseModel.fromJson(Map<String, dynamic> json) => MostRequestedStoreResponseModel(
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
  List<MostRequestedStore>? mostRequestedStores;

  Data({
    this.mostRequestedStores,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    mostRequestedStores: json['mostRequestedStores'] == null ? [] : List<MostRequestedStore>.from(json['mostRequestedStores']!.map((x) => MostRequestedStore.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    'mostRequestedStores': mostRequestedStores == null ? [] : List<dynamic>.from(mostRequestedStores!.map((x) => x.toJson())),
  };
}

class MostRequestedStore {
  String? storeName;
  String? storeUuid;
  int? requestCount;

  MostRequestedStore({
    this.storeName,
    this.storeUuid,
    this.requestCount,
  });

  factory MostRequestedStore.fromJson(Map<String, dynamic> json) => MostRequestedStore(
    storeName: json['storeName'],
    storeUuid: json['storeUuid'],
    requestCount: json['requestCount'],
  );

  Map<String, dynamic> toJson() => {
    'storeName': storeName,
    'storeUuid': storeUuid,
    'requestCount': requestCount,
  };
}
