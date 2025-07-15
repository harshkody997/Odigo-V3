import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/client_ads/client_ads_controller.dart';
import 'package:odigov3/framework/controller/purchase/purchase_details_controller.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/routing/navigation_stack_item.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/app_enums.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_table_generator.dart';

class ChangeAdsTableWidget extends ConsumerWidget {
  final String? purchaseUuid;
  final String? clientUuid;
  const ChangeAdsTableWidget({Key? key,this.purchaseUuid,required this.clientUuid}) : super(key: key);

  ///Build
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final purchaseDetailsWatch = ref.watch(purchaseDetailsController);
    final clientAdsWatch = ref.watch(clientAdsController);
    return Expanded(
      child: CommonTableGenerator(
        /// Header widgets for the table
        headerContent: [
          ///Select
          CommonHeader(title: LocaleKeys.keySelect.localized, flex: 1),
          ///Tags
          CommonHeader(title: LocaleKeys.keyTags.localized, flex: 4),
          ///Date
          CommonHeader(title: LocaleKeys.keyDate.localized, flex: 4),
          ///Media Type
          CommonHeader(title: LocaleKeys.keyMediaType.localized, flex: 4),
          /// Ads Details
          CommonHeader(title: ''),
        ],

        ///List
        childrenHeader: clientAdsWatch.clientAdsList,

        /// Row builder for each data row
        childrenContent: (index) {
          final item = clientAdsWatch.clientAdsList[index];
          return [
            ///Select
            Expanded(
              child: Row(
                children: [
                  InkWell(
                    onTap:(){
                      purchaseDetailsWatch.updateSelectedAds(clientAdsWatch.clientAdsList,index,context,LocaleKeys.keyMinimumAndMaximumAds.localized);
                    },
                    child: CommonSVG(
                      strIcon: item?.isSelected==true?Assets.svgs.svgLike.keyName:Assets.svgs.svgDislike.keyName,
                      height: 24,
                      width: 24,
                      boxFit: BoxFit.scaleDown,
                    ),
                  ),
                  Spacer()
                ],
              ),
            ),
            ///Tags
            CommonRow(title: item?.name ?? '', flex: 4),
            ///Date
            CommonRow(title:formatUtcToLocalDate(item?.createdAt??0)??'-', flex: 4),
            ///Media Type
            CommonRow(title: getAllLocalizeText(item?.adsMediaType??''), flex: 4),
            Spacer(flex: 2,)
          ];
        },

        /// scroll listener
        isLoading: clientAdsWatch.clientAdsListState.isLoading || purchaseDetailsWatch.purchaseAdsState.isLoading,
        isLoadMore: clientAdsWatch.clientAdsListState.isLoadMore,
        onScrollListener: () {
          if (!clientAdsWatch.clientAdsListState.isLoadMore &&
              clientAdsWatch.clientAdsListState.success?.hasNextPage == true) {
            if (context.mounted) {
              clientAdsWatch.clientAdsListApi(context, isForPagination: true,odigoClientUuid: clientUuid,activeRecords: true,status: 'ACTIVE');
            }
          }
        },

        isDetailsAvailable: true,
        onForwardArrow: (index) {
          ref.read(navigationStackController).push(NavigationStackItem.adsDetails(adsType: AdsType.Client.name, uuid: clientAdsWatch.clientAdsList[index]?.uuid ?? ''));
        },

      ),
    );
  }
}
