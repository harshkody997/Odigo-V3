import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/master/country/country_list_controller.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/drawer/web/base_drawer_page_widget.dart';
import 'package:odigov3/ui/master/country/web/helper/country_table.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';

class CountryListWeb extends ConsumerStatefulWidget {
  const CountryListWeb({Key? key}) : super(key: key);

  @override
  ConsumerState<CountryListWeb> createState() => _CountryListWebState();
}

class _CountryListWebState extends ConsumerState<CountryListWeb> {

  ///Dispose Override
  @override
  void dispose() {
    super.dispose();
  }

  ///Build Override
  @override
  Widget build(BuildContext context) {
    final countryListWatch = ref.watch(countryListController);
    return BaseDrawerPageWidget(searchController: countryListWatch.searchCtr,
      listName: LocaleKeys.keyCountries.localized,
      totalCount: countryListWatch.totalCount,
      searchPlaceHolderText: LocaleKeys.keySearchCountryCurrency.localized,
      showSearchBar: true,
      searchOnChanged: (value){
        if (countryListWatch.debounce?.isActive ?? false) {
          countryListWatch.debounce?.cancel();
        }
        countryListWatch.debounce =
            Timer(const Duration(milliseconds: 500), () async {
              countryListWatch.clearList();
              await countryListWatch.getCountryListAPI(context,searchKeyword: value);
            });
      },
      body: CountryTable());
  }
}
