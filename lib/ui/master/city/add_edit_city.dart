import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/controller/master/city/add_edit_city_controller.dart';
import 'package:odigov3/framework/controller/master/city/city_list_controller.dart';
import 'package:odigov3/framework/controller/master/country/country_list_controller.dart';
import 'package:odigov3/framework/controller/master/state/state_list_controller.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:odigov3/ui/master/city/web/add_edit_city_web.dart';

class AddEditCity extends ConsumerStatefulWidget{
  final bool? isEdit;
  final String? uuid;
  const AddEditCity({Key? key,this.isEdit,this.uuid,}) : super(key: key);

  @override
  ConsumerState<AddEditCity> createState() => _AddEditCityState();
}

class _AddEditCityState extends ConsumerState<AddEditCity> with WidgetsBindingObserver, ZoomAwareMixin {

  @override
  void initState() {
    if(ref.read(drawerController).isSubScreenCanViewSidebarAndCanView){
      final addEditCityWatch = ref.read(addEditCityController);
      addEditCityWatch.disposeController();
      ref.read(stateListController).disposeController();
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
        addEditCityWatch.getLanguageListModel();
        final countryListWatch = ref.read(countryListController);
        await countryListWatch.getCountryListAPI(context,activeRecords: true);
        final stateListWatch = ref.read(stateListController);
        // await stateListWatch.getStateListAPI(context,activeRecords: true);

        if(widget.isEdit == true){
          await addEditCityWatch.cityDetailsAPI(context, widget.uuid??'');
          addEditCityWatch.setPreFillCountryDropdown(countryListWatch.countryList, addEditCityWatch.cityDetailsState.success?.data?.countryUuid);
          await stateListWatch.getStateListAPI(context,countryUuid: addEditCityWatch.cityDetailsState.success?.data?.countryUuid,pageSize: AppConstants.pageSize10000,activeRecords: true);
          addEditCityWatch.setPreFillStateDropdown(stateListWatch.stateList, addEditCityWatch.cityDetailsState.success?.data?.stateUuid);
        }
      });
    }
    super.initState();
  }


  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) {
        return AddEditCityWeb(isEdit: widget.isEdit,uuid: widget.uuid);
      },
      desktop: (BuildContext context) {
        return AddEditCityWeb(isEdit: widget.isEdit,uuid: widget.uuid);
      },
      tablet: (BuildContext context) {
        return AddEditCityWeb(isEdit: widget.isEdit,uuid: widget.uuid);
      },
    );
  }
}

