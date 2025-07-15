import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/general_support/general_support_controller.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/drawer/web/base_drawer_page_widget.dart';
import 'package:odigov3/ui/general_support/web/helper/contact_detail_dialog.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_dialog.dart';
import 'package:odigov3/ui/utils/widgets/common_table_generator.dart';

class GeneralSupportWeb extends ConsumerStatefulWidget {
  const GeneralSupportWeb({super.key});

  @override
  ConsumerState<GeneralSupportWeb> createState() => _GeneralSupportWebState();
}

class _GeneralSupportWebState extends ConsumerState<GeneralSupportWeb> {
  ///Build Override
  @override
  Widget build(BuildContext context) {
    return BaseDrawerPageWidget(      listName: LocaleKeys.keyRequests.localized.localized,
      body: _bodyWidget(),totalCount: ref.watch(generalSupportController).contactUsListState.success?.totalCount,);
  }

  ///Body Widget
  Widget _bodyWidget() {
    final generalSupportWatch = ref.watch(generalSupportController);
    return CommonTableGenerator(
      headerContent: [
        CommonHeader(title: LocaleKeys.keyName.localized, flex: 1),
        CommonHeader(title: LocaleKeys.keyEmailId.localized, flex: 2),
        CommonHeader(title: LocaleKeys.keyContactNumber.localized, flex: 1),
        CommonHeader(title: LocaleKeys.keyDate.localized, flex: 3),
      ],
      childrenHeader: generalSupportWatch.contactUsList,
      childrenContent: (index) {
        final item = generalSupportWatch.contactUsList[index];
        return [
          CommonRow(title: item?.name ?? '-', flex: 1),
          CommonRow(title: item?.email ?? '-', flex: 2),
          CommonRow(title: item?.contactNumber ?? '-', flex: 1),
          CommonRow(title: formatUtcToLocalDate(item?.createdAt) ?? '', flex: 3),
          CommonRow(title: ''),
        ];
      },

      /// details
      isDetailsAvailable: true,
      onForwardArrow: (index) {
        ///
        showCommonDetailDialog(
          keyBadge: generalSupportWatch.contactDetailDialogKey,
          context: context,
          dialogBody: ContactDetailDialog(index: index),
          height: 1,
          width: 0.6,
        );
      },

      /// scroll listener
      isLoading: generalSupportWatch.contactUsListState.isLoading,
      isLoadMore: generalSupportWatch.contactUsListState.isLoadMore,
      onScrollListener: () {
        if (!generalSupportWatch.contactUsListState.isLoadMore &&
            generalSupportWatch.contactUsListState.success?.hasNextPage ==
                true) {
          if (mounted) {
            generalSupportWatch.contactUsListApi(
              context,
              isForPagination: true,
            );
          }
        }
      },
    );
  }
}
