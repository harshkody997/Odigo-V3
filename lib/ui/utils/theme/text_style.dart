import 'package:flutter/material.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';

class TextStyles {
  TextStyles._();

  static String fontFamily = 'InstrumentSans';
  static String tertiaryFontFamily = 'Outfit';
  static String secondaryFontFamily = 'Roboto';

  static FontWeight fwThin = FontWeight.w100;
  static FontWeight fwExtraLight = FontWeight.w200;
  static FontWeight fwLight = FontWeight.w300;
  static FontWeight fwRegular = FontWeight.w400;
  static FontWeight fwMedium = FontWeight.w500;
  static FontWeight fwSemiBold = FontWeight.w600;
  static FontWeight fwBold = FontWeight.w700;
  static FontWeight fwExtraBold = FontWeight.w800;

  static TextStyle get thin => TextStyle(
    color: AppColors.textMainFontByTheme(),
    fontSize: 16,
    fontWeight: fwThin,
    fontFamily: fontFamily,
  );

  static TextStyle get extraLight => TextStyle(
    color: AppColors.textMainFontByTheme(),
    fontSize: 16,
    fontWeight: fwExtraLight,
    fontFamily: fontFamily,
  );

  static TextStyle get light => TextStyle(
    color: AppColors.textMainFontByTheme(),
    fontSize: 16,
    fontWeight: fwLight,
    fontFamily: fontFamily,
  );

  static TextStyle get regular => TextStyle(
    color: AppColors.textMainFontByTheme(),
    fontSize: 16,
    fontWeight: fwRegular,
    fontFamily: fontFamily,
  );

  static TextStyle get medium => TextStyle(
    color: AppColors.textMainFontByTheme(),
    fontSize: 16,
    fontWeight: fwMedium,
    fontFamily: fontFamily,
  );

  static TextStyle get semiBold => TextStyle(
    color: AppColors.textMainFontByTheme(),
    fontSize: 16,
    fontWeight: fwSemiBold,
    fontFamily: fontFamily,
  );

  static TextStyle get bold => TextStyle(
    color: AppColors.textMainFontByTheme(),
    fontSize: 16,
    fontWeight: fwBold,
    fontFamily: fontFamily,
  );

  static TextStyle get extraBold => TextStyle(
    color: AppColors.textMainFontByTheme(),
    fontSize: 16,
    fontWeight: fwExtraBold,
    fontFamily: fontFamily,
  );
}
