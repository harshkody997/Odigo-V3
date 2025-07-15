// To parse this JSON data, do
//
//     final createPurchaseRequestModel = createPurchaseRequestModelFromJson(jsonString);

import 'dart:convert';

CreatePurchaseRequestModel createPurchaseRequestModelFromJson(String str) => CreatePurchaseRequestModel.fromJson(json.decode(str));

String createPurchaseRequestModelToJson(CreatePurchaseRequestModel data) => json.encode(data.toJson());

class CreatePurchaseRequestModel {
  String? odigoClientUuid;
  String? destinationUuid;
  String? type;
  List<PurchaseWeek>? purchaseWeeks;
  List<String>? adsUuids;
  String? paymentType;
  List<Payment>? payments;
  int? purchasePrice;
  bool? isConsiderWalletBalance;
  int? firstPurchaseInstallment;
  String? firstPurchaseRemarks;
  String? remarks;

  CreatePurchaseRequestModel({
    this.odigoClientUuid,
    this.destinationUuid,
    this.type,
    this.purchaseWeeks,
    this.adsUuids,
    this.paymentType,
    this.payments,
    this.purchasePrice,
    this.isConsiderWalletBalance,
    this.firstPurchaseInstallment,
    this.firstPurchaseRemarks,
    this.remarks,
  });

  factory CreatePurchaseRequestModel.fromJson(Map<String, dynamic> json) => CreatePurchaseRequestModel(
    odigoClientUuid: json['odigoClientUuid'],
    destinationUuid: json['destinationUuid'],
    type: json['type'],
    purchaseWeeks: json['purchaseWeeks'] == null ? [] : List<PurchaseWeek>.from(json['purchaseWeeks']!.map((x) => PurchaseWeek.fromJson(x))),
    adsUuids: json['adsUuids'] == null ? [] : List<String>.from(json['adsUuids']!.map((x) => x)),
    paymentType: json['paymentType'],
    payments: json['payments'] == null ? [] : List<Payment>.from(json['payments']!.map((x) => Payment.fromJson(x))),
    purchasePrice: json['purchasePrice'],
    isConsiderWalletBalance: json['isConsiderWalletBalance'],
    firstPurchaseInstallment: json['firstPurchaseInstallment'],
    firstPurchaseRemarks: json['firstPurchaseRemarks'],
    remarks: json['remarks'],
  );

  Map<String, dynamic> toJson() => {
    'odigoClientUuid': odigoClientUuid,
    'destinationUuid': destinationUuid,
    'type': type,
    'purchaseWeeks': purchaseWeeks == null ? [] : List<dynamic>.from(purchaseWeeks!.map((x) => x.toJson())),
    'adsUuids': adsUuids == null ? [] : List<dynamic>.from(adsUuids!.map((x) => x)),
    'paymentType': paymentType,
    'payments': payments == null ? [] : List<dynamic>.from(payments!.map((x) => x.toJson())),
    'purchasePrice': purchasePrice,
    'isConsiderWalletBalance': isConsiderWalletBalance,
    'firstPurchaseInstallment': firstPurchaseInstallment,
    'firstPurchaseRemarks': firstPurchaseRemarks,
    'remarks': remarks,
  };
}

class Payment {
  int? price;
  DateTime? installmentDate;

  Payment({
    this.price,
    this.installmentDate,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
    price: json['price'],
    installmentDate: json['installmentDate'] == null ? null : DateTime.parse(json['installmentDate']),
  );

  Map<String, dynamic> toJson() => {
    'price': price,
    'installmentDate': "${installmentDate!.year.toString().padLeft(4, '0')}-${installmentDate!.month.toString().padLeft(2, '0')}-${installmentDate!.day.toString().padLeft(2, '0')}",
  };
}

class PurchaseWeek {
  String? year;
  int? week;
  DateTime? startDate;
  DateTime? endDate;

  PurchaseWeek({
    this.year,
    this.week,
    this.startDate,
    this.endDate,
  });

  factory PurchaseWeek.fromJson(Map<String, dynamic> json) => PurchaseWeek(
    year: json['year'],
    week: json['week'],
    startDate: json['startDate'] == null ? null : DateTime.parse(json['startDate']),
    endDate: json['endDate'] == null ? null : DateTime.parse(json['endDate']),
  );

  Map<String, dynamic> toJson() => {
    'year': year,
    'week': week,
    'startDate': "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}",
    'endDate': "${endDate!.year.toString().padLeft(4, '0')}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}",
  };
}
