import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/repository/common_response/common_enum_title_value_model.dart';
import 'package:odigov3/framework/repository/dashboard/model/show_title_model.dart';
import 'package:odigov3/framework/repository/dashboard/model/sidemenu_list_response_model.dart';
import 'package:odigov3/framework/repository/master/country/model/get_language_list_response_model.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/session.dart';
import 'package:odigov3/ui/routing/navigation_stack_keys.dart';
import 'package:odigov3/ui/utils/app_enums.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/widgets/common_dialogs.dart';

class AppConstants {
  AppConstants._();

  static const String productionBaseUrl = 'http://49.13.228.207:7901/odigo/v3';

  static AppConstants constant = AppConstants._();

  static const appName = 'Odigo V3';
  WidgetRef? globalRef;

  ///Show Log
  showLog(String str) {
    debugPrint('-> $str');
  }
  String formatDatetime({required int createdAt,String? dateFormat}){
    final DateFormat format = DateFormat(dateFormat??'dd MMM yyyy \'at\' h:mma');
    final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(createdAt, isUtc: true);
    final String formattedString = format.format(dateTime);
    return formattedString;
  }

  List<String> getDaysList(dynamic month) {
    // Normalize string input to lowercase
    if (month is String) {
      month = month.toLowerCase();
    }

    // Map of short and full month names to numbers
    final Map<String, int> monthMap = {
      'jan': 1, 'january': 1,
      'feb': 2, 'february': 2,
      'mar': 3, 'march': 3,
      'apr': 4, 'april': 4,
      'may': 5,
      'jun': 6, 'june': 6,
      'jul': 7, 'july': 7,
      'aug': 8, 'august': 8,
      'sep': 9, 'september': 9,
      'oct': 10, 'october': 10,
      'nov': 11, 'november': 11,
      'dec': 12, 'december': 12,
    };

    int? monthNumber;

    if (month is int) {
      monthNumber = month;
    } else if (month is String && monthMap.containsKey(month)) {
      monthNumber = monthMap[month];
    } else {
      throw ArgumentError('Invalid month value: $month');
    }

    final int year = DateTime.now().year;

    final firstDayOfNextMonth = (monthNumber == 12)
        ? DateTime(year + 1, 1, 1)
        : DateTime(year, (monthNumber??1) + 1, 1);

    final lastDayOfMonth = firstDayOfNextMonth.subtract(const Duration(days: 1));
    int totalDays = lastDayOfMonth.day;

    // Convert day numbers to strings
    return List<String>.generate(totalDays, (index) => (index + 1).toString());
  }


  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 16;
  static const int otpLength = 6;
  static const int maxMobileLength = 10;
  static const int maxEmailLength = 255;
  static const int maxNameLength = 20;
  static const int packageNameLength = 150;
  static const int androidIdLength = 50;
  static const int deviceDetailsLength = 35;
  static const int maxLength60 = 60;
  static const int maxLength3 = 3;
  static const int maxLength6 = 6;
  static const int maxLength10 = 10;
  static const int maxLength15 = 15;
  static const int pageSize = 15;
  static const int maxAddressLength = 255;
  static const int maxDescriptionLength = 250;
  static const int pageSize10000 = 10000;
  static const int maxAmountLength = 10;
  static DateTime appDefaultDate = DateTime(2025,1,1);

