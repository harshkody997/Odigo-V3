import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class CommonDashboardUptimePercentageContainer extends StatelessWidget {
  final String text;
  final String subText;
  final Color color;

  const CommonDashboardUptimePercentageContainer({super.key, required this.text, required this.color, required this.subText});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: color),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: EdgeInsets.symmetric(horizontal: context.width * 0.005, vertical: context.height * 0.005),
          child: CommonText(
            title: text,
            style: TextStyles.medium.copyWith(color: AppColors.clr080808),
          ),
        ),
        SizedBox(height: context.height * 0.005),
        CommonText(
          title: subText,
          style: TextStyles.medium.copyWith(color: AppColors.clr878787),
        ),
      ],
    );
  }
}
