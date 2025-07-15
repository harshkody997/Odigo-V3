import 'package:flutter/material.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';

class CommonDashboardContainer extends StatefulWidget {
  final Widget child;
  final Color? color;
  final bool isSelected;
  final Function? onTap;

  const CommonDashboardContainer({super.key, required this.child, this.color, this.isSelected = true, this.onTap});

  @override
  State<CommonDashboardContainer> createState() => _CommonDashboardContainerState();
}

class _CommonDashboardContainerState extends State<CommonDashboardContainer> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    if (!widget.isSelected) {
      return MouseRegion(
        onEnter: (event) {
          setState(() {
            isHovered = true;
          });
        },
        onExit: (event) {
          setState(() {
            isHovered = false;
          });
        },

        child: InkWell(
          onTap: () {
            isHovered = false;
            setState(() {});
            widget.onTap?.call();
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.transparent,
              border: Border.all(color: isHovered ? AppColors.black.withValues(alpha: 0.1) : AppColors.transparent),
            ),
            child: widget.child,
          ),
        ),
      );
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColors.white),
      child: widget.child,
    );
  }
}
