import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/purchase/purchase_details_controller.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_table_generator.dart';

class PurchaseAdsTable extends ConsumerWidget {
  const PurchaseAdsTable({Key? key}) : super(key: key);

  ///Build
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final purchaseDetailsWatch = ref.watch(purchaseDetailsController);
    return CommonTableGenerator(
      isLoading: purchaseDetailsWatch.purchaseAdsState.isLoading,
      /// Header widgets for the table
      headerContent: [
        ///Tag
        CommonHeader(title: LocaleKeys.keyTag.localized, flex: 2),
        ///Media Type
        CommonHeader(title: LocaleKeys.keyMediaType.localized, flex: 2),
        ///Created Date
        CommonHeader(title: LocaleKeys.keyCreatedDate.localized, flex: 2),
      ],

      ///List
      childrenHeader: purchaseDetailsWatch.purchaseAdsState.success?.data??[],

      /// Row builder for each data row
      childrenContent: (index) {
        final item = purchaseDetailsWatch.purchaseAdsState.success?.data?[index];
        return [
          ///Tag
          CommonRow(title: item?.name ?? '', flex: 2),
          ///Media Type
          CommonRow(title: getAllLocalizeText(item?.adsMediaType??''), flex: 2),
          ///Created Date
          CommonRow(title:formatUtcToLocalDate(item?.createdAt??0)??'-', flex: 2),
        ];
      }, onScrollListener: () {  },


    );
  }
}
