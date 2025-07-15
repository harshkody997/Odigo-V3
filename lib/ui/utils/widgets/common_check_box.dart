import 'package:flutter/material.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';

class CommonCheckBox extends StatelessWidget {
  final bool checkValue;
  /// On changed switch value
  final Function(bool?) onChanged;
  final Color? checkColor;
  final Color? activeColor;
  final Color? borderSideColor;
  final double? borderRadius;
  final double? checkBoxSize;
  final VisualDensity? visualDensity;
  final bool? isDisable;

  const CommonCheckBox({super.key, required this.checkValue, required this.onChanged, this.checkColor, this.activeColor, this.borderSideColor, this.borderRadius, this.checkBoxSize, this.visualDensity, this.isDisable});

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: checkBoxSize??1.05,
      child: AbsorbPointer(
        absorbing: isDisable??false,
        child: Opacity(
          opacity: isDisable??false?0.5:1,
          child: Checkbox(
            value: checkValue,
            onChanged: onChanged,
            checkColor: checkColor??AppColors.white,
            activeColor: activeColor??AppColors.clr2997FC,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius??5),
            ),
            side: BorderSide(
                color: borderSideColor??AppColors.clrD8DAE5,
            ),
            visualDensity: visualDensity ??  VisualDensity(horizontal: -1, vertical: 1),
          ),
        ),
      ),
    );
  }
}