  /// Regex to Restrict Emojis Insert in text Fields
  static const regexToRemoveEmoji = '   /\uD83C\uDFF4\uDB40\uDC67\uDB40\uDC62(?:\uDB40\uDC77\uDB40\uDC6C\uDB40\uDC73|\uDB40\uDC73\uDB40\uDC63\uDB40\uDC74|\uDB40\uDC65\uDB40\uDC6E\uDB40\uDC67)\uDB40\uDC7F|\uD83D\uDC69\u200D\uD83D\uDC69\u200D(?:\uD83D\uDC66\u200D\uD83D\uDC66|\uD83D\uDC67\u200D(?:\uD83D[\uDC66\uDC67]))|\uD83D\uDC68(?:\uD83C\uDFFF\u200D(?:\uD83E\uDD1D\u200D\uD83D\uDC68(?:\uD83C[\uDFFB-\uDFFE])|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFE\u200D(?:\uD83E\uDD1D\u200D\uD83D\uDC68(?:\uD83C[\uDFFB-\uDFFD\uDFFF])|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFD\u200D(?:\uD83E\uDD1D\u200D\uD83D\uDC68(?:\uD83C[\uDFFB\uDFFC\uDFFE\uDFFF])|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFC\u200D(?:\uD83E\uDD1D\u200D\uD83D\uDC68(?:\uD83C[\uDFFB\uDFFD-\uDFFF])|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFB\u200D(?:\uD83E\uDD1D\u200D\uD83D\uDC68(?:\uD83C[\uDFFC-\uDFFF])|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\u200D(?:\u2764\uFE0F\u200D(?:\uD83D\uDC8B\u200D)?\uD83D\uDC68|(?:\uD83D[\uDC68\uDC69])\u200D(?:\uD83D\uDC66\u200D\uD83D\uDC66|\uD83D\uDC67\u200D(?:\uD83D[\uDC66\uDC67]))|\uD83D\uDC66\u200D\uD83D\uDC66|\uD83D\uDC67\u200D(?:\uD83D[\uDC66\uDC67])|(?:\uD83D[\uDC68\uDC69])\u200D(?:\uD83D[\uDC66\uDC67])|[\u2695\u2696\u2708]\uFE0F|\uD83D[\uDC66\uDC67]|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|(?:\uD83C\uDFFF\u200D[\u2695\u2696\u2708]|\uD83C\uDFFE\u200D[\u2695\u2696\u2708]|\uD83C\uDFFD\u200D[\u2695\u2696\u2708]|\uD83C\uDFFC\u200D[\u2695\u2696\u2708]|\uD83C\uDFFB\u200D[\u2695\u2696\u2708])\uFE0F|\uD83C\uDFFF|\uD83C\uDFFE|\uD83C\uDFFD|\uD83C\uDFFC|\uD83C\uDFFB)?|\uD83E\uDDD1(?:(?:\uD83C[\uDFFB-\uDFFF])\u200D(?:\uD83E\uDD1D\u200D\uD83E\uDDD1(?:\uD83C[\uDFFB-\uDFFF])|\uD83C[\uDF3E\uDF73\uDF7C\uDF84\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\u200D(?:\uD83E\uDD1D\u200D\uD83E\uDDD1|\uD83C[\uDF3E\uDF73\uDF7C\uDF84\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD]))|\uD83D\uDC69(?:\u200D(?:\u2764\uFE0F\u200D(?:\uD83D\uDC8B\u200D(?:\uD83D[\uDC68\uDC69])|\uD83D[\uDC68\uDC69])|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFF\u200D(?:\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFE\u200D(?:\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFD\u200D(?:\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFC\u200D(?:\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFB\u200D(?:\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD]))|\uD83D\uDC69\uD83C\uDFFF\u200D\uD83E\uDD1D\u200D(?:\uD83D[\uDC68\uDC69])(?:\uD83C[\uDFFB-\uDFFE])|\uD83D\uDC69\uD83C\uDFFE\u200D\uD83E\uDD1D\u200D(?:\uD83D[\uDC68\uDC69])(?:\uD83C[\uDFFB-\uDFFD\uDFFF])|\uD83D\uDC69\uD83C\uDFFD\u200D\uD83E\uDD1D\u200D(?:\uD83D[\uDC68\uDC69])(?:\uD83C[\uDFFB\uDFFC\uDFFE\uDFFF])|\uD83D\uDC69\uD83C\uDFFC\u200D\uD83E\uDD1D\u200D(?:\uD83D[\uDC68\uDC69])(?:\uD83C[\uDFFB\uDFFD-\uDFFF])|\uD83D\uDC69\uD83C\uDFFB\u200D\uD83E\uDD1D\u200D(?:\uD83D[\uDC68\uDC69])(?:\uD83C[\uDFFC-\uDFFF])|\uD83D\uDC69\u200D\uD83D\uDC66\u200D\uD83D\uDC66|\uD83D\uDC69\u200D\uD83D\uDC69\u200D(?:\uD83D[\uDC66\uDC67])|(?:\uD83D\uDC41\uFE0F\u200D\uD83D\uDDE8|\uD83D\uDC69(?:\uD83C\uDFFF\u200D[\u2695\u2696\u2708]|\uD83C\uDFFE\u200D[\u2695\u2696\u2708]|\uD83C\uDFFD\u200D[\u2695\u2696\u2708]|\uD83C\uDFFC\u200D[\u2695\u2696\u2708]|\uD83C\uDFFB\u200D[\u2695\u2696\u2708]|\u200D[\u2695\u2696\u2708])|\uD83C\uDFF3\uFE0F\u200D\u26A7|\uD83E\uDDD1(?:(?:\uD83C[\uDFFB-\uDFFF])\u200D[\u2695\u2696\u2708]|\u200D[\u2695\u2696\u2708])|\uD83D\uDC3B\u200D\u2744|(?:(?:\uD83C[\uDFC3\uDFC4\uDFCA]|\uD83D[\uDC6E\uDC70\uDC71\uDC73\uDC77\uDC81\uDC82\uDC86\uDC87\uDE45-\uDE47\uDE4B\uDE4D\uDE4E\uDEA3\uDEB4-\uDEB6]|\uD83E[\uDD26\uDD35\uDD37-\uDD39\uDD3D\uDD3E\uDDB8\uDDB9\uDDCD-\uDDCF\uDDD6-\uDDDD])(?:\uD83C[\uDFFB-\uDFFF])|\uD83D\uDC6F|\uD83E[\uDD3C\uDDDE\uDDDF])\u200D[\u2640\u2642]|(?:\u26F9|\uD83C[\uDFCB\uDFCC]|\uD83D\uDD75)(?:\uFE0F|\uD83C[\uDFFB-\uDFFF])\u200D[\u2640\u2642]|\uD83C\uDFF4\u200D\u2620|(?:\uD83C[\uDFC3\uDFC4\uDFCA]|\uD83D[\uDC6E\uDC70\uDC71\uDC73\uDC77\uDC81\uDC82\uDC86\uDC87\uDE45-\uDE47\uDE4B\uDE4D\uDE4E\uDEA3\uDEB4-\uDEB6]|\uD83E[\uDD26\uDD35\uDD37-\uDD39\uDD3D\uDD3E\uDDB8\uDDB9\uDDCD-\uDDCF\uDDD6-\uDDDD])\u200D[\u2640\u2642]|[\xA9\xAE\u203C\u2049\u2122\u2139\u2194-\u2199\u21A9\u21AA\u2328\u23CF\u23ED-\u23EF\u23F1\u23F2\u23F8-\u23FA\u24C2\u25AA\u25AB\u25B6\u25C0\u25FB\u25FC\u2600-\u2604\u260E\u2611\u2618\u2620\u2622\u2623\u2626\u262A\u262E\u262F\u2638-\u263A\u2640\u2642\u265F\u2660\u2663\u2665\u2666\u2668\u267B\u267E\u2692\u2694-\u2697\u2699\u269B\u269C\u26A0\u26A7\u26B0\u26B1\u26C8\u26CF\u26D1\u26D3\u26E9\u26F0\u26F1\u26F4\u26F7\u26F8\u2702\u2708\u2709\u270F\u2712\u2714\u2716\u271D\u2721\u2733\u2734\u2744\u2747\u2763\u2764\u27A1\u2934\u2935\u2B05-\u2B07\u3030\u303D\u3297\u3299]|\uD83C[\uDD70\uDD71\uDD7E\uDD7F\uDE02\uDE37\uDF21\uDF24-\uDF2C\uDF36\uDF7D\uDF96\uDF97\uDF99-\uDF9B\uDF9E\uDF9F\uDFCD\uDFCE\uDFD4-\uDFDF\uDFF5\uDFF7]|\uD83D[\uDC3F\uDCFD\uDD49\uDD4A\uDD6F\uDD70\uDD73\uDD76-\uDD79\uDD87\uDD8A-\uDD8D\uDDA5\uDDA8\uDDB1\uDDB2\uDDBC\uDDC2-\uDDC4\uDDD1-\uDDD3\uDDDC-\uDDDE\uDDE1\uDDE3\uDDE8\uDDEF\uDDF3\uDDFA\uDECB\uDECD-\uDECF\uDEE0-\uDEE5\uDEE9\uDEF0\uDEF3])\uFE0F|\uD83D\uDC69\u200D\uD83D\uDC67\u200D(?:\uD83D[\uDC66\uDC67])|\uD83C\uDFF3\uFE0F\u200D\uD83C\uDF08|\uD83D\uDC69\u200D\uD83D\uDC67|\uD83D\uDC69\u200D\uD83D\uDC66|\uD83D\uDC15\u200D\uD83E\uDDBA|\uD83D\uDC69(?:\uD83C\uDFFF|\uD83C\uDFFE|\uD83C\uDFFD|\uD83C\uDFFC|\uD83C\uDFFB)?|\uD83C\uDDFD\uD83C\uDDF0|\uD83C\uDDF6\uD83C\uDDE6|\uD83C\uDDF4\uD83C\uDDF2|\uD83D\uDC08\u200D\u2B1B|\uD83D\uDC41\uFE0F|\uD83C\uDFF3\uFE0F|\uD83E\uDDD1(?:\uD83C[\uDFFB-\uDFFF])?|\uD83C\uDDFF(?:\uD83C[\uDDE6\uDDF2\uDDFC])|\uD83C\uDDFE(?:\uD83C[\uDDEA\uDDF9])|\uD83C\uDDFC(?:\uD83C[\uDDEB\uDDF8])|\uD83C\uDDFB(?:\uD83C[\uDDE6\uDDE8\uDDEA\uDDEC\uDDEE\uDDF3\uDDFA])|\uD83C\uDDFA(?:\uD83C[\uDDE6\uDDEC\uDDF2\uDDF3\uDDF8\uDDFE\uDDFF])|\uD83C\uDDF9(?:\uD83C[\uDDE6\uDDE8\uDDE9\uDDEB-\uDDED\uDDEF-\uDDF4\uDDF7\uDDF9\uDDFB\uDDFC\uDDFF])|\uD83C\uDDF8(?:\uD83C[\uDDE6-\uDDEA\uDDEC-\uDDF4\uDDF7-\uDDF9\uDDFB\uDDFD-\uDDFF])|\uD83C\uDDF7(?:\uD83C[\uDDEA\uDDF4\uDDF8\uDDFA\uDDFC])|\uD83C\uDDF5(?:\uD83C[\uDDE6\uDDEA-\uDDED\uDDF0-\uDDF3\uDDF7-\uDDF9\uDDFC\uDDFE])|\uD83C\uDDF3(?:\uD83C[\uDDE6\uDDE8\uDDEA-\uDDEC\uDDEE\uDDF1\uDDF4\uDDF5\uDDF7\uDDFA\uDDFF])|\uD83C\uDDF2(?:\uD83C[\uDDE6\uDDE8-\uDDED\uDDF0-\uDDFF])|\uD83C\uDDF1(?:\uD83C[\uDDE6-\uDDE8\uDDEE\uDDF0\uDDF7-\uDDFB\uDDFE])|\uD83C\uDDF0(?:\uD83C[\uDDEA\uDDEC-\uDDEE\uDDF2\uDDF3\uDDF5\uDDF7\uDDFC\uDDFE\uDDFF])|\uD83C\uDDEF(?:\uD83C[\uDDEA\uDDF2\uDDF4\uDDF5])|\uD83C\uDDEE(?:\uD83C[\uDDE8-\uDDEA\uDDF1-\uDDF4\uDDF6-\uDDF9])|\uD83C\uDDED(?:\uD83C[\uDDF0\uDDF2\uDDF3\uDDF7\uDDF9\uDDFA])|\uD83C\uDDEC(?:\uD83C[\uDDE6\uDDE7\uDDE9-\uDDEE\uDDF1-\uDDF3\uDDF5-\uDDFA\uDDFC\uDDFE])|\uD83C\uDDEB(?:\uD83C[\uDDEE-\uDDF0\uDDF2\uDDF4\uDDF7])|\uD83C\uDDEA(?:\uD83C[\uDDE6\uDDE8\uDDEA\uDDEC\uDDED\uDDF7-\uDDFA])|\uD83C\uDDE9(?:\uD83C[\uDDEA\uDDEC\uDDEF\uDDF0\uDDF2\uDDF4\uDDFF])|\uD83C\uDDE8(?:\uD83C[\uDDE6\uDDE8\uDDE9\uDDEB-\uDDEE\uDDF0-\uDDF5\uDDF7\uDDFA-\uDDFF])|\uD83C\uDDE7(?:\uD83C[\uDDE6\uDDE7\uDDE9-\uDDEF\uDDF1-\uDDF4\uDDF6-\uDDF9\uDDFB\uDDFC\uDDFE\uDDFF])|\uD83C\uDDE6(?:\uD83C[\uDDE8-\uDDEC\uDDEE\uDDF1\uDDF2\uDDF4\uDDF6-\uDDFA\uDDFC\uDDFD\uDDFF])|[#\*0-9]\uFE0F\u20E3|(?:\uD83C[\uDFC3\uDFC4\uDFCA]|\uD83D[\uDC6E\uDC70\uDC71\uDC73\uDC77\uDC81\uDC82\uDC86\uDC87\uDE45-\uDE47\uDE4B\uDE4D\uDE4E\uDEA3\uDEB4-\uDEB6]|\uD83E[\uDD26\uDD35\uDD37-\uDD39\uDD3D\uDD3E\uDDB8\uDDB9\uDDCD-\uDDCF\uDDD6-\uDDDD])(?:\uD83C[\uDFFB-\uDFFF])|(?:\u26F9|\uD83C[\uDFCB\uDFCC]|\uD83D\uDD75)(?:\uFE0F|\uD83C[\uDFFB-\uDFFF])|\uD83C\uDFF4|(?:[\u270A\u270B]|\uD83C[\uDF85\uDFC2\uDFC7]|\uD83D[\uDC42\uDC43\uDC46-\uDC50\uDC66\uDC67\uDC6B-\uDC6D\uDC72\uDC74-\uDC76\uDC78\uDC7C\uDC83\uDC85\uDCAA\uDD7A\uDD95\uDD96\uDE4C\uDE4F\uDEC0\uDECC]|\uD83E[\uDD0C\uDD0F\uDD18-\uDD1C\uDD1E\uDD1F\uDD30-\uDD34\uDD36\uDD77\uDDB5\uDDB6\uDDBB\uDDD2-\uDDD5])(?:\uD83C[\uDFFB-\uDFFF])|(?:[\u261D\u270C\u270D]|\uD83D[\uDD74\uDD90])(?:\uFE0F|\uD83C[\uDFFB-\uDFFF])|[\u270A\u270B]|\uD83C[\uDF85\uDFC2\uDFC7]|\uD83D[\uDC08\uDC15\uDC3B\uDC42\uDC43\uDC46-\uDC50\uDC66\uDC67\uDC6B-\uDC6D\uDC72\uDC74-\uDC76\uDC78\uDC7C\uDC83\uDC85\uDCAA\uDD7A\uDD95\uDD96\uDE4C\uDE4F\uDEC0\uDECC]|\uD83E[\uDD0C\uDD0F\uDD18-\uDD1C\uDD1E\uDD1F\uDD30-\uDD34\uDD36\uDD77\uDDB5\uDDB6\uDDBB\uDDD2-\uDDD5]|\uD83C[\uDFC3\uDFC4\uDFCA]|\uD83D[\uDC6E\uDC70\uDC71\uDC73\uDC77\uDC81\uDC82\uDC86\uDC87\uDE45-\uDE47\uDE4B\uDE4D\uDE4E\uDEA3\uDEB4-\uDEB6]|\uD83E[\uDD26\uDD35\uDD37-\uDD39\uDD3D\uDD3E\uDDB8\uDDB9\uDDCD-\uDDCF\uDDD6-\uDDDD]|\uD83D\uDC6F|\uD83E[\uDD3C\uDDDE\uDDDF]|[\u231A\u231B\u23E9-\u23EC\u23F0\u23F3\u25FD\u25FE\u2614\u2615\u2648-\u2653\u267F\u2693\u26A1\u26AA\u26AB\u26BD\u26BE\u26C4\u26C5\u26CE\u26D4\u26EA\u26F2\u26F3\u26F5\u26FA\u26FD\u2705\u2728\u274C\u274E\u2753-\u2755\u2757\u2795-\u2797\u27B0\u27BF\u2B1B\u2B1C\u2B50\u2B55]|\uD83C[\uDC04\uDCCF\uDD8E\uDD91-\uDD9A\uDE01\uDE1A\uDE2F\uDE32-\uDE36\uDE38-\uDE3A\uDE50\uDE51\uDF00-\uDF20\uDF2D-\uDF35\uDF37-\uDF7C\uDF7E-\uDF84\uDF86-\uDF93\uDFA0-\uDFC1\uDFC5\uDFC6\uDFC8\uDFC9\uDFCF-\uDFD3\uDFE0-\uDFF0\uDFF8-\uDFFF]|\uD83D[\uDC00-\uDC07\uDC09-\uDC14\uDC16-\uDC3A\uDC3C-\uDC3E\uDC40\uDC44\uDC45\uDC51-\uDC65\uDC6A\uDC79-\uDC7B\uDC7D-\uDC80\uDC84\uDC88-\uDCA9\uDCAB-\uDCFC\uDCFF-\uDD3D\uDD4B-\uDD4E\uDD50-\uDD67\uDDA4\uDDFB-\uDE44\uDE48-\uDE4A\uDE80-\uDEA2\uDEA4-\uDEB3\uDEB7-\uDEBF\uDEC1-\uDEC5\uDED0-\uDED2\uDED5-\uDED7\uDEEB\uDEEC\uDEF4-\uDEFC\uDFE0-\uDFEB]|\uD83E[\uDD0D\uDD0E\uDD10-\uDD17\uDD1D\uDD20-\uDD25\uDD27-\uDD2F\uDD3A\uDD3F-\uDD45\uDD47-\uDD76\uDD78\uDD7A-\uDDB4\uDDB7\uDDBA\uDDBC-\uDDCB\uDDD0\uDDE0-\uDDFF\uDE70-\uDE74\uDE78-\uDE7A\uDE80-\uDE86\uDE90-\uDEA8\uDEB0-\uDEB6\uDEC0-\uDEC2\uDED0-\uDED6]|(?:[\u231A\u231B\u23E9-\u23EC\u23F0\u23F3\u25FD\u25FE\u2614\u2615\u2648-\u2653\u267F\u2693\u26A1\u26AA\u26AB\u26BD\u26BE\u26C4\u26C5\u26CE\u26D4\u26EA\u26F2\u26F3\u26F5\u26FA\u26FD\u2705\u270A\u270B\u2728\u274C\u274E\u2753-\u2755\u2757\u2795-\u2797\u27B0\u27BF\u2B1B\u2B1C\u2B50\u2B55]|\uD83C[\uDC04\uDCCF\uDD8E\uDD91-\uDD9A\uDDE6-\uDDFF\uDE01\uDE1A\uDE2F\uDE32-\uDE36\uDE38-\uDE3A\uDE50\uDE51\uDF00-\uDF20\uDF2D-\uDF35\uDF37-\uDF7C\uDF7E-\uDF93\uDFA0-\uDFCA\uDFCF-\uDFD3\uDFE0-\uDFF0\uDFF4\uDFF8-\uDFFF]|\uD83D[\uDC00-\uDC3E\uDC40\uDC42-\uDCFC\uDCFF-\uDD3D\uDD4B-\uDD4E\uDD50-\uDD67\uDD7A\uDD95\uDD96\uDDA4\uDDFB-\uDE4F\uDE80-\uDEC5\uDECC\uDED0-\uDED2\uDED5-\uDED7\uDEEB\uDEEC\uDEF4-\uDEFC\uDFE0-\uDFEB]|\uD83E[\uDD0C-\uDD3A\uDD3C-\uDD45\uDD47-\uDD78\uDD7A-\uDDCB\uDDCD-\uDDFF\uDE70-\uDE74\uDE78-\uDE7A\uDE80-\uDE86\uDE90-\uDEA8\uDEB0-\uDEB6\uDEC0-\uDEC2\uDED0-\uDED6])|(?:[#\*0-9\xA9\xAE\u203C\u2049\u2122\u2139\u2194-\u2199\u21A9\u21AA\u231A\u231B\u2328\u23CF\u23E9-\u23F3\u23F8-\u23FA\u24C2\u25AA\u25AB\u25B6\u25C0\u25FB-\u25FE\u2600-\u2604\u260E\u2611\u2614\u2615\u2618\u261D\u2620\u2622\u2623\u2626\u262A\u262E\u262F\u2638-\u263A\u2640\u2642\u2648-\u2653\u265F\u2660\u2663\u2665\u2666\u2668\u267B\u267E\u267F\u2692-\u2697\u2699\u269B\u269C\u26A0\u26A1\u26A7\u26AA\u26AB\u26B0\u26B1\u26BD\u26BE\u26C4\u26C5\u26C8\u26CE\u26CF\u26D1\u26D3\u26D4\u26E9\u26EA\u26F0-\u26F5\u26F7-\u26FA\u26FD\u2702\u2705\u2708-\u270D\u270F\u2712\u2714\u2716\u271D\u2721\u2728\u2733\u2734\u2744\u2747\u274C\u274E\u2753-\u2755\u2757\u2763\u2764\u2795-\u2797\u27A1\u27B0\u27BF\u2934\u2935\u2B05-\u2B07\u2B1B\u2B1C\u2B50\u2B55\u3030\u303D\u3297\u3299]|\uD83C[\uDC04\uDCCF\uDD70\uDD71\uDD7E\uDD7F\uDD8E\uDD91-\uDD9A\uDDE6-\uDDFF\uDE01\uDE02\uDE1A\uDE2F\uDE32-\uDE3A\uDE50\uDE51\uDF00-\uDF21\uDF24-\uDF93\uDF96\uDF97\uDF99-\uDF9B\uDF9E-\uDFF0\uDFF3-\uDFF5\uDFF7-\uDFFF]|\uD83D[\uDC00-\uDCFD\uDCFF-\uDD3D\uDD49-\uDD4E\uDD50-\uDD67\uDD6F\uDD70\uDD73-\uDD7A\uDD87\uDD8A-\uDD8D\uDD90\uDD95\uDD96\uDDA4\uDDA5\uDDA8\uDDB1\uDDB2\uDDBC\uDDC2-\uDDC4\uDDD1-\uDDD3\uDDDC-\uDDDE\uDDE1\uDDE3\uDDE8\uDDEF\uDDF3\uDDFA-\uDE4F\uDE80-\uDEC5\uDECB-\uDED2\uDED5-\uDED7\uDEE0-\uDEE5\uDEE9\uDEEB\uDEEC\uDEF0\uDEF3-\uDEFC\uDFE0-\uDFEB]|\uD83E[\uDD0C-\uDD3A\uDD3C-\uDD45\uDD47-\uDD78\uDD7A-\uDDCB\uDDCD-\uDDFF\uDE70-\uDE74\uDE78-\uDE7A\uDE80-\uDE86\uDE90-\uDEA8\uDEB0-\uDEB6\uDEC0-\uDEC2\uDED0-\uDED6])\uFE0F|(?:[\u261D\u26F9\u270A-\u270D]|\uD83C[\uDF85\uDFC2-\uDFC4\uDFC7\uDFCA-\uDFCC]|\uD83D[\uDC42\uDC43\uDC46-\uDC50\uDC66-\uDC78\uDC7C\uDC81-\uDC83\uDC85-\uDC87\uDC8F\uDC91\uDCAA\uDD74\uDD75\uDD7A\uDD90\uDD95\uDD96\uDE45-\uDE47\uDE4B-\uDE4F\uDEA3\uDEB4-\uDEB6\uDEC0\uDECC]|\uD83E[\uDD0C\uDD0F\uDD18-\uDD1F\uDD26\uDD30-\uDD39\uDD3C-\uDD3E\uDD77\uDDB5\uDDB6\uDDB8\uDDB9\uDDBB\uDDCD-\uDDCF\uDDD1-\uDDDD])/';

