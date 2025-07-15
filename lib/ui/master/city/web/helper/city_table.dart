import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/controller/master/city/city_list_controller.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/routing/navigation_stack_item.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/widgets/common_table_generator.dart';

class CityTable extends ConsumerStatefulWidget {
  const CityTable({super.key});

  @override
  ConsumerState<CityTable> createState() => _CityTableState();
}

class _CityTableState extends ConsumerState<CityTable> {

  @override
  Widget build(BuildContext context) {
    final cityListWatch = ref.watch(cityListController);
    final drawerWatch = ref.watch(drawerController);
    return CommonTableGenerator(
      headerContent: [
        CommonHeader(title: LocaleKeys.keyStatus.localized), /// status
        CommonHeader(title: LocaleKeys.keyCountryName.localized,flex: 3), /// country name
        CommonHeader(title: LocaleKeys.keyStateName.localized,flex: 4), /// state name
        CommonHeader(title: LocaleKeys.keyCityName.localized,flex: 8), /// city name
      ],
      childrenHeader: cityListWatch.cityList,
      childrenContent: (int index) {
        final item = cityListWatch.cityList[index];
        return [
          CommonRow(title: item.countryName ?? '',flex: 3), /// country name
          CommonRow(title: item.stateName ?? '',flex: 4), /// state name
          CommonRow(title: item.name ?? '',flex: 8), /// city name
          CommonRow(title: ''), /// empty to align edit button
        ];

      },
      isEditAvailable: drawerWatch.isSubScreenCanEdit,
      canDeletePermission: drawerWatch.isSubScreenCanDelete,
      onEdit: (index){
        ref.read(navigationStackController).push(NavigationStackItem.editCity(uuid: cityListWatch.cityList[index].uuid??''));
      },
      isStatusAvailable: true,
      isDetailsAvailable: false,
      isLoading: cityListWatch.cityListState.isLoading,
      isLoadMore: cityListWatch.cityListState.isLoadMore,
      isSwitchLoading: (index) => cityListWatch.changeCityStatusState.isLoading && index == cityListWatch.statusTapIndex,
      statusValue:(index) => cityListWatch.cityList[index].active,
      isEditVisible:(index) => cityListWatch.cityList[index].active,
      onStatusTap: (value,index) {
        cityListWatch.updateStatusIndex(index);
        cityListWatch.changeCityStatusAPI(context, cityListWatch.cityList[index].uuid??'', value,index);
      }, onScrollListener: () async {
      if (!cityListWatch.cityListState.isLoadMore && cityListWatch.cityListState.success?.hasNextPage == true) {
        if (mounted) {
          await cityListWatch.getCityListAPI(context,pagination: true,activeRecords: cityListWatch.selectedFilter?.value);
        }
      }
    },
    );
  }
}

