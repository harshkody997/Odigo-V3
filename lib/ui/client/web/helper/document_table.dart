import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/client/add_update_client_controller.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/client/web/helper/document_view_widget.dart';
import 'package:odigov3/ui/routing/navigation_stack_item.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/cache_image.dart';
import 'package:odigov3/ui/utils/widgets/common_dialog.dart';
import 'package:odigov3/ui/utils/widgets/common_table_generator.dart';

class DocumentTable extends ConsumerStatefulWidget {
  final String clientUuid;

  const DocumentTable({super.key, required this.clientUuid});

  @override
  ConsumerState<DocumentTable> createState() => _DocumentTableState();
}


class _DocumentTableState extends ConsumerState<DocumentTable> {

  @override
  void initState() {
    super.initState();
    final addUpdateClientRead = ref.read(addUpdateClientController);
    addUpdateClientRead.clearDocumentList();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      addUpdateClientRead.getDocumentImageByUuidApi(context, widget.clientUuid);
    });
  }

  @override
  Widget build(BuildContext context) {
    final addUpdateClientWatch = ref.watch(addUpdateClientController);
    return CommonTableGenerator(
      // Header widgets for the table
      headerContent: [
        CommonHeader(title: LocaleKeys.keyImage.localized),
        CommonHeader(title: LocaleKeys.keyDocumentName.localized, flex: 8),
      ],

      // Data list from ads controller
      childrenHeader: addUpdateClientWatch.documentsDataList,

      // Row builder for each data row
      childrenContent: (index) {
        final item = addUpdateClientWatch.documentsDataList[index];
        return [
          Expanded(
            flex: 1,
              child: CacheImage(height: 50, width: 70,imageURL:item.url ?? '').paddingOnly(right: context.width * 0.035)),
          CommonRow(title: item.name ?? '', flex: 8),
          CommonHeader(title: '')
        ];
      },

      /// delete
      isDeleteAvailable: true,
      canDeletePermission: true,
      isDeleteVisible: (index) => true,
      isDeleteLoading: (index) => (addUpdateClientWatch.removeDocumentState.isLoading && index == addUpdateClientWatch.deleteIndex),
      onDelete: (index) async {
        addUpdateClientWatch.updateDeleteIndex(index);
        await addUpdateClientWatch.removeDocumentApi(context, addUpdateClientWatch.documentsDataList[index].uuid);
        if (addUpdateClientWatch.removeDocumentState.success?.status == ApiEndPoints.apiStatus_200) {
          // await addUpdateClientWatch.getDocumentImageByUuidApi(context, widget.clientUuid ?? '');
          addUpdateClientWatch.documentsDataList.removeAt(index);
          addUpdateClientWatch.notifyListeners();
        }
      },

      /// edit
      isEditAvailable: true,
      isEditVisible: (index) => true,
      onEdit: (index) {
        final item = addUpdateClientWatch.documentsDataList[index];
        ref.read(navigationStackController).push(NavigationStackItem.uploadDocument(clientUuid: widget.clientUuid,documentUuid: item.uuid));
      },

      /// details
      isDetailsAvailable: true,
      onForwardArrow: (index) {
        /// show document view
        final item = addUpdateClientWatch.documentsDataList[index];
        showCommonWebDialog(
            context: context,
            width: 0.3,
            keyBadge: addUpdateClientWatch.documentViewKey,
            dialogBody: DocumentViewWidget(documentData: item)
        );
      },

      /// scroll listener
      isLoading: addUpdateClientWatch.getDocumentByUuidState.isLoading,
      isLoadMore: addUpdateClientWatch.getDocumentByUuidState.isLoadMore,
      onScrollListener: () {},
    );
  }
}