  /// Hide Keyboard
  static hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  static String userBoxName = 'odigo_v3';
  static String zoomBoxName = 'odigo_v3_zoom';

  static const String currency = '\₹';

  static const String accept = 'Accept';
  static const String headerAccept = 'application/json';
  static const String contentType = 'contentType';
  static const String headerContentType = 'application/json';
  static const String acceptLanguage = 'Accept-Language';
  static const String production = 'production';
  static const String development = 'development';
  static const String authorization = 'Authorization';
  static const String bearer = 'Bearer';
  static const String responseType = 'responseType';
  static const String followRedirects = 'followRedirects';
  static const String connectTimeout = 'connectTimeout';
  static const String receiveTimeout = 'receiveTimeout';
  static const String headers = 'Headers';
  static const String extras = 'Extras';
  static const String queryParameters = 'Query Parameters';
  static const String get = 'GET';
  static const String body = 'Body';
  static const String formData = 'Form data';
  static const String dioError = 'DioError';
  static const String status = 'Status:';
  static const int initialTabNumber = 1;
  static const int dioLoggerMaxWidth = 90;
  static const String response = 'Response';
  static const String requestText = 'Request';
  static const Null nullValue = null;
  static const String nullString = 'null';
  static const String emptyString = '{}';
  static const String error = 'error';
  static const String stacktrace = 'stacktrace';



