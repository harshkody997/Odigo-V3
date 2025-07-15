import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';
import 'package:odigov3/framework/controller/destination/destination_details_controller.dart';
import 'package:odigov3/framework/controller/store/store_controller.dart';
import 'package:odigov3/framework/controller/table_controller.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_table_generator.dart';

class StoreModuleTable extends ConsumerStatefulWidget {
  const StoreModuleTable({Key? key}) : super(key: key);

  @override
  ConsumerState<StoreModuleTable> createState() => _StoreModuleTableState();
}

class _StoreModuleTableState extends ConsumerState<StoreModuleTable> {

  ///Build
  @override
  Widget build(BuildContext context) {
    // Watch state providers
    final tableWatch = ref.watch(tableController);
    final destinationDetailsWatch = ref.watch(destinationDetailsController);
    // final destinationDetailsWatch = ref.watch(storeController);

    return Container(
      child: CommonTableGenerator(
        // Header widgets for the table
        headerContent: [
          CommonHeader(title: LocaleKeys.keyStoreName.localized),
          CommonHeader(flex: 7, title: LocaleKeys.keyCategory.localized),

          CommonHeader(title: LocaleKeys.keyFloorNo.localized,flex: 2),
        ],

        // Data list from ads controller
        childrenHeader: destinationDetailsWatch.storeList,

        // Row builder for each data row
        childrenContent: (index) {
          final item = destinationDetailsWatch.storeList[index];
          return [
            CommonRow(title: item?.name ?? ''),
            CommonRow(title: item?.businessCategories?.map((e) => e.name).toList().toString().replaceAll('[', '').replaceAll(']', '') ?? '',flex: 7),
            CommonRow(title: "${item?.floorNumber ?? '0'}",flex: 2),
          ];
        },


        onScrollListener: () {
          print('Api method called');
        },
        isLoading: destinationDetailsWatch.storeListState.isLoading,
      ),
    );
  }
}
