import 'package:flutter/material.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class LanguageShimmer extends StatelessWidget {
  const LanguageShimmer({super.key});
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      enabled: true,
      child: Container(
        width: 150,
        height:40,
        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8)), color: AppColors.white),
      ).paddingOnly(bottom: 30)
    );
  }
}