  ///Video related constants --------------------


  // Default trim duration in seconds
  static const int defaultTrimDurationSeconds = 10;

  // Minimum video duration to allow trimming (in seconds)
  static const int minimumVideoDurationSeconds = 10;

  // Supported video formats
  static const List<String> supportedVideoFormats = [
    'mp4',
    'mov',
    'avi',
    'mkv',
    'webm',
    '3gp',
    'flv',
    'wmv',
  ];

  // Timeline configuration
  static const double timelineHeight = 30.0;
  static const double timelineThumbSize = 20.0;
  static const double timelineTrackHeight = 4.0;

  // Video player configuration
  static const double videoPlayerAspectRatio = 16 / 9;
  static const double maxVideoPlayerHeight = 300.0;

  // UI constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;

  // Error messages
  static const String errorVideoTooShort = 'Video must be longer than 10 seconds to trim';
  static const String errorUnsupportedFormat = 'Unsupported video format';
  static const String errorVideoLoadFailed = 'Failed to load video';
  static const String errorTrimFailed = 'Failed to trim video';
  static const String errorNoVideoSelected = 'Please select a video first';
  static const String errorPermissionDenied = 'Storage permission denied';

  // Success messages
  static const String successVideoTrimmed = 'Video trimmed successfully';
  static const String successVideoSaved = 'Trimmed video saved to gallery';



}


