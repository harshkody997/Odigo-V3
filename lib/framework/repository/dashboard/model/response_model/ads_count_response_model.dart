// To parse this JSON data, do
//
//     final dashboardAdsCountResponseModel = dashboardAdsCountResponseModelFromJson(jsonString);

import 'dart:convert';

DashboardAdsCountResponseModel dashboardAdsCountResponseModelFromJson(String str) => DashboardAdsCountResponseModel.fromJson(json.decode(str));

String dashboardAdsCountResponseModelToJson(DashboardAdsCountResponseModel data) => json.encode(data.toJson());

class DashboardAdsCountResponseModel {
  String? message;
  DashboardAdsCountData? data;
  int? status;

  DashboardAdsCountResponseModel({
    this.message,
    this.data,
    this.status,
  });

  factory DashboardAdsCountResponseModel.fromJson(Map<String, dynamic> json) => DashboardAdsCountResponseModel(
        message: json['message'],
        data: json['data'] == null ? null : DashboardAdsCountData.fromJson(json['data']),
        status: json['status'],
      );

  Map<String, dynamic> toJson() => {
        'message': message,
        'data': data?.toJson(),
        'status': status,
      };
}

class DashboardAdsCountData {
  TotalAdsCountMonthYearWise? totalAdsCountMonthYearWise;
  AverageAdsCountYearWise? averageAdsCountYearWise;
  MonthWiseMostDisplayedAds? monthWiseMostDisplayedAds;

  DashboardAdsCountData({
    this.totalAdsCountMonthYearWise,
    this.averageAdsCountYearWise,
    this.monthWiseMostDisplayedAds,
  });

  factory DashboardAdsCountData.fromJson(Map<String, dynamic> json) => DashboardAdsCountData(
        totalAdsCountMonthYearWise: json['totalAdsCountMonthYearWise'] == null ? null : TotalAdsCountMonthYearWise.fromJson(json['totalAdsCountMonthYearWise']),
        averageAdsCountYearWise: json['averageAdsCountYearWise'] == null ? null : AverageAdsCountYearWise.fromJson(json['averageAdsCountYearWise']),
        monthWiseMostDisplayedAds: json['monthWiseMostDisplayedAds'] == null ? null : MonthWiseMostDisplayedAds.fromJson(json['monthWiseMostDisplayedAds']),
      );

  Map<String, dynamic> toJson() => {
        'totalAdsCountMonthYearWise': totalAdsCountMonthYearWise?.toJson(),
        'averageAdsCountYearWise': averageAdsCountYearWise?.toJson(),
        'monthWiseMostDisplayedAds': monthWiseMostDisplayedAds?.toJson(),
      };
}

class TotalAdsCountMonthYearWise {
  double? jan;
  double? feb;
  double? mar;
  double? apr;
  double? may;
  double? jun;
  double? jul;
  double? aug;
  double? sep;
  double? oct;
  double? nov;
  double? dec;
  double? first;
  double? second;
  double? third;
  double? fourth;
  double? fifth;
  double? sixth;
  double? seventh;
  double? eighth;
  double? ninth;
  double? tenth;
  double? eleventh;
  double? twelfth;
  double? thirteenth;
  double? fourteenth;
  double? fifteenth;
  double? sixteenth;
  double? seventeenth;
  double? eighteenth;
  double? nineteenth;
  double? twentieth;
  double? twentyFirst;
  double? twentySecond;
  double? twentyThird;
  double? twentyFourth;
  double? twentyFifth;
  double? twentySixth;
  double? twentySeventh;
  double? twentyEighth;
  double? twentyNinth;
  double? thirtieth;
  double? thirtyFirst;

  TotalAdsCountMonthYearWise({
    this.jan,
    this.feb,
    this.mar,
    this.apr,
    this.may,
    this.jun,
    this.jul,
    this.aug,
    this.sep,
    this.oct,
    this.nov,
    this.dec,
    this.first,
    this.second,
    this.third,
    this.fourth,
    this.fifth,
    this.sixth,
    this.seventh,
    this.eighth,
    this.ninth,
    this.tenth,
    this.eleventh,
    this.twelfth,
    this.thirteenth,
    this.fourteenth,
    this.fifteenth,
    this.sixteenth,
    this.seventeenth,
    this.eighteenth,
    this.nineteenth,
    this.twentieth,
    this.twentyFirst,
    this.twentySecond,
    this.twentyThird,
    this.twentyFourth,
    this.twentyFifth,
    this.twentySixth,
    this.twentySeventh,
    this.twentyEighth,
    this.twentyNinth,
    this.thirtieth,
    this.thirtyFirst,
  });

  factory TotalAdsCountMonthYearWise.fromJson(Map<String, dynamic> json) => TotalAdsCountMonthYearWise(
        jan: (json['jan'] ?? 0).toDouble(),
        feb: (json['feb'] ?? 0).toDouble(),
        mar: (json['mar'] ?? 0).toDouble(),
        apr: (json['apr'] ?? 0).toDouble(),
        may: (json['may'] ?? 0).toDouble(),
        jun: (json['jun'] ?? 0).toDouble(),
        jul: (json['jul'] ?? 0).toDouble(),
        aug: (json['aug'] ?? 0).toDouble(),
        sep: (json['sep'] ?? 0).toDouble(),
        oct: (json['oct'] ?? 0).toDouble(),
        nov: (json['nov'] ?? 0).toDouble(),
        dec: (json['dec'] ?? 0).toDouble(),
        first: json['first'],
        second: json['second'],
        third: json['third'],
        fourth: json['fourth'],
        fifth: json['fifth'],
        sixth: json['sixth'],
        seventh: json['seventh'],
        eighth: json['eighth'],
        ninth: json['ninth'],
        tenth: json['tenth'],
        eleventh: json['eleventh'],
        twelfth: json['twelfth'],
        thirteenth: json['thirteenth'],
        fourteenth: json['fourteenth'],
        fifteenth: json['fifteenth'],
        sixteenth: json['sixteenth'],
        seventeenth: json['seventeenth'],
        eighteenth: json['eighteenth'],
        nineteenth: json['nineteenth'],
        twentieth: json['twentieth'],
        twentyFirst: json['twentyFirst'],
        twentySecond: json['twentySecond'],
        twentyThird: json['twentyThird'],
        twentyFourth: json['twentyFourth'],
        twentyFifth: json['twentyFifth'],
        twentySixth: json['twentySixth'],
        twentySeventh: json['twentySeventh'],
        twentyEighth: json['twentyEighth'],
        twentyNinth: json['twentyNinth'],
        thirtieth: json['thirtieth'],
        thirtyFirst: json['thirtyFirst'],
      );

