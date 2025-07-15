// To parse this JSON data, do
//
//     final storeListVendorVerificationRequestModel = storeListVendorVerificationRequestModelFromJson(jsonString);

import 'dart:convert';

StoreListVendorVerificationRequestModel storeListVendorVerificationRequestModelFromJson(String str) => StoreListVendorVerificationRequestModel.fromJson(json.decode(str));

String storeListVendorVerificationRequestModelToJson(StoreListVendorVerificationRequestModel data) => json.encode(data.toJson());

class StoreListVendorVerificationRequestModel {
  String? vendorOdigoStoreUuid;
  String? status;
  String? rejectReason;

  StoreListVendorVerificationRequestModel({
    this.vendorOdigoStoreUuid,
    this.status,
    this.rejectReason,
  });

  factory StoreListVendorVerificationRequestModel.fromJson(Map<String, dynamic> json) => StoreListVendorVerificationRequestModel(
    vendorOdigoStoreUuid: json['vendorOdigoStoreUuid'],
    status: json['status'],
    rejectReason: json['rejectReason'],
  );

  Map<String, dynamic> toJson() => {
    'vendorOdigoStoreUuid': vendorOdigoStoreUuid,
    'status': status,
    'rejectReason': rejectReason,
  };
}
