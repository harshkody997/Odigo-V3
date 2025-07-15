import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/client_ads/client_ads_controller.dart';
import 'package:odigov3/framework/controller/create_ads/create_ads_controller.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/ads_create/web/helper/edit_ad_name.dart';
import 'package:odigov3/ui/client_ads/web/helper/ads_status_widget.dart';
import 'package:odigov3/ui/client_ads/web/helper/reject_ad_reason_dialog.dart';
import 'package:odigov3/ui/routing/navigation_stack_item.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/app_enums.dart';
import 'package:odigov3/ui/utils/widgets/common_dialog.dart';
import 'package:odigov3/ui/utils/widgets/common_table_generator.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';

class ClientAdsTable extends ConsumerStatefulWidget {
  const ClientAdsTable({Key? key}) : super(key: key);

  @override
  ConsumerState<ClientAdsTable> createState() => _ClientAdsTableState();
}

class _ClientAdsTableState extends ConsumerState<ClientAdsTable> {

  @override
  Widget build(BuildContext context) {
    final clientAdsWatch = ref.watch(clientAdsController);
    final drawerWatch = ref.watch(drawerController);

    return CommonTableGenerator(
      // Header widgets for the table
      headerContent: [
        CommonHeader(title: LocaleKeys.keyStatus.localized),
        CommonHeader(title: LocaleKeys.keyName.localized),
        CommonHeader(title: LocaleKeys.keyClientName.localized),
        CommonHeader(title: LocaleKeys.keyDate.localized),
        CommonHeader(title: LocaleKeys.keyMediaType.localized),
        CommonHeader(title: LocaleKeys.keyVerificationStatus.localized),
      ],

      // Data list from ads controller
      childrenHeader: clientAdsWatch.clientAdsList,

      // Row builder for each data row
      childrenContent: (index) {
        final item = clientAdsWatch.clientAdsList[index];
        return [
          CommonRow(title: item?.name ?? ''),
          CommonRow(title: item?.clientName ?? ''),
          CommonRow(title: formatUtcToLocalDate(item?.createdAt) ?? ''),
          CommonRow(title: item?.adsMediaType ?? ''),
          Expanded(
            child: Row(
              children: [
                AdsStatusWidget(status: item?.status ?? '',),
                Spacer(),
              ],
            ),
          )
        ];
      },

      /// status
      isSwitchLoading: (index) => clientAdsWatch.changeClientAdsStatusState.isLoading && index == clientAdsWatch.statusTapIndex,
      isStatusAvailable: true,
      statusValue: (index) => clientAdsWatch.clientAdsList[index]?.active,
      hideStatus: (index) => (clientAdsWatch.clientAdsList[index]?.status == 'REJECTED') || (clientAdsWatch.clientAdsList[index]?.status == 'PENDING'),
      onStatusTap: (value, index) async {
        clientAdsWatch.updateStatusIndex(index);
        clientAdsWatch.changeClientAdsStatusApi(context, uuid: clientAdsWatch.clientAdsList[index]?.uuid ?? '', isActive: value, index: index);
      },

      /// delete
      isDeleteAvailable: drawerWatch.selectedMainScreen?.canDelete,
      canDeletePermission: drawerWatch.selectedMainScreen?.canDelete,
      isDeleteVisible: (index) => clientAdsWatch.clientAdsList[index]?.status == StatusEnum.ACTIVE.name && (clientAdsWatch.clientAdsList[index]?.active ?? false),
      isDeleteLoading: (index) => clientAdsWatch.deleteClientAdsState.isLoading && index == clientAdsWatch.statusTapIndex,
      onDelete: (index) {
        clientAdsWatch.updateStatusIndex(index);
        clientAdsWatch.deleteClientAdsApi(context, uuid: clientAdsWatch.clientAdsList[index]?.uuid ?? '', index: index);
      },

      /// edit
      isEditAvailable: drawerWatch.selectedMainScreen?.canEdit,
      isEditVisible: (index) => clientAdsWatch.clientAdsList[index]?.status == StatusEnum.ACTIVE.name && (clientAdsWatch.clientAdsList[index]?.active ??false),
      onEdit: (index) {
        ref.read(createAdsController).addTagNameController.text = clientAdsWatch.clientAdsList[index]?.name ?? '';
        ref.read(createAdsController).formKey.currentState?.reset();

        showCommonWebDialog(
          keyBadge: clientAdsWatch.editAdNameDialogKey,
          width: 0.3,
          context: context,
          dialogBody: EditAdNameDialog(
            uuid: clientAdsWatch.clientAdsList[index]?.uuid ?? '',
          ),
        );
      },

      /// for info icon
      isInfoAvailable: true,
      isInfoVisible: (index) => clientAdsWatch.clientAdsList[index]?.status == 'REJECTED',
      infoText: (index) => clientAdsWatch.clientAdsList[index]?.rejectReason,

      /// details
      isDetailsAvailable: true,
      onForwardArrow: (index) {
        ref.read(navigationStackController).push(NavigationStackItem.adsDetails(adsType: AdsType.Client.name, uuid: clientAdsWatch.clientAdsList[index]?.uuid ?? ''));
      },

      /// for add content
      isAddContentButtonVisible: (index) => (clientAdsWatch.clientAdsList[index]?.files?.isEmpty ?? false),
      onAddContent: (index) {
        /// redirection for add content
        ref.read(navigationStackController).push(NavigationStackItem.createAdsClient(clientUUid: clientAdsWatch.clientAdsList[index]?.uuid ?? ''));
      },

      /// Approve/Decline buttons
      isConfirmationField: true,
      isConfirmationFieldVisible: (index) => (clientAdsWatch.clientAdsList[index]?.status == 'PENDING') && (clientAdsWatch.clientAdsList[index]?.files?.isNotEmpty ?? false),
      isApproveLoading: (index) => clientAdsWatch.acceptRejectAdsState.isLoading && index == clientAdsWatch.statusTapIndex,
      onApprove: (index) async {
        clientAdsWatch.updateStatusIndex(index);
        await clientAdsWatch.acceptRejectAdsApi(context, uuid: clientAdsWatch.clientAdsList[index]?.uuid ?? '', status: 'ACCEPTED');
        if(clientAdsWatch.acceptRejectAdsState.success?.status == ApiEndPoints.apiStatus_200){
          clientAdsWatch.clientAdsListApi(context);
        }
      },
      onDecline: (index) {
        clientAdsWatch.rejectReasonCtr.clear();
        clientAdsWatch.formKey.currentState?.reset();
        showCommonWebDialog(
          keyBadge: clientAdsWatch.reasonDialogKey,
          width: 0.3,
          context: context,
          dialogBody: RejectAdReasonDialog(
            uuid: clientAdsWatch.clientAdsList[index]?.uuid ?? '',
          ),
        );
      },

      /// scroll listener
      isLoading: clientAdsWatch.clientAdsListState.isLoading,
      isLoadMore: clientAdsWatch.clientAdsListState.isLoadMore,
      onScrollListener: () {
        if (!clientAdsWatch.clientAdsListState.isLoadMore && clientAdsWatch.clientAdsListState.success?.hasNextPage == true) {
          if (mounted) {
            clientAdsWatch.clientAdsListApi(context, isForPagination: true);
          }
        }
      },
    );
  }
}
