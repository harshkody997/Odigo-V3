import 'package:flutter/material.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';

class CommonOutlineBox extends StatelessWidget {
  final Widget child;
  final double? borderRadius;
  final Color? borderColor;
  const CommonOutlineBox({super.key,required this.child, this.borderRadius, this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius??10),
        border: BoxBorder.all(
          color: borderColor??AppColors.clrEAECF0,
        ),
      ),
      child: child ,
    );
  }
}
