import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/client/client_details_controller.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/client/web/helper/settle_wallet_bottom_widget_web.dart';
import 'package:odigov3/ui/client/web/helper/settle_wallet_form_widget_web.dart';
import 'package:odigov3/ui/drawer/web/base_drawer_page_widget.dart';
import 'package:odigov3/ui/error/error_404.dart';
import 'package:odigov3/ui/utils/app_enums.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/theme/text_style.dart';
import 'package:odigov3/ui/utils/widgets/common_anim_loader.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class SettleWalletWeb extends StatelessWidget {
  final String clientUuid;
  const SettleWalletWeb({super.key,required this.clientUuid});

  ///Build:- This method will trigger when widget is build.
  @override
  Widget build(BuildContext context) {
    return _bodyWidget();
  }

  ///This method is responsible for returning the body widget
  Widget _bodyWidget() {
    return Consumer(
      builder: (context,ref,child) {
        final clientDetailsWatch = ref.watch(clientDetailsController);
        return BaseDrawerPageWidget(
            isApiLoading:clientDetailsWatch.settleWalletState.isLoading ,
            body: clientDetailsWatch.staticLoader?
            /// Loader
            Center(child: CommonAnimLoader()):
            ( clientDetailsWatch.clientDetailsState.success?.data?.wallet??0) >0 ?
            /// Main Widget
            Stack(
              children: [
                SingleChildScrollView(
                child: Column(
                children: [
                  /// Settle Transaction Form Widget and Title
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Title
                        CommonText(
                          title: LocaleKeys.keySettleWallet.localized,
                          style: TextStyles.semiBold.copyWith(
                            fontSize: 14,
                          ),
                        ).paddingOnly(bottom: 20),
                        /// Form Widget
                        SettleWalletFormWidgetWeb(clientUuid:clientUuid),
                      ],
                    ).paddingAll(20),
                  ),

                  ///Settle transaction bottom button widget
                  SettleWalletBottomWidgetWeb(clientUuid:clientUuid)
                ],
                        ),
              ),
                 /// Loader on add/update api call
                clientDetailsWatch.settleWalletState.isLoading?
                Container(color: AppColors.white.withValues(alpha: 0.8),child: CommonAnimLoader()) : Offstage()
            ],
          ):
          /// Error widget if wallet amount is 0
          Error404(errorType: ErrorType.error404,)
        );
      }
    );
  }
}