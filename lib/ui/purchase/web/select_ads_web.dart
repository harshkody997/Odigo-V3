import 'package:flutter/material.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/drawer/web/base_drawer_page_widget.dart';
import 'package:odigov3/ui/purchase/web/helper/change_ads_table_widget.dart';
import 'package:odigov3/ui/purchase/web/helper/select_ads_button_widget.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';


class SelectAdsWeb extends StatelessWidget {
  final String? clientUuid;
  const SelectAdsWeb({super.key,this.clientUuid});

  ///Build Override
  @override
  Widget build(BuildContext context) {
    return BaseDrawerPageWidget(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText(
            title: '${LocaleKeys.keyNote.localized}: ${LocaleKeys.keyMinimumAndMaximumAds.localized}',
            fontWeight: TextStyles.fwMedium,
          ).paddingOnly(bottom: 10),
          ///Change Ads Table Widget
          ChangeAdsTableWidget(clientUuid: clientUuid,),
          SizedBox(height: context.height * 0.03),
          ///Button Widget
          SelectAdsButtonWidget(clientUuid: clientUuid)
        ],
      ),
    );
  }
}
