import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/client/add_update_client_controller.dart';
import 'package:odigov3/framework/controller/client/client_details_controller.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/repository/dashboard/model/sidemenu_list_response_model.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/client/web/helper/settle_wallet_form_widget_web.dart';
import 'package:odigov3/ui/routing/navigation_stack_item.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';
import 'package:odigov3/ui/utils/widgets/common_dialog.dart';

class TabButtonsRow extends ConsumerWidget {
  final String? clientUuid;
  const TabButtonsRow({super.key, this.clientUuid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clientDetailsWatch = ref.watch(clientDetailsController);
    SidebarModel? selectedMainScreen = ref.read(drawerController).selectedMainScreen;

    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              /// Ads List Tab Button
              Flexible(
                child: CommonButton(
                  buttonText: LocaleKeys.keyAdsList.localized,
                  backgroundColor: clientDetailsWatch.selectedTab == 0 ? AppColors.clr2997FC : AppColors.white,
                  borderColor: clientDetailsWatch.selectedTab == 0 ? AppColors.clr2997FC : AppColors.clrE0E0E0,
                  width: context.width * 0.10,
                  buttonTextStyle: TextStyles.medium.copyWith(
                    color: clientDetailsWatch.selectedTab == 0 ? AppColors.white : AppColors.clrE0E0E0,
                    fontSize: 12,
                  ),
                  height: context.height * 0.06,
                  onTap: () {
                    clientDetailsWatch.updateSelectedTab(0);
                  },
                ),
              ),
              SizedBox(width: 18),

              /// Purchase History Tab Button
              Flexible(
                child: CommonButton(
                  buttonText: LocaleKeys.keyPurchaseHistory.localized,
                  backgroundColor: clientDetailsWatch.selectedTab == 1 ? AppColors.clr2997FC : AppColors.white,
                  borderColor: clientDetailsWatch.selectedTab == 1 ? AppColors.clr2997FC : AppColors.clrE0E0E0,
                  width: context.width * 0.1,
                  height: context.height * 0.06,
                  buttonTextStyle: TextStyles.medium.copyWith(
                    color: clientDetailsWatch.selectedTab == 1 ? AppColors.white : AppColors.clrE0E0E0,
                    fontSize: 12,
                  ),
                  onTap: () async {
                    clientDetailsWatch.updateSelectedTab(1);
                  },
                ),
              ),
              SizedBox(width: 18),

              /// Wallet History Tab Button
              Flexible(
                child: CommonButton(
                  buttonText: LocaleKeys.keyWalletHistory.localized,
                  backgroundColor: clientDetailsWatch.selectedTab == 2 ? AppColors.clr2997FC : AppColors.white,
                  borderColor: clientDetailsWatch.selectedTab == 2 ? AppColors.clr2997FC : AppColors.clrE0E0E0,
                  width: context.width * 0.1,
                  height: context.height * 0.06,
                  buttonTextStyle: TextStyles.medium.copyWith(
                    color: clientDetailsWatch.selectedTab == 2 ? AppColors.white : AppColors.clrE0E0E0,
                    fontSize: 12,
                  ),
                  onTap: () {
                    clientDetailsWatch.updateSelectedTab(2);
                  },
                ),
              ),
              SizedBox(width: 18),

              /// Documents Tab Button
              Flexible(
                child: CommonButton(
                  buttonText: LocaleKeys.keyDocuments.localized,
                  backgroundColor: clientDetailsWatch.selectedTab == 3 ? AppColors.clr2997FC : AppColors.white,
                  borderColor: clientDetailsWatch.selectedTab == 3 ? AppColors.clr2997FC : AppColors.clrE0E0E0,
                  width: context.width * 0.1,
                  height: context.height * 0.06,
                  buttonTextStyle: TextStyles.medium.copyWith(
                    color: clientDetailsWatch.selectedTab == 3 ? AppColors.white : AppColors.clrE0E0E0,
                    fontSize: 12,
                  ),
                  onTap: () {
                    clientDetailsWatch.updateSelectedTab(3);
                  },
                ),
              ),
            ],
          ),
        ),

        if (clientDetailsWatch.selectedTab == 0)
          /// Ads List Tab Button
          CommonButton(
            buttonText: '+ ${LocaleKeys.keyAddADS.localized}',
            width: context.width * 0.10,
            buttonTextStyle: TextStyles.medium.copyWith(
              color: clientDetailsWatch.selectedTab == 0 ? AppColors.white : AppColors.clrE0E0E0,
              fontSize: 12,
            ),
            height: context.height * 0.06,
            onTap: () {
              ref.read(navigationStackController).push(NavigationStackItemCreateAdsClientPage(isFromDetailsScreen: true));
            },
          )
        else if (clientDetailsWatch.selectedTab == 1)
          /// Create Purchase Tab Button
          CommonButton(
            buttonText: '+ ${LocaleKeys.keyPurchase.localized}',
            width: context.width * 0.10,
            buttonTextStyle: TextStyles.medium.copyWith(
              color: clientDetailsWatch.selectedTab == 1 ? AppColors.white : AppColors.clrE0E0E0,
              fontSize: 12,
            ),
            height: context.height * 0.06,
            onTap: () {
              ref.read(navigationStackController).push(NavigationStackItem.addPurchase(clientUuid: clientUuid));
            },
          )
        else if (clientDetailsWatch.selectedTab == 2 && (selectedMainScreen?.canEdit??false) && ((clientDetailsWatch.clientDetailsState.success?.data?.wallet??0)>0))
          /// Create Purchase Tab Button
            CommonButton(
              buttonText:LocaleKeys.keySettleWallet.localized,
              width: context.width * 0.10,
              buttonTextStyle: TextStyles.medium.copyWith(
                color: clientDetailsWatch.selectedTab == 1 ? AppColors.white : AppColors.clrE0E0E0,
                fontSize: 12,
              ),
              height: context.height * 0.06,
              onTap: () {
                ref.read(navigationStackController).push(NavigationStackItem.settleClientWallet(clientUuid: clientUuid));
              },
            )
        else if (clientDetailsWatch.selectedTab == 3 && (ref.watch(addUpdateClientController).isVisibleAddButton))
          /// Add New Document Tab Button
          CommonButton(
            buttonText: LocaleKeys.keyAddNew.localized,
            width: context.width * 0.10,
            buttonTextStyle: TextStyles.medium.copyWith(
              color: clientDetailsWatch.selectedTab == 3 ? AppColors.white : AppColors.clrE0E0E0,
              fontSize: 12,
            ),
            height: context.height * 0.06,
            onTap: () {
              ref.read(navigationStackController).push(NavigationStackItem.uploadDocument(clientUuid: clientUuid));
            },
          ),
      ],
    );
  }
}