String getTimeAgoFromTimestamp(int timestampMillis) {
  final now = DateTime.now();
  final date = DateTime.fromMillisecondsSinceEpoch(timestampMillis);
  final difference = now.difference(date);

  if (difference.inDays == 0) {
    return 'Today';
  } else if (difference.inDays == 1) {
    return 'Yesterday';
  } else if (difference.inDays < 7) {
    return '${difference.inDays} days ago';
  } else if (difference.inDays < 30) {
    final weeks = (difference.inDays / 7).floor();
    return "$weeks Week${weeks > 1 ? 's' : ''} ago";
  } else if (difference.inDays < 365) {
    final months = (difference.inDays / 30).floor();
    return "$months Month${months > 1 ? 's' : ''} ago";
  } else {
    final years = (difference.inDays / 365).floor();
    return "$years Year${years > 1 ? 's' : ''} ago";
  }
}

///Page Size in Pagination
int pageSize = 15;
int pageSizeTwenty = 20;

const String unknown = 'Unknown';
const String receivedInvalidStatusCode = 'Received invalid status code:';
const String socketException = 'SocketException';
const String formatException = 'FormatException';
const String isNotaSubtypeOf = 'is not a subtype of';
const String notImplemented = 'Not Implemented';
const String requestCancelled = 'Request Cancelled';
const String internalServerError = 'Internal Server Error';
const String serviceUnavailable = 'Service unavailable';
const String methodAllowed = 'Method Allowed';
const String badRequest = 'Bad request';
const String unauthorizedRequest = 'Unauthorized request';
const String unexpectedErrorOccurred = 'Unexpected error occurred';
const String connectionRequestTimeout = 'Connection request timeout';
const String noInternetConnection = 'No internet connection';
const String errorDueToaConflict = 'Error due to a conflict';
const String sendTimeoutInConnectionWithAPIServer = 'Send timeout in connection with API server';
const String unableToProcessTheData = 'Unable to process the data';
const String formatExceptionSomethingWentWrongWithData = 'FormatException something went wrong with data';
const String notAcceptable = 'Not acceptable';
const String badeCertificate = 'Bade Certificate';
const String connectionError = 'Connection error';
const String moneySign = '\$';

String cmsPage = 'CMS';

///for email emoji restrict
RegExp regExpBlocEmoji = RegExp(r"""[a-zA-Z0-9\u0600-\u06FF\s.,!?@#\$%&*()_\-+=:;'/\"]""");

///Lower case text formatting
class LowerCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.copyWith(text: newValue.text.toLowerCase(), selection: newValue.selection);
  }
}

int maxEmailLength = 255;
int maxLength50 = 50;
const int maxMobileLength = 10;
int minMobileLength = 7;
int maxNameLength = 20;
int maxPasswordLength = 16;

/// Get Language Model
GetLanguageListResponseModel? getLanguageModelFromSession() {
  GetLanguageListResponseModel? getLanguageListResponseModel;
  String strLangRes = Session.languageModel;
  if (strLangRes.isNotEmpty) {
    getLanguageListResponseModel = getLanguageListResponseModelFromJson(strLangRes);
  }
  return getLanguageListResponseModel;
}

///Show Log
showLog(String str) {
  if(kDebugMode){
    debugPrint('-> $str');
  }
}

class DynamicFormModel {
  final String errorText;
  final String hintText;
  final int? maxLength;

  DynamicFormModel({required this.errorText, required this.hintText, this.maxLength});
}

/// Get Hint Text For Dynamic Textfield
DynamicFormModel getDynamicFormTextField(DynamicFormEnum dynamicFormEnum) {
  switch (dynamicFormEnum) {
    case DynamicFormEnum.COUNTRY:
      return DynamicFormModel(errorText: LocaleKeys.keyCountryIsRequired.localized, hintText: LocaleKeys.keyCountry.localized, maxLength: AppConstants.maxLength60);
    case DynamicFormEnum.STATE:
      return DynamicFormModel(errorText: LocaleKeys.keyStateIsRequired.localized, hintText: LocaleKeys.keyStateName.localized, maxLength: AppConstants.maxLength60);
    case DynamicFormEnum.CITY:
      return DynamicFormModel(errorText: LocaleKeys.keyCityIsRequired.localized, hintText: LocaleKeys.keyCityName.localized, maxLength: AppConstants.maxLength60);
    case DynamicFormEnum.TICKET_REASON:
      return DynamicFormModel(errorText: LocaleKeys.keyTicketReasonRequired.localized, hintText: LocaleKeys.keyTicketReason.localized, maxLength: AppConstants.maxEmailLength);
    case DynamicFormEnum.DESTINATION_NAME:
      return DynamicFormModel(errorText: LocaleKeys.keyDestinationNameRequired.localized, hintText: LocaleKeys.keyDestinationName.localized, maxLength: AppConstants.maxLength60);
    case DynamicFormEnum.STORE:
      return DynamicFormModel(errorText: LocaleKeys.keyStoreNameShouldBeRequired.localized, hintText: LocaleKeys.keyStoreName.localized,maxLength: AppConstants.maxLength60);
    case DynamicFormEnum.CATEGORY:
      return DynamicFormModel(errorText: LocaleKeys.keyCategoryShouldBeRequired.localized, hintText: LocaleKeys.keyCategoryName.localized,maxLength: AppConstants.maxEmailLength);
    case DynamicFormEnum.DESTINATION_TYPE:
      return DynamicFormModel(errorText: LocaleKeys.keyDestinationTypeIsRequired.localized, hintText: LocaleKeys.keyDestinationType.localized,maxLength: AppConstants.maxLength60);
    case DynamicFormEnum.ADDRESS:
      return DynamicFormModel(errorText: LocaleKeys.keyCompanyAddressRequired.localized, hintText: LocaleKeys.keyCompanyAddress.localized,maxLength: AppConstants.maxAddressLength);
    case DynamicFormEnum.COMPANY:
      return DynamicFormModel(errorText: LocaleKeys.keyCompanyNameRequired.localized, hintText: LocaleKeys.keyCompanyName.localized,maxLength: AppConstants.maxLength60);

    case DynamicFormEnum.FAQ_QUESTION:
      return DynamicFormModel(errorText: LocaleKeys.keyQuestionRequired.localized, hintText: LocaleKeys.keyQuestion.localized);
    case DynamicFormEnum.FAQ_ANSWER:
      return DynamicFormModel(errorText: LocaleKeys.keyAnswerRequired.localized, hintText: LocaleKeys.keyAnswer.localized);
  }
}

