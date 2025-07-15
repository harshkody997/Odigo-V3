import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_switch_widget.dart';
import 'package:odigov3/ui/utils/widgets/common_table_value_widget.dart';

class CountryListTileWidget extends StatelessWidget {
  final GestureTapCallback? onEditTap;
  /// TODO During api integration make & pass CountryModel constructor
  const CountryListTileWidget({super.key, this.onEditTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Table(
            textDirection: TextDirection.ltr,
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            columnWidths: const {
              0: FlexColumnWidth(1), /// switch
              1: FlexColumnWidth(3), /// country name
              2: FlexColumnWidth(2), /// code
              3: FlexColumnWidth(6), /// currency
              // 4: FlexColumnWidth(6), /// time zone
            },
            children: [
              TableRow(
                  children: [
                CommonCupertinoSwitch(switchValue: true, onChanged: (value){}).alignAtCenterLeft(),
                Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.black
                      ),
                    ).paddingOnly(right: 12),
                    CommonTableValueWidget(valueText: 'India',),
                  ],
                ),
                CommonTableValueWidget(valueText: '+91',),
                CommonTableValueWidget(valueText: 'Rupee',),
                    Container(
                      child: InkWell(
                        onTap: onEditTap,
                        child: CommonSVG(
                          strIcon: Assets.svgs.svgEdit2.keyName,
                        ).alignAtCenterRight(),
                      ),
                    )

              ]),
            ],
          ).paddingSymmetric(horizontal: 23,vertical: 14),
        ),
        Divider(color: AppColors.clrEAECF0,height: 1,)
      ],
    );
  }
}
