import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/device/device_controller.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/ui/destination_details/web/helper/destination_details_tab.dart';
import 'package:odigov3/ui/destination_details/web/helper/floor_module_table.dart';
import 'package:odigov3/ui/destination_details/web/helper/price_history_table.dart';
import 'package:odigov3/ui/destination_details/web/helper/robot_module_table.dart';
import 'package:odigov3/ui/destination_details/web/helper/store_module_table.dart';
import 'package:odigov3/ui/destination_details/web/helper/tab_buttons.dart';
import 'package:odigov3/ui/drawer/web/base_drawer_page_widget.dart';
import 'package:odigov3/ui/routing/navigation_stack_item.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_anim_loader.dart';
import 'package:odigov3/framework/controller/destination/destination_details_controller.dart';

class DestinationDetailsWeb extends ConsumerStatefulWidget {
  const DestinationDetailsWeb({Key? key}) : super(key: key);

  @override
  ConsumerState<DestinationDetailsWeb> createState() => _DestinationDetailsWebState();
}

class _DestinationDetailsWebState extends ConsumerState<DestinationDetailsWeb> {
  ///Build Override
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _bodyWidget());
  }

  ///Body Widget
  Widget _bodyWidget() {
    final destinationDetailsWatch = ref.watch(destinationDetailsController);
    final deviceWatch = ref.watch(deviceController);
    return BaseDrawerPageWidget(
      emergencyModeValue: true,
      showMoreInfo: true,
      moreInfoOnTap: () {
        ref.read(navigationStackController).push(NavigationStackItem.destinationDetailsInfo());
      },
      body: destinationDetailsWatch.destinationDetailsState.isLoading || destinationDetailsWatch.storeListState.isLoading  || destinationDetailsWatch.priceHistoryState.isLoading || deviceWatch.deviceListState.isLoading ?
          CommonAnimLoader()
          :Column(
        children: [
          /// Title data
          DestinationDetailsTab().paddingOnly(top: 14,left: 14,right: 14),

          /// Tab controls
          Expanded(
            child: Container(
              decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(8)),
              child: Column(
                children: [
                  ///robot store tab controller
                  TabButtonsRow(),
                  SizedBox(height: 25),


                  Expanded(child:destinationDetailsWatch.selectedTab == 0
                      ? RobotModuleTable()
                      : destinationDetailsWatch.selectedTab == 1
                        ? StoreModuleTable()
                        : destinationDetailsWatch.selectedTab == 3
                          ? FloorModuleTable()
                          : PriceHistoryTable()
                  ),
                ],
              ).paddingSymmetric(vertical: 18, horizontal: 27),
            ).paddingOnly(top: 30),
          ),
        ],
      ),
    );
  }
}