excelDocumentPicker(BuildContext context,Function(dynamic) onPickedUp) async {
  await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['xlsx', /*'xls'*/],
  ).then((value) {
    if(value != null) {
      PlatformFile file = (value.files).single;
      String extension = file.extension!;
      if (extension == 'xlsx') {
        onPickedUp(value);
      } else {
        showErrorDialogue(
          context: context,
          dismissble: true,
          buttonText: LocaleKeys.keyOk.localized,
          onTap: ()
          {
            Navigator.pop(context);
          },
          animation:  Assets.anim.animErrorJson.keyName,
          successMessage:LocaleKeys.keyXlsxIsAllowed.localized,

        );
      }
    }
    return null;
  },);
}

class NameInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text;

    // Remove multiple spaces at the beginning
    text = text.replaceFirst(RegExp(r'^\s+'), '');

    // Allow only one space between words
    text = text.replaceAll(RegExp(r'\s{2,}'), ' ');

    return newValue.copyWith(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

/// To remove at first & Replace multiple spaces with a single space
TextInputFormatter searchInputFormatter() {
  return TextInputFormatter.withFunction((oldValue, newValue) {
    String newText = newValue.text
        .replaceAll(RegExp(r'^\s+'), '') // Remove leading spaces
        .replaceAll(RegExp(r'\s{2,}'), ' '); // Replace multiple spaces with a single space

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  });
}

String getImageNameFromUrl(String url) {
  if(url.isEmpty) return '';
  return Uri.parse(url).pathSegments.last;
}

class SingleSpaceInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    // Replace multiple spaces with a single space
    String newText = newValue.text.replaceAll(RegExp(r'\s+'), ' ');

    // Prevent space at the start
    if (newText.startsWith(' ')) {
      newText = newText.trimLeft();
    }
    // Calculate the new selection offset
    int diff = newValue.text.length - newText.length;
    int baseOffset = newValue.selection.baseOffset - diff;
    int extentOffset = newValue.selection.extentOffset - diff;
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(
        offset: max(0, min(newText.length, baseOffset)),
      ),
    );
  }
}

String formatDateDDMMYYY_HHMMA(int? dateTime){
  if(dateTime == null){
    return '-';
  }
  return DateFormat('dd/MM/yyyy - hh:mma').format(DateTime.fromMillisecondsSinceEpoch(dateTime)).toUpperCase();
}

String? formatUtcToLocalDate(int? utcMilliseconds,{String? outputFormat,bool? isLocaleNotRequired}) {
  if (utcMilliseconds == null) return null;
  DateTime utcDate = DateTime.fromMillisecondsSinceEpoch(utcMilliseconds, isUtc: true);
  DateTime localDate = utcDate.toLocal();
  return DateFormat(outputFormat??'dd/MM/yyyy',/*isLocaleNotRequired??false?null:Session.isRTL ? 'ar' : 'en'*/).format(localDate);
}

// String formatDateRange(List<DateTime?>? values) {
//   if (values == null || values.isEmpty) return '';
//
//   final DateFormat formatter = DateFormat('d MMM, yyyy');
//
//   List<DateTime> nonNullValues = values.whereType<DateTime>().toList();
//
//   if (nonNullValues.isEmpty) return '';
//   nonNullValues.sort();
//   if(nonNullValues.length == 2){
//     if(nonNullValues.first == nonNullValues.last){
//      // nonNullValues.removeLast();
//     }
//   }
//
//   // Format based on the number of dates
//   return nonNullValues.length == 1
//       ? formatter.format(nonNullValues.first)
//       : '${formatter.format(nonNullValues.first)} - ${formatter.format(nonNullValues.last)}';
// }

String formatDateToDDMMYYYY(DateTime? date) {
  if (date == null) return '-';
  return '${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')}/'
      '${date.year}';
}

String formatDateRange(List<DateTime?>? values) {
  if (values == null || values.isEmpty) return '';

  // Format for date display
  final DateFormat formatter = DateFormat('dd/MM/yyyy');

  // Ensure only non-null values are considered
  List<DateTime> nonNullValues = values.whereType<DateTime>().toList();

  if (nonNullValues.isEmpty) return '';

  // Sort the dates to ensure correct order
  nonNullValues.sort();

  if(nonNullValues.length ==2){
    if(nonNullValues.first == nonNullValues.last){
      nonNullValues.removeLast();
    }
  }

  // Format based on the number of dates
  return nonNullValues.length == 1
      ? formatter.format(nonNullValues.first)
      : '${formatter.format(nonNullValues.first)} - ${formatter.format(nonNullValues.last)}';
}

String? formatHHMMAStringDateToDateTime(String? timeString) {
  if(timeString == null) return null;
  DateTime dateTime = DateFormat('HH:mm:ss').parse(timeString);
  return DateFormat('hh:mm a').format(dateTime).toUpperCase();
}

List<CommonEnumTitleValueModel> commonActiveDeActiveList = [
  CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null),
  CommonEnumTitleValueModel(title: LocaleKeys.keyActive,value: true),
  CommonEnumTitleValueModel(title: LocaleKeys.keyInActive, value: false),
];

List<CommonEnumTitleValueModel> commonFilterStatusList = [
  CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null,enumType: null),
  CommonEnumTitleValueModel(title: LocaleKeys.keyCompleted,enumType: StatusEnum.COMPLETED.name),
  CommonEnumTitleValueModel(title: LocaleKeys.keyPending,enumType: StatusEnum.PENDING.name),
  CommonEnumTitleValueModel(title: LocaleKeys.keyFailed,enumType: StatusEnum.FAILED.name),
  CommonEnumTitleValueModel(title: LocaleKeys.keyInProcess, enumType: StatusEnum.INPROCESS.name),
  CommonEnumTitleValueModel(title: LocaleKeys.keyPartiallyFailed, enumType: StatusEnum.PARTIALY_FAILED.name),
  CommonEnumTitleValueModel(title: LocaleKeys.keyCancelled, enumType: StatusEnum.CANCELLED.name),
];


