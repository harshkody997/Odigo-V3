import 'package:flutter/material.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/widgets/common_check_box.dart';

class CommonViewRolePermissionCheckbox extends StatelessWidget {
  final bool? status;
  const CommonViewRolePermissionCheckbox({super.key, this.status});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: AbsorbPointer(
        absorbing: true,
        child: Container(
            alignment: AlignmentDirectional.centerEnd,
            child: CommonCheckBox(
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4), /// to reduce all padding
              checkBoxSize : context.height * 0.0015,
              checkValue: status ?? false ,onChanged: (bool? value) {  },)),
      ),
    );
  }
}
