import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:shimmer/shimmer.dart';

class SettingsShimmer extends StatelessWidget {
  const SettingsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Shimmer.fromColors(
        baseColor: AppColors.shimmerBaseColor,
        highlightColor: AppColors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: context.height * 0.54,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: AppColors.white),
            ),
            SizedBox(height: context.height * 0.03),
            Container(
              height: context.height * 0.15,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: AppColors.white),
            ),
          ],
        ),
      ),
    );
  }
}