String? formatTime(int? millis, {bool? isUtc, String? outputFormat}) {
  if(millis == null) return null;
  final formatted = DateFormat(outputFormat??'hh:mm a',/* Session.isRTL ? 'ar' : 'en'*/).format(DateTime.fromMillisecondsSinceEpoch(millis, isUtc: isUtc??false));
  return /* Session.isRTL ? convertToWesternDigits(formatted):*/ formatted;
}

String convertToWesternDigits(String input) {
  const easternToWestern = {
    '٠': '0',
    '١': '1',
    '٢': '2',
    '٣': '3',
    '٤': '4',
    '٥': '5',
    '٦': '6',
    '٧': '7',
    '٨': '8',
    '٩': '9',
  };
  return input.split('/').map((char) => easternToWestern[char] ?? char).join();
}

SidebarModel? findSidebarModuleByName(List<SidebarModel> modules, String name) {
  final lowerName = name.toLowerCase().removeWhiteSpace;

  for (final module in modules) {
    // Check parent name
    if ((module.modulesNameEnglish ?? '').toLowerCase().removeWhiteSpace == lowerName) {
      return module;
    }

    // Check children
    final child = module.children?.firstWhere(
          (c) => (c.modulesNameEnglish ?? '').toLowerCase().removeWhiteSpace == lowerName,
      orElse: () => SubSidebarData(), // return empty if not found
    );

    // If child matched, wrap it back into a SidebarModel (for consistent handling)
    if (child != null && (child.modulesName ?? '').isNotEmpty) {
      return SidebarModel(
        modulesUuid: child.modulesUuid,
        modulesName: child.modulesName,
        modulesNameEnglish: child.modulesNameEnglish,
        canView: child.canView,
        canEdit: child.canEdit,
        canAdd: child.canAdd,
        canDelete: child.canDelete,
        canViewSidebar: child.canViewSidebar,
        drawerMenuModel: child.drawerMenuModel,
        children: [],
      );
    }
  }

  return null;
}

String getLabelForKey(String key) {
  if (key == Keys.dashboard || key == Keys.settings || key == Keys.profile || key == Keys.notification) return 'Dashboard';

  if (key == Keys.country) return 'Country';
  if (key == Keys.state || key == Keys.editState || key == Keys.addState) return 'State';
  if (key == Keys.city || key == Keys.editCity || key == Keys.addCity) return 'City';
  if (key == Keys.ticketReason || key == Keys.addTicketReason || key == Keys.editTicketReason) return 'Ticket Reason';
  if (key == Keys.category || key == Keys.editCategory || key == Keys.addCategory) return 'Category';
  if (key == Keys.destinationType || key == Keys.editDestinationType || key == Keys.addDestinationType) return 'Destination Type';

  if (key == Keys.device || key == Keys.deviceDetails || key == Keys.editDevice || key == Keys.addDevice) return 'Device';

  if (key == Keys.store || key == Keys.addStore || key == Keys.editStore || key == Keys.storeDetail) return 'Store';

  if (key == Keys.destination || key == Keys.destinationDetails || key == Keys.destinationDetailsInfo || key == Keys.assignRobot || key == Keys.assignStore || key == Keys.manageDestination) return 'Destination';

  if (key == Keys.destinationUsers || key == Keys.destinationUserDetails || key == Keys.addDestinationUser || key == Keys.editDestinationUser) return 'Destination User';

  if (key == Keys.clientAds || key == Keys.createAdsClient || key == Keys.adsDetails) return 'Client Ads';
  if (key == Keys.defaultAds || key == Keys.createAdsDestination || key == Keys.adsDetails) return 'Default Ads';

  if (key == Keys.client || key == Keys.uploadDocument || key == Keys.clientDetails || key == Keys.addClient || key == Keys.editClient || key == Keys.client || key == Keys.addPurchase || key == Keys.settleWallet) return 'Client';

  if (key == Keys.purchase || key == Keys.purchaseList || key == Keys.purchaseDetails || key == Keys.changeAds) return 'Purchase';

  if (key == Keys.addRolePermission || key == Keys.editRolePermission || key == Keys.rolesAndPermission || key == Keys.rolesAndPermissionDetails) return 'Role & Permission';

  if (key == Keys.cms) return 'CMS';
  if (key == Keys.faq || key == Keys.addFaq || key == Keys.editFaq) return 'FAQ';
  if (key == Keys.ticketList) return 'Ticket';
  if (key == Keys.generalSupport) return 'Contact Us';
  if (key == Keys.company || key == Keys.editCompany) return 'Company';
  if (key == Keys.users || key == Keys.addNewUser || key == Keys.editUser || key == Keys.userDetails) return 'Users';
  if (key == Keys.purchaseTransactions) return 'Purchase Transactions';
  if (key == Keys.walletTransactions) return 'Wallet Transactions';
  if (key == Keys.adsSequencePreview) return 'Preview';
  if (key == Keys.adsShowTime) return 'Ads Shown Time';
  if (key == Keys.history) return 'History';
  return key;
}

getAllLocalizeText(String? status) {
  switch (status) {
    case 'PENDING':
      return LocaleKeys.keyPending.localized;
    case 'REJECTED':
      return LocaleKeys.keyRejected.localized;
    case 'ACTIVE':
      return LocaleKeys.keyActive.localized;
    case 'INACTIVE':
      return LocaleKeys.keyInActive.localized;
    case 'COMPLETED':
      return LocaleKeys.keyCompleted.localized;
    case 'ONGOING':
      return LocaleKeys.keyOngoing.localized;
    case 'SUCCESS':
      return LocaleKeys.keySuccess.localized;
    case 'UPCOMING':
      return LocaleKeys.keyUpcoming.localized;
    case 'DEBIT':
      return LocaleKeys.keyDebit.localized;
    case 'CREDIT':
      return LocaleKeys.keyCredit.localized;
    case 'ALL':
      return LocaleKeys.keyAll.localized;
    case 'ACKNOWLEDGED':
      return LocaleKeys.keyAcknowledged.localized;
    case 'RESOLVED':
      return LocaleKeys.keyResolved.localized;
    case 'PREMIUM':
      return LocaleKeys.keyPremium.localized;
    case 'FILLER':
      return LocaleKeys.keyFiller.localized;
    case 'PARTIAL':
      return LocaleKeys.keyPartial.localized;
    case 'HALF':
      return LocaleKeys.keyHalf.localized;
    case 'FULL':
      return LocaleKeys.keyFull.localized;
    case 'IMAGE':
      return LocaleKeys.keyImage.localized;
    case 'VIDEO':
      return LocaleKeys.keyVideo.localized;
    default:
      return '';
  }
}

String getMaskedWalletBalance(int? walletBalance) {
  if (walletBalance == null) return 'X';
  final digitsOnly = walletBalance.toString().replaceAll(RegExp(r'\D'), '');
  return 'X' * digitsOnly.length;
}

