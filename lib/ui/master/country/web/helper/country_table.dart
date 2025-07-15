import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/master/country/country_list_controller.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/widgets/common_table_generator.dart';

class CountryTable extends ConsumerStatefulWidget {
  const CountryTable({super.key});

  @override
  ConsumerState<CountryTable> createState() => _CountryTableState();
}

class _CountryTableState extends ConsumerState<CountryTable> {

  @override
  Widget build(BuildContext context) {
    final countryListWatch = ref.watch(countryListController);
    return CommonTableGenerator(
      headerContent: [
        CommonHeader(title: LocaleKeys.keyCountryName.localized,flex: 2), /// country name
        CommonHeader(title: LocaleKeys.keyCountryCode.localized,flex: 2), /// country code
        CommonHeader(title: LocaleKeys.keyCurrencyName.localized,flex: 2), /// currency name
      ],
      childrenHeader: countryListWatch.countryList,
      isLoading: countryListWatch.countryListState.isLoading,
      childrenContent: (int index) {
        final item = countryListWatch.countryList[index];
        return [
          CommonRow(title: item.name ?? '',flex: 2),    /// country name
          CommonRow(title: item.code ?? '',flex: 2),/// country code
          CommonRow(title: item.currency ?? '',flex: 2), /// currency name
        ];

      },
      isStatusAvailable: false,
      onScrollListener: () async {
        if (!countryListWatch.countryListState.isLoadMore && countryListWatch.countryListState.success?.hasNextPage == true) {
          if (mounted) {
            await countryListWatch.getCountryListAPI(context,pagination: true,searchKeyword: countryListWatch.searchCtr.text);
          }
        }
      },
    );
  }
}

