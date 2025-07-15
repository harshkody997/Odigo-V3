import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/ads_shown_time/ads_shown_time_controller.dart';
import 'package:odigov3/framework/controller/destination/destination_controller.dart';
import 'package:odigov3/framework/repository/common_response/common_enum_title_value_model.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/ads_show_time/web/helper/ads_show_time_destination_selection_widget.dart';
import 'package:odigov3/ui/ads_show_time/web/helper/ads_show_time_list_widget.dart';
import 'package:odigov3/ui/ads_show_time/web/helper/ads_shown_time_list_filter.dart';
import 'package:odigov3/ui/drawer/web/base_drawer_page_widget.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_anim_loader.dart';
import 'package:odigov3/ui/utils/widgets/common_dialog.dart';
import 'package:odigov3/ui/utils/widgets/common_empty_state_widget.dart';

class AdsShowTimeWeb extends ConsumerWidget {
  const AdsShowTimeWeb({super.key});

  ///Build Override
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adsShowTimeWatch = ref.watch(adsShownTimeController);
    final destinationWatch = ref.watch(destinationController);
    return BaseDrawerPageWidget(
        isApiLoading: adsShowTimeWatch.adsShownTimeListState.isLoading,
        showSearchBar: true,
        searchPlaceHolderText: LocaleKeys.keySearchAds.localized,
        searchController: adsShowTimeWatch.searchCtr,
        searchOnChanged: (value){
          if(!adsShowTimeWatch.adsShownTimeListState.isLoading) {
            adsShowTimeWatch.adsShownTimeListApi(context, searchKeyword: value);
          }
        },
        showFilters: true,
        filterButtonOnTap: () {
          /// filter dialog
          showCommonDetailDialog(
            keyBadge: adsShowTimeWatch.filterKey,
            context: context,
            dialogBody: AdsShownTimeListFilter(),
            height: 1,
            width: 0.5,
          );
        },
        listName: LocaleKeys.keyAds.localized,
        totalCount: adsShowTimeWatch.adsShownTimeListState.success?.totalCount,
        isFilterApplied:   (adsShowTimeWatch.selectedStartDate != null && adsShowTimeWatch.selectedEndDate != null) || (adsShowTimeWatch.selectedPurchaseType.title != CommonEnumTitleValueModel(title: LocaleKeys.keyAll,value: null).title),
        showExport: true,
        exportOnTap: () {
          adsShowTimeWatch.exportAdsShownTimeApi(fileName: 'adsShownTime',context: context);
        },
        body: destinationWatch.destinationListState.isLoading?
        /// Loader
        Center(child: CommonAnimLoader()):
        /// Empty state
        destinationWatch.destinationList.isEmpty ?
        Center(child: CommonEmptyStateWidget(title: LocaleKeys.keySomeThingWentWrong.localized,)):
        /// Main widget
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  /// Top Widget
                  AdsShowTimeDestinationSelectionWidget(),
                  /// Bottom Widget
                  Expanded(child: AdsShowTimeListWidget()),
                ],
              ).paddingAll(20),
            ),
           /* /// Loader on update api call
            adsSequencePreviewWatch.adsShownTimeListState.isLoading?
            Container(color: AppColors.white.withValues(alpha: 0.8),child: CommonAnimLoader()) : Offstage()*/
          ],
        )
    );
  }
}
