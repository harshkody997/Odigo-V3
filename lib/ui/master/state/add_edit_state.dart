import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/controller/master/country/country_list_controller.dart';
import 'package:odigov3/framework/controller/master/state/add_edit_state_controller.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:odigov3/ui/master/state/web/add_edit_state_web.dart';

class AddEditState extends ConsumerStatefulWidget {
  final bool? isEdit;
  final String? uuid;
  const AddEditState({Key? key,this.isEdit,this.uuid}) : super(key: key);

  @override
  ConsumerState<AddEditState> createState() => _AddEditStateState();
}

class _AddEditStateState extends ConsumerState<AddEditState>  with WidgetsBindingObserver, ZoomAwareMixin {

  ///Init Override
  @override
  void initState() {
    final drawerWatch = ref.read(drawerController);
    if(drawerWatch.isSubScreenCanViewSidebarAndCanView){
      final addEditStateWatch = ref.read(addEditStateController);
      final countryWatch = ref.read(countryListController);
      addEditStateWatch.disposeController();
      countryWatch.disposeController();
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
        addEditStateWatch.getLanguageListModel();
        await countryWatch.getCountryListAPI(context,activeRecords: true);
        if(widget.isEdit == true && widget.uuid != null){
          await addEditStateWatch.stateDetailsAPI(context, widget.uuid??'');
          addEditStateWatch.setPreFilCountryDropdown(countryWatch.countryList, addEditStateWatch.stateDetailsState.success?.data?.countryUuid);
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
        return AddEditStateWeb(isEdit: widget.isEdit,uuid: widget.uuid);
      },
      desktop: (BuildContext context) {
        return AddEditStateWeb(isEdit: widget.isEdit,uuid: widget.uuid);
      },
      tablet: (BuildContext context) {
        return AddEditStateWeb(isEdit: widget.isEdit,uuid: widget.uuid);
      },
    );
  }
}

