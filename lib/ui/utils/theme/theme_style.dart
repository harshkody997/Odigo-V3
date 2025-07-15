import 'package:odigov3/ui/utils/theme/theme.dart';

class ThemeStyle {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      fontFamily: TextStyles.fontFamily,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.scaffoldBGByTheme(),
      hoverColor: Colors.transparent,
      hintColor: AppColors.grey8D8C8C,
      primarySwatch: AppColors.colorPrimary,
      textTheme: Theme.of(context).textTheme.apply(bodyColor: AppColors.textByTheme()),
      splashColor: AppColors.transparent,
      highlightColor: AppColors.transparent,
      appBarTheme: AppBarTheme(elevation: 0.0, backgroundColor: AppColors.scaffoldBGByTheme()),
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: AppColors.colorPrimary,
      ).copyWith(background: AppColors.scaffoldBGByTheme()),
    );
  }
}
