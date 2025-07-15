import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/ui/drawer/web/base_drawer_page_widget.dart';
import 'package:odigov3/ui/purchase/web/helper/change_ads_button_widget.dart';
import 'package:odigov3/ui/purchase/web/helper/change_ads_table_widget.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';

class ChangeAdsWeb extends StatelessWidget {
  final String? purchaseUuid;
  final String? clientUuid;
  const ChangeAdsWeb({super.key, this.purchaseUuid,this.clientUuid});

  ///Build Override
  @override
  Widget build(BuildContext context) {
    return BaseDrawerPageWidget(
      body: Column(
        children: [
          ///Change Ads Table Widget
          ChangeAdsTableWidget(purchaseUuid: purchaseUuid,clientUuid: clientUuid,),
          SizedBox(height: context.height * 0.03),
          ///Button Widget
          ChangeAdsButtonWidget(purchaseUuid: purchaseUuid,clientUuid: clientUuid,)
        ],
      ),
    );
  }
}
