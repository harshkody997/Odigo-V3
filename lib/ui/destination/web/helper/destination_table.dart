import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/destination/destination_controller.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/routing/navigation_stack_item.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/widgets/cache_image.dart';
import 'package:odigov3/ui/utils/widgets/common_table_generator.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';
import 'package:odigov3/ui/utils/widgets/common_toast_widget.dart';

/// DestinationModuleTable Widget
///
/// This widget is a high-level wrapper that utilizes the reusable [CommonTableGenerator]
/// to display a table of ad module data (dummyList).
///
/// It includes interactive status toggles, approve/reject actions, and dynamic content generation
/// based on the data provided by [destinationModuleController].

class DestinationTable extends ConsumerStatefulWidget {
  const DestinationTable({Key? key}) : super(key: key);

  @override
  ConsumerState<DestinationTable> createState() => _DestinationTableState();
}

class _DestinationTableState extends ConsumerState<DestinationTable> {
  /// Builds the widget tree
  @override
  Widget build(BuildContext context) {
    // Watch state providers
    final destinationWatch = ref.watch(destinationController);
    final drawerWatch = ref.watch(drawerController);

    return CommonTableGenerator(
            // Header widgets for the table
            isLoading: destinationWatch.destinationListState.isLoading,
            headerContent: [
              CommonHeader(title: LocaleKeys.keyStatus.localized),
              CommonHeader(title: LocaleKeys.keyDestinationName.localized, flex: 4),
              CommonHeader(title: LocaleKeys.keyDestinationUUID.localized, flex: 4),
              CommonHeader(title: LocaleKeys.keyOwnerName.localized, flex: 2),
              CommonHeader(title: LocaleKeys.keyEmailID.localized, flex: 4),
              CommonHeader(title: LocaleKeys.keyMobileNumber.localized, flex: 3),
              CommonHeader(title: LocaleKeys.keyFloor.localized),
            ],

            // Data list from ads controller
            childrenHeader: destinationWatch.destinationList,

            // Row builder for each data row
            childrenContent: (index) {
              final item = destinationWatch.destinationList[index];
              return [
                Flexible(
                  flex: 4,
                  child: Row(
                    children: [
                      // CommonSVG(strIcon: Assets.svgs.svgAdd.keyName,).paddingOnly(right: context.width * 0.01),
                      ClipOval(child: CacheImage(imageURL: item.imageUrl ?? '',height: context.height * 0.04,width: context.height * 0.04,contentMode: BoxFit.cover)),
                      SizedBox(width: context.width * 0.01),
                      CommonRow(title: item.name??'')
                    ],
                  ),
                ),

                Expanded(
                  flex: 4,
                  child: Row(
                    children: [
                      Flexible(
                        child: CommonText(
                          title: item.uuid ?? '',
                          style: rowStyle(),
                          maxLines: 3,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy, size: 18),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: item.uuid ?? ''));
                          showToast(context: context,isSuccess: true,title:LocaleKeys.keyCopiedToClipboard.localized,duration:500);
                          },
                      ).paddingOnly(right: context.width * 0.005),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      CommonRow(title: item.ownerName ?? '',),
                    ],
                  ).paddingOnly(right: context.width * 0.009),
                ),
                CommonRow(title: item.email ?? '', flex: 4),
                CommonRow(title: item.contactNumber ?? '', flex: 3),
                CommonRow(title: (item.totalFloor ?? 0).toString()),
                CommonRow(title: ''),
              ];
            },

            // Feature toggles
            isStatusAvailable: true,
            // Enable status switch
            isDetailsAvailable: true,
            canDeletePermission: drawerWatch.isMainScreenCanDelete,
            // Show forward arrow icon

            // Callback for status switch toggle
            onStatusTap: (value, index) {
              destinationWatch.updateStatusIndex(index);
              destinationWatch.changeDestinationStatusAPI(context, destinationWatch.destinationList[index].uuid??'', value, index);
            },
            isSwitchLoading: (index) => (destinationWatch.changeDestinationStatusState.isLoading && destinationWatch.statusTapIndex == index),

            // switch value initial and assigned
            statusValue: (index) => destinationWatch.destinationList[index].active ?? false,

            // Delete callback (unused for now)
            onScrollListener: () async {
              if (!destinationWatch.destinationListState.isLoadMore && destinationWatch.destinationListState.success?.hasNextPage == true) {
                if (mounted) {
                  await destinationWatch.getDestinationListApi(context,pagination: true,destinationTypeUuid: destinationWatch.selectedDestinationTypeFilter?.uuid,activeRecords:destinationWatch.selectedFilter?.value);
                }
              }
            },
            onForwardArrow: (index) {
              ref.read(navigationStackController).push(NavigationStackItemDestinationDetailsPage(destinationUuid: destinationWatch.destinationList[index].uuid ?? ''));
            },
          );
  }
}