  Map<String, dynamic> toJson() => {
        'jan': jan,
        'feb': feb,
        'mar': mar,
        'apr': apr,
        'may': may,
        'jun': jun,
        'jul': jul,
        'aug': aug,
        'sep': sep,
        'oct': oct,
        'nov': nov,
        'dec': dec,
        'first': first,
        'second': second,
        'third': third,
        'fourth': fourth,
        'fifth': fifth,
        'sixth': sixth,
        'seventh': seventh,
        'eighth': eighth,
        'ninth': ninth,
        'tenth': tenth,
        'eleventh': eleventh,
        'twelfth': twelfth,
        'thirteenth': thirteenth,
        'fourteenth': fourteenth,
        'fifteenth': fifteenth,
        'sixteenth': sixteenth,
        'seventeenth': seventeenth,
        'eighteenth': eighteenth,
        'nineteenth': nineteenth,
        'twentieth': twentieth,
        'twentyFirst': twentyFirst,
        'twentySecond': twentySecond,
        'twentyThird': twentyThird,
        'twentyFourth': twentyFourth,
        'twentyFifth': twentyFifth,
        'twentySixth': twentySixth,
        'twentySeventh': twentySeventh,
        'twentyEighth': twentyEighth,
        'twentyNinth': twentyNinth,
        'thirtieth': thirtieth,
        'thirtyFirst': thirtyFirst,
      };
}

class AverageAdsCountYearWise {
  double? jan;
  double? feb;
  double? mar;
  double? apr;
  double? may;
  double? jun;
  double? jul;
  double? aug;
  double? sep;
  double? oct;
  double? nov;
  double? dec;

  AverageAdsCountYearWise({
    this.jan,
    this.feb,
    this.mar,
    this.apr,
    this.may,
    this.jun,
    this.jul,
    this.aug,
    this.sep,
    this.oct,
    this.nov,
    this.dec,
  });

  factory AverageAdsCountYearWise.fromJson(Map<String, dynamic> json) => AverageAdsCountYearWise(
        jan: (json['jan'] ?? 0).toDouble(),
        feb: (json['feb'] ?? 0).toDouble(),
        mar: (json['mar'] ?? 0).toDouble(),
        apr: (json['apr'] ?? 0).toDouble(),
        may: (json['may'] ?? 0).toDouble(),
        jun: (json['jun'] ?? 0).toDouble(),
        jul: (json['jul'] ?? 0).toDouble(),
        aug: (json['aug'] ?? 0).toDouble(),
        sep: (json['sep'] ?? 0).toDouble(),
        oct: (json['oct'] ?? 0).toDouble(),
        nov: (json['nov'] ?? 0).toDouble(),
        dec: (json['dec'] ?? 0).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'jan': jan,
        'feb': feb,
        'mar': mar,
        'apr': apr,
        'may': may,
        'jun': jun,
        'jul': jul,
        'aug': aug,
        'sep': sep,
        'oct': oct,
        'nov': nov,
        'dec': dec,
      };
}

class MonthWiseMostDisplayedAds {
  List<dynamic>? jan;
  List<dynamic>? feb;
  List<dynamic>? mar;
  List<dynamic>? apr;
  List<dynamic>? may;
  List<dynamic>? jun;
  List<dynamic>? jul;
  List<dynamic>? aug;
  List<dynamic>? sep;
  List<dynamic>? oct;
  List<dynamic>? nov;
  List<dynamic>? dec;

  MonthWiseMostDisplayedAds({
    this.jan,
    this.feb,
    this.mar,
    this.apr,
    this.may,
    this.jun,
    this.jul,
    this.aug,
    this.sep,
    this.oct,
    this.nov,
    this.dec,
  });

  factory MonthWiseMostDisplayedAds.fromJson(Map<String, dynamic> json) => MonthWiseMostDisplayedAds(
        jan: json['jan'] ?? [],
        feb: json['feb'] ?? [],
        mar: json['mar'] ?? [],
        apr: json['apr'] ?? [],
        may: json['may'] ?? [],
        jun: json['jun'] ?? [],
        jul: json['jul'] ?? [],
        aug: json['aug'] ?? [],
        sep: json['sep'] ?? [],
        oct: json['oct'] ?? [],
        nov: json['nov'] ?? [],
        dec: json['dec'] ?? [],
      );

  Map<String, dynamic> toJson() => {
        'jan': jan,
        'feb': feb,
        'mar': mar,
        'apr': apr,
        'may': may,
        'jun': jun,
        'jul': jul,
        'aug': aug,
        'sep': sep,
        'oct': oct,
        'nov': nov,
        'dec': dec,
      };
}