List<ShowTitleModel> monthDynamicList = [
  ShowTitleModel(value: MonthEnum.Jan.name,showTitle: 'Jan'),
  ShowTitleModel(value: MonthEnum.Feb.name,showTitle: 'Feb'),
  ShowTitleModel(value: MonthEnum.Mar.name,showTitle: 'Mar'),
  ShowTitleModel(value: MonthEnum.April.name,showTitle: 'April'),
  ShowTitleModel(value: MonthEnum.May.name,showTitle: 'May'),
  ShowTitleModel(value: MonthEnum.June.name,showTitle: 'June'),
  ShowTitleModel(value: MonthEnum.July.name,showTitle: 'July'),
  ShowTitleModel(value: MonthEnum.Aug.name,showTitle: 'Aug'),
  ShowTitleModel(value: MonthEnum.Sep.name,showTitle: 'Sep'),
  ShowTitleModel(value: MonthEnum.Oct.name,showTitle: 'Oct'),
  ShowTitleModel(value: MonthEnum.Nov.name,showTitle: 'Nov'),
  ShowTitleModel(value: MonthEnum.Dec.name,showTitle: 'Dec')

];

int getMonthNumber(String val) {
  final index = monthDynamicList.indexWhere((month) => month.value == val);
  return index != -1 ? index + 1 : 0; // Return 0 if not found
}

/// years
int numPreviousYears = DateTime.now().year - DateTime(2023).year;

List<int> getDaysList(dynamic month) {
  print('-----$month');
  // Normalize string input to lowercase
  if (month is String) {
    month = month.toLowerCase();
  }
  print('-----$month small');

  /// Map of short and full month names to numbers
  final Map<String, int> monthMap = {
    'jan': 1, 'january': 1,
    'feb': 2, 'february': 2,
    'mar': 3, 'march': 3,
    'apr': 4, 'april': 4,
    'may': 5,
    'jun': 6, 'june': 6,
    'jul': 7, 'july': 7,
    'aug': 8, 'august': 8,
    'sep': 9, 'september': 9,
    'oct': 10, 'october': 10,
    'nov': 11, 'november': 11,
    'dec': 12, 'december': 12,
  };

  int? monthNumber;

  if (month is int) {
    monthNumber = month;
  } else if (month is String && monthMap.containsKey(month)) {
    monthNumber = monthMap[month];
  } else {
    throw ArgumentError('Invalid month value: $month');
  }

  final int year = DateTime.now().year;

  final firstDayOfNextMonth = (monthNumber == 12)
      ? DateTime(year + 1, 1, 1)
      : DateTime(year, (monthNumber??0) + 1, 1);

  final lastDayOfMonth = firstDayOfNextMonth.subtract(Duration(days: 1));
  int totalDays = lastDayOfMonth.day;

  return List<int>.generate(totalDays, (index) => index + 1);
}


String getLocalizedWeekDays(String day) {
  switch (day) {
    case 'Monday':
      return LocaleKeys.keyMondayS.localized;
    case 'Tuesday':
      return LocaleKeys.keyTuesdayS.localized;
    case 'Wednesday':
      return LocaleKeys.keyWednesdayS.localized;
    case 'Thursday':
      return LocaleKeys.keyThursdayS.localized;
    case 'Friday':
      return LocaleKeys.keyFridayS.localized;
    case 'Saturday':
      return LocaleKeys.keySaturdayS.localized;
    case 'Sunday':
      return LocaleKeys.keySundayS.localized;
    case 'Mo':
      return LocaleKeys.keyMo.localized;
    case 'Tu':
      return LocaleKeys.keyTu.localized;
    case 'We':
      return LocaleKeys.keyWe.localized;
    case 'Th':
      return LocaleKeys.keyTh.localized;
    case 'Fr':
      return LocaleKeys.keyFr.localized;
    case 'Sa':
      return LocaleKeys.keySa.localized;
    case 'Su':
      return LocaleKeys.keySu.localized;
    case 'Mon':
      return LocaleKeys.keyMon.localized;
    case 'Tue':
      return LocaleKeys.keyTue.localized;
    case 'Wed':
      return LocaleKeys.keyWed.localized;
    case 'Thu':
      return LocaleKeys.keyThu.localized;
    case 'Fri':
      return LocaleKeys.keyFri.localized;
    case 'Sat':
      return LocaleKeys.keySat.localized;
    case 'Sun':
      return LocaleKeys.keySun.localized;
    default:
      return day; // fallback to the original if no match found
  }
}

String getLocalizedMonth(String month) {
  switch (month) {
    case 'Jan':
      return LocaleKeys.keyJan.localized;
    case 'January':
      return LocaleKeys.keyJanuary.localized;
    case 'Feb':
      return LocaleKeys.keyFeb.localized;
    case 'February':
      return LocaleKeys.keyFebruary.localized;
    case 'March':
      return LocaleKeys.keyMarch.localized;
    case 'April':
      return LocaleKeys.keyApril.localized;
    case 'May':
      return LocaleKeys.keyMay.localized;
    case 'June':
      return LocaleKeys.keyJune.localized;
    case 'July':
      return LocaleKeys.keyJuly.localized;
    case 'August':
      return LocaleKeys.keyAugust.localized;
    case 'Sept':
      return LocaleKeys.keySept.localized;
    case 'September':
      return LocaleKeys.keySeptember.localized;
    case 'Oct':
      return LocaleKeys.keyOct.localized;
    case 'October':
      return LocaleKeys.keyOctober.localized;
    case 'Nov':
      return LocaleKeys.keyNov.localized;
    case 'November':
      return LocaleKeys.keyNovember.localized;
    case 'Dec':
      return LocaleKeys.keyDec.localized;
    case 'December':
      return LocaleKeys.keyDecember.localized;
    case ('jan' || 'Jan'):
      return LocaleKeys.keyJan.localized;
    case ('feb' || 'Feb'):
      return LocaleKeys.keyFeb.localized;
    case ('mar' || 'Mar'):
      return LocaleKeys.keyMar.localized;
    case ('apr' || 'Apr'):
      return LocaleKeys.keyApril.localized;
    case ('jun' || 'Jun'):
      return LocaleKeys.keyJune.localized;
    case ('may' || 'Mar'):
      return LocaleKeys.keyMay.localized;
    case ('jul' || 'Jul'):
      return LocaleKeys.keyJuly.localized;
    case ('aug' || 'Aug'):
      return LocaleKeys.keyAug.localized;
    case ('sep' || 'Sep'):
      return LocaleKeys.keySep.localized;
    case ('oct' || 'Oct'):
      return LocaleKeys.keyOct.localized;
    case ('nov' || 'Nov'):
      return LocaleKeys.keyNov.localized;
    case ('dec' || 'Dec'):
      return LocaleKeys.keyDec.localized;
    default:
      return month; // fallback to the original if no match found
  }
}

bool isDateRangeThisWeek(DateTime? startDate, DateTime? endDate) {
  if (startDate == null || endDate == null) return false;

  final DateTime now = DateTime.now();
  final DateTime today = DateTime(now.year, now.month, now.day);
  final DateTime sixDaysAgo = today.subtract(const Duration(days: 6));

  // Compare dates (ignoring time)
  final DateTime normalizedStart = DateTime(startDate.year, startDate.month, startDate.day);
  final DateTime normalizedEnd = DateTime(endDate.year, endDate.month, endDate.day);

  return normalizedStart == sixDaysAgo && normalizedEnd == today;
}