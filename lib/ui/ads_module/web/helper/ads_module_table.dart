import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/ads_module/ads_module_controller.dart';
import 'package:odigov3/framework/controller/create_ads/create_ads_controller.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/repository/default_ads/model/default_ads_list_response_model.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/ads_create/web/helper/edit_ad_name.dart';
import 'package:odigov3/ui/routing/navigation_stack_item.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/app_enums.dart';
import 'package:odigov3/ui/utils/widgets/common_dialog.dart';
import 'package:odigov3/ui/utils/widgets/common_table_generator.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';

class AdsModuleTable extends ConsumerStatefulWidget {
  const AdsModuleTable({Key? key}) : super(key: key);

  @override
  ConsumerState<AdsModuleTable> createState() => _AdsModuleTableState();
}

class _AdsModuleTableState extends ConsumerState<AdsModuleTable> {

  @override
  Widget build(BuildContext context) {
    final adsWatch = ref.watch(adsModuleController);
    final drawerWatch = ref.watch(drawerController);

    return CommonTableGenerator(
      // Header widgets for the table
      headerContent: [
        CommonHeader(title: LocaleKeys.keyStatus.localized),
        CommonHeader(title: LocaleKeys.keyName.localized),
        CommonHeader(title: LocaleKeys.keyDestination.localized),
        CommonHeader(title: LocaleKeys.keyDate.localized),
        CommonHeader(title: LocaleKeys.keyMediaType.localized),
      ],

      // Data list from ads controller
      childrenHeader: adsWatch.defaultAdsList,

      // Row builder for each data row
      childrenContent: (index) {
        DefaultAdsListData? item = adsWatch.defaultAdsList[index];
        return [
          CommonRow(title: item?.name ?? ''),
          CommonRow(title: item?.destinationName ?? ''),
          CommonRow(title: formatUtcToLocalDate(item?.createdAt) ?? ''),
          CommonRow(title: item?.adsMediaType ?? ''),
        ];
      },

      /// status
      isSwitchLoading: (index) => adsWatch.changeDefaultAdsStatusState.isLoading && index == adsWatch.statusTapIndex,
      isStatusAvailable: true,
      hideStatus: (index) => (adsWatch.defaultAdsList[index]?.files?.isEmpty),
      statusValue: (index) => adsWatch.defaultAdsList[index]?.active,
      onStatusTap: (value, index) async {
        adsWatch.updateStatusIndex(index);
        adsWatch.changeDefaultAdsStatusApi(context, uuid: adsWatch.defaultAdsList[index]?.uuid ?? '', isActive: value, index: index);
      },

      isDeleteAvailable: drawerWatch.selectedMainScreen?.canDelete,
      canDeletePermission: drawerWatch.selectedMainScreen?.canDelete,
      isDeleteVisible: (index) => adsWatch.defaultAdsList[index]?.active,
      isDeleteLoading: (index) => adsWatch.deleteDefaultAdsState.isLoading && index == adsWatch.statusTapIndex,
      onDelete: (index) {
        adsWatch.updateStatusIndex(index);
        adsWatch.deleteDefaultAdsApi(context, uuid: adsWatch.defaultAdsList[index]?.uuid ?? '', index: index);
      },

      /// edit
      isEditAvailable: drawerWatch.selectedMainScreen?.canEdit,
      isEditVisible: (index) => adsWatch.defaultAdsList[index]?.active,
      onEdit: (index) {
        ref.read(createAdsController).addTagNameController.text = adsWatch.defaultAdsList[index]?.name ?? '';
        ref.read(createAdsController).formKey.currentState?.reset();
        showCommonWebDialog(
          keyBadge: adsWatch.editAdNameDialogKey,
          width: 0.4,
          context: context,
          dialogBody: EditAdNameDialog(
            uuid: adsWatch.defaultAdsList[index]?.uuid ?? '',
          ),
        );
      },

      /// for add content
      isConfirmationField: true,
      isAddContentButtonVisible: (index) => (adsWatch.defaultAdsList[index]?.files?.isEmpty),
      onAddContent: (index) {
        /// redirection for add content
        ref.read(navigationStackController).push(NavigationStackItem.createAdsDestination(destinationUUid: adsWatch.defaultAdsList[index]?.uuid ?? ''));
      },

      /// details
      isDetailsAvailable: true,
      onForwardArrow: (index) {
        ref.read(navigationStackController).push(NavigationStackItem.adsDetails(adsType: AdsType.Default.name, uuid: adsWatch.defaultAdsList[index]?.uuid ?? ''));
      },
      /// scroll listener
      isLoading: adsWatch.defaultAdsListState.isLoading,
      isLoadMore: adsWatch.defaultAdsListState.isLoadMore,
      onScrollListener: () {
        if (!adsWatch.defaultAdsListState.isLoadMore && adsWatch.defaultAdsListState.success?.hasNextPage == true) {
          if (mounted) {
            adsWatch.defaultAdsListApi(context, isForPagination: true);
          }
        }
      },
    );
  }
}
