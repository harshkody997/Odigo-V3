import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class AdsStatusWidget extends ConsumerWidget {
  final String status;
  const AdsStatusWidget({super.key, required this.status});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String statusText = '';
    Color statusColor = AppColors.clr12B76A;
    Color bgColor = AppColors.clrECFDF3;
    switch (status) {
      case 'PENDING':
        statusText = LocaleKeys.keyPending.localized;
        statusColor = AppColors.clrF79009;
        bgColor = AppColors.clrFFFAEB;
        break;
      case 'REJECTED':
        statusText = LocaleKeys.keyRejected.localized;
        statusColor = AppColors.clrF04438;
        bgColor = AppColors.clrFEF3F2;
        break;
      case 'ACTIVE':
        statusText = LocaleKeys.keyActive.localized;
        statusColor = AppColors.clr12B76A;
        bgColor = AppColors.clrECFDF3;
        break;
      case 'INACTIVE':
        statusText = LocaleKeys.keyInActive.localized;
        statusColor = AppColors.clrF04438;
        bgColor = AppColors.clrFEF3F2;
        break;
      default:
        break;
    }
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20)
      ),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          Container(
            height: 10,
            width: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: statusColor
            ),
          ),
          SizedBox(width: 5,),
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
