import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class PurchaseStatusWidget extends ConsumerWidget {
  final String status;

  const PurchaseStatusWidget({super.key, required this.status});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String statusText = '';
    Color statusColor = AppColors.clr12B76A;
    Color bgColor = AppColors.clrECFDF3;
    switch (status) {
      case 'COMPLETED':
        statusText = LocaleKeys.keyCompleted.localized;
        statusColor = AppColors.clr12B76A;
        bgColor = AppColors.clrECFDF3;
        break;
      case 'UPCOMING':
        statusText = LocaleKeys.keyUpcoming.localized;
        statusColor = AppColors.clrB54708;
        bgColor = AppColors.clrFFFAEB;
        break;
      case 'CANCELLED':
        statusText = LocaleKeys.keyCancelled.localized;
        statusColor = AppColors.clrB42318;
        bgColor = AppColors.clrFEF3F2;
        break;
      case 'ONGOING':
        statusText = LocaleKeys.keyOngoing.localized;
        statusColor = AppColors.clr6941C6;
        bgColor = AppColors.clrF9F5FF;
        break;
      default:
        break;
    }
    return Container(
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(20)),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          Container(
            height: 10,
            width: 10,
            decoration: BoxDecoration(shape: BoxShape.circle, color: statusColor),
          ),
          SizedBox(width: 5),
          CommonText(
            title: statusText,
            style: TextStyles.medium.copyWith(fontSize: 12, color: statusColor),
            maxLines: 10,
          ),
        ],
      ),
    );
  }
}
