import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/destination/destination_controller.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/cache_image.dart';
import 'package:odigov3/ui/utils/widgets/common_table_generator.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class StoreDestinationList extends ConsumerWidget {
  final String storeUuid;

  const StoreDestinationList({super.key, required this.storeUuid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final destinationWatch = ref.watch(destinationController);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.all(context.width * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText(title: LocaleKeys.keyDestination.localized, style: TextStyles.semiBold.copyWith(fontSize: 14)).paddingOnly(bottom: context.height * 0.030),

          /// destinations list
          Expanded(
            child: CommonTableGenerator(
              // Header widgets for the table
              headerContent: [
                CommonHeader(title: LocaleKeys.keyDestinationName.localized, flex: 3),
                CommonHeader(title: LocaleKeys.keyOwnersName.localized, flex: 2),
                CommonHeader(title: LocaleKeys.keyEmailId.localized, flex: 2),
                CommonHeader(title: LocaleKeys.keyMobileNumber.localized, flex: 2),
                CommonHeader(title: LocaleKeys.keyFloorNo.localized),
                CommonHeader(title: LocaleKeys.keyAddress.localized, flex: 4),
              ],
              childrenHeader: destinationWatch.destinationList,
              childrenContent: (index) {
                final item = destinationWatch.destinationList[index];
                return [
                  Flexible(
                    flex: 3,
                    child: Row(
                      children: [
                        CacheImage(
                          imageURL: item.imageUrl ?? '',
                          placeholderName: item.name ?? '',
                          height: context.height * 0.0520,
                          width: context.height * 0.0520,
                          bottomLeftRadius: context.height * 0.060,
                          bottomRightRadius: context.height * 0.060,
                          topLeftRadius: context.height * 0.060,
                          topRightRadius: context.height * 0.060,
                        ).paddingOnly(right: context.width * 0.020),
                        CommonRow(title: item.name ?? ''),
                      ],
                    ),
                  ),
                  CommonRow(title: item.ownerName ?? '', flex: 2),
                  CommonRow(title: item.email ?? '', flex: 2),
                  CommonRow(title: item.contactNumber ?? '', flex: 2),
                  CommonRow(title: item.totalFloor.toString()),
                  CommonRow(
                    flex: 4,
                    title:
                    '${item.houseNumber}, ${item.streetName}, ${item.addressLine1} ${item.addressLine2} ${item.landmark} ${item.stateName}, ${item.cityName}, ${item.postalCode}',
                  ),
                ];
              },
              /// scroll listener
              isLoading: destinationWatch.destinationListState.isLoading,
              isLoadMore: destinationWatch.destinationListState.isLoadMore,
              onScrollListener: () {
                if (!destinationWatch.destinationListState.isLoadMore && destinationWatch.destinationListState.success?.hasNextPage == true) {
                  destinationWatch.getDestinationListApi(context, storeUuid: storeUuid);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
