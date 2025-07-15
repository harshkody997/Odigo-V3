import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/destination/destination_details_controller.dart';
import 'package:odigov3/framework/controller/table_controller.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/destination_details/web/helper/edit_floor_name.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_dialog.dart';
import 'package:odigov3/ui/utils/widgets/common_table_generator.dart';

class FloorModuleTable extends ConsumerStatefulWidget {
  const FloorModuleTable({Key? key}) : super(key: key);

  @override
  ConsumerState<FloorModuleTable> createState() => _FloorModuleTableState();
}

class _FloorModuleTableState extends ConsumerState<FloorModuleTable> {

  ///Build
  @override
  Widget build(BuildContext context) {
    final destinationDetailsWatch = ref.watch(destinationDetailsController);
    return Container(
      child: CommonTableGenerator(
        // Header widgets for the table
        headerContent: [
          CommonHeader(title: LocaleKeys.keyFloorNo.localized),
          CommonHeader(title: LocaleKeys.keyFloorName.localized),
        ],

        // Data list from ads controller
        childrenHeader: destinationDetailsWatch.floorListState.success?.data ?? [],

        // Row builder for each data row
        childrenContent: (index) {
          final item = destinationDetailsWatch.floorListState.success?.data?[index];
          return [
            CommonRow(title: item?.floorNumber.toString() ?? ''),
            CommonRow(title: item?.name ?? ''),
            CommonRow(title: ''),
          ];
        },

        isEditAvailable: true,
        isEditVisible: (index) => true,
        onEdit: (index) {
          // destinationDetailsWatch.floorNameController.text = adsWatch.defaultAdsList[index]?.name ?? '';
          destinationDetailsWatch.editFloorNameFormKey.currentState?.reset();
          showCommonWebDialog(
            keyBadge: destinationDetailsWatch.editFloorNameDialogKey,
            width: 0.4,
            context: context,
            dialogBody: EditFloorNameDialog(
              uuid: '',
            ),
          );
        },


        onScrollListener: () {
          print('Api method called');
        },
        isLoading: destinationDetailsWatch.floorListState.isLoading,
      ),
    );
  }
}
