import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/ads_shown_time/ads_shown_time_controller.dart';
import 'package:odigov3/framework/controller/destination/destination_controller.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/repository/dashboard/model/sidemenu_list_response_model.dart';
import 'package:odigov3/framework/repository/destination/model/destination_details_response_model.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_searchable_dropdown.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class AdsShowTimeDestinationSelectionWidget extends ConsumerWidget {
  const AdsShowTimeDestinationSelectionWidget({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final adsShownTimeWatch = ref.watch(adsShownTimeController);
    SubSidebarData? selectedSubMenu = ref.read(drawerController).selectedSubScreen;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(
          title: LocaleKeys.keyAdsShowTime.localized,
          style: TextStyles.semiBold.copyWith(
              color: AppColors.clr080808,
              fontSize: 14
          ),
        ).paddingOnly(bottom: 32),
        CommonSearchableDropdown<DestinationData>(
          textEditingController: adsShownTimeWatch.selectDestinationCtr,
          hintText: LocaleKeys.keyDestination.localized,
          onSelected: (destination) async{
            adsShownTimeWatch.updateSelectedDestination(destination);
            adsShownTimeWatch.adsShownTimeListApi(context);
          },
          items: ref.watch(destinationController).destinationList,
          title: (value) {
            return value.name ?? '';
          },
          onScrollListener: () async{
            if (!ref.watch(destinationController).destinationListState.isLoadMore && ref.watch(destinationController).destinationListState.success?.hasNextPage == true) {
              ref.watch(destinationController).getDestinationListApi(context,isReset: false,pagination: true,activeRecords: true).then((value) {
                if(ref.read(destinationController).destinationListState.success?.status == ApiEndPoints.apiStatus_200){
                  ref.read(searchController).notifyListeners();
                }
              });
            }
          },
        ).paddingOnly(bottom: 20),
      ],
    );
  }
}
