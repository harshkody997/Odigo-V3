import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/client/client_details_controller.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/ui/client/web/helper/ads_list_table.dart';
import 'package:odigov3/ui/client/web/helper/client_details_tab.dart';
import 'package:odigov3/ui/client/web/helper/document_table.dart';
import 'package:odigov3/ui/client/web/helper/purchase_history_table.dart';
import 'package:odigov3/ui/client/web/helper/tab_buttons.dart';
import 'package:odigov3/ui/client/web/helper/wallet_history_table.dart';
import 'package:odigov3/ui/drawer/web/base_drawer_page_widget.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_anim_loader.dart';

class ClientDetailsWeb extends ConsumerWidget {
  final String? clientUuid;

  const ClientDetailsWeb({Key? key, this.clientUuid}) : super(key: key);

  ///Build Override
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clientDetailsWatch = ref.watch(clientDetailsController);
    return Scaffold(
      body: BaseDrawerPageWidget(
        body: clientDetailsWatch.clientDetailsState.isLoading
            ? CommonAnimLoader()
            : Column(
          children: [
            /// Title data
            ClientDetailsTab(),

            /// Tab controls
            Expanded(
              child: Container(
                decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(8)),
                child: Column(
                  children: [
                    /// Robot store tab controller
                    TabButtonsRow(clientUuid: clientUuid),
                    SizedBox(height: 25),

                    Expanded(
                      child: clientDetailsWatch.selectedTab == 0
                          ? AdsListTable(clientUuid: clientUuid??'')
                          : (clientDetailsWatch.selectedTab == 1)
                          ? PurchaseHistoryTable(clientUuid: clientUuid)
                          : (clientDetailsWatch.selectedTab == 2)
                          ? WalletHistoryTable(clientUuid: clientUuid)
                          : DocumentTable(clientUuid: clientUuid??''),
                    ),
                  ],
                ).paddingSymmetric(vertical: 18, horizontal: 27),
              ).paddingOnly(top: 30),
            ),
          ],
        ),
      ),
    );
  }
}
