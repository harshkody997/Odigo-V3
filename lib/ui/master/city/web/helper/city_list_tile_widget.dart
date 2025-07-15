import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_switch_widget.dart';
import 'package:odigov3/ui/utils/widgets/common_table_value_widget.dart';

class CityListTileWidget extends StatelessWidget {
  final GestureTapCallback? onEditTap;
  /// TODO During api integration make & pass CityModel constructor
  const CityListTileWidget({super.key, this.onEditTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.lightPinkF7F7FC
      ),
      child: Table(
        textDirection: TextDirection.ltr,
        columnWidths: const {
          0: FlexColumnWidth(1), /// switch
          1: FlexColumnWidth(2), /// country name
          2: FlexColumnWidth(2), /// state name
          3: FlexColumnWidth(6), /// city name
          4: FlexColumnWidth(1), /// edit
        },
        children: [
          TableRow(children: [
            CommonCupertinoSwitch(switchValue: true, onChanged: (value){}).alignAtCenterLeft(),
            CommonTableValueWidget(valueText: 'India',),
            CommonTableValueWidget(valueText: 'Gujarat',),
            CommonTableValueWidget(valueText: 'Ahmedabad',),
            Container(
              child: InkWell(
                onTap: onEditTap,
                child: CommonSVG(
                  strIcon: Assets.svgs.svgEdit2.keyName,
                ).alignAtCenter(),
              ),
            )
          ]),
        ],
      ).paddingSymmetric(horizontal: 23,vertical: 20),
    );
  }
}
