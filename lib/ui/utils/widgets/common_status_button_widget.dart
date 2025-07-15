import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/utils/app_enums.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class CommonStatusButton extends StatelessWidget {
  final String status;
  final double? height;
  final double? width;
  final double? fontSize;
  final Color? filledBgColor;
  final Color? textColor;
  final String? statusText;
  final TextStyle? buttonTextStyle;
  final String? iconName;
  final bool? dotRequired;
  final double? imagePadding;

  const CommonStatusButton({Key? key, required this.status, this.imagePadding,this.height, this.width, this.fontSize, this.filledBgColor, this.textColor, this.statusText, this.buttonTextStyle,this.iconName,this.dotRequired}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    OrderStatusThemeModel theme = getStatusButtonTheme();
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color:filledBgColor?? theme.backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          iconName?.isNotEmpty??false?CommonSVG(
            strIcon: iconName??'',
          ).paddingOnly(right: imagePadding??0):const Offstage(),
          dotRequired??false?
              Container(height:7,width:7,decoration: BoxDecoration(shape: BoxShape.circle,color: theme.textColor),).paddingOnly(right: 6):const Offstage(),
          Flexible(
            child: CommonText(
              title: statusText??theme.text??'',
              style: buttonTextStyle??TextStyles.medium.copyWith(
                fontSize: fontSize ?? 13,
                color: textColor??theme.textColor,
              ),
              maxLines: 2,
            ),
          ),
        ],
      ).paddingOnly(left: context.width*0.009,right: context.width*0.009,top: 4,bottom: 4),
    );
  }

  OrderStatusThemeModel getStatusButtonTheme() {
    Color backgroundColor;
    Color textColor;
    String? text;
    switch (statusEnumValues.map[status]) {
      case TransactionsType.CREDIT:
        backgroundColor = AppColors.clrECFDF3;
        textColor = AppColors.clr027A48;
        text = LocaleKeys.keyCredit.localized;
        break;
      case TransactionsType.DEBIT:
        backgroundColor = AppColors.clrFEF3F2;
        textColor = AppColors.clrB42318;
        text = LocaleKeys.keyDebit.localized;
        break;
      case StatusEnum.PAID:
        backgroundColor = AppColors.clrECFDF3;
        textColor = AppColors.clr027A48;
        text = LocaleKeys.keyPaid.localized;
        break;
      case StatusEnum.CANCELLED:
        backgroundColor = AppColors.clrFEF3F2;
        textColor = AppColors.clrB42318;
        text = LocaleKeys.keyCancelled.localized;

        break;
      case StatusEnum.PENDING:
        backgroundColor = AppColors.clrFFFAEB;
        textColor = AppColors.clrB54708;
        text = LocaleKeys.keyPending.localized;

        break;
      case StatusEnum.ONGOING:
        backgroundColor = AppColors.clrF9F5FF;
        textColor = AppColors.clr6941C6;
        text = LocaleKeys.keyOngoing.localized;
        break;
      case StatusEnum.COMPLETED:
        backgroundColor = AppColors.clr12B76A;
        textColor = AppColors.clr12B76A;
        text = LocaleKeys.keyCompleted.localized;
        break;
      case StatusEnum.APPROVED:
        backgroundColor = AppColors.clr12B76A;
        textColor = AppColors.clr12B76A;
        text = LocaleKeys.keyApproved.localized;
        break;
      case StatusEnum.UPCOMING:
        backgroundColor = AppColors.clrB42318;
        textColor = AppColors.clrFEF3F2;
        text = LocaleKeys.keyUpcoming.localized;
        break;
      case StatusEnum.REJECTED:
        backgroundColor = AppColors.clrFEF3F2;
        textColor = AppColors.clrB42318;
        text = LocaleKeys.keyRejected.localized;
        break;
      case StatusEnum.ACKNOWLEDGED:
        backgroundColor = AppColors.clrB42318;
        textColor = AppColors.clrFEF3F2;
        text = LocaleKeys.keyAcknowledged.localized;
        break;
      case TicketStatus.RESOLVED:
        backgroundColor = AppColors.clrECFDF3;
        textColor = AppColors.clr12B76A;
        text = LocaleKeys.keyResolved.localized;
        break;
      case StatusEnum.PARTIALY_FAILED:
        backgroundColor = AppColors.clrFCF2FE;
        textColor = AppColors.clr9704B1;
        text = LocaleKeys.keyPartiallyFailed.localized;
        break;
      case StatusEnum.INPROCESS:
        backgroundColor = AppColors.clr2997FC.withValues(alpha: 0.1);
        textColor = AppColors.clr3E8BFF;
        text = LocaleKeys.keyInProcess.localized;
        break;
      case StatusEnum.FAILED:
        backgroundColor = AppColors.clrFEF3F2;
        textColor = AppColors.clrB42318;
        text = LocaleKeys.keyFailed.localized;
        break;
      default:
        backgroundColor = AppColors.grey7D7D7D;
        textColor = AppColors.black;
        break;
    }
    return OrderStatusThemeModel(backgroundColor: backgroundColor,textColor: textColor,text: text);
  }
}

class OrderStatusThemeModel {
  Color backgroundColor;
  Color textColor;
  String? text;

  OrderStatusThemeModel({required this.backgroundColor, required this.textColor,this.text});
}