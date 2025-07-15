import 'package:flutter/material.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';

/// Common Shimmer Widget
class CommonAuthBackground extends StatelessWidget  {
  const CommonAuthBackground(
      {super.key,
         this.height,
        required this.width,
        this.borderRadius,
        this.decoration,
        required this.content
      });

  final double? height;
  final double width;
  final BorderRadiusGeometry? borderRadius;
  final Decoration? decoration;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        width: width,
      child: content,
      padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 34),
        decoration: decoration ??
            BoxDecoration(
              color: AppColors.white,
              borderRadius: borderRadius ?? BorderRadius.circular(12), // From Figma
              border: Border.all(color: AppColors.greyD6D6D6, width: 1.18),
            ),
      );

  }
}
