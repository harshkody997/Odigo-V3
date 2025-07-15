import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/controller/master/category/add_edit_category_controller.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:odigov3/ui/master/category/web/add_edit_category_web.dart';

class AddEditCategory extends ConsumerStatefulWidget{
  final bool? isEdit;
  final String? uuid;
  const AddEditCategory({Key? key,this.isEdit, this.uuid}) : super(key: key);

  @override
  ConsumerState<AddEditCategory> createState() => _AddEditCategoryState();
}

class _AddEditCategoryState extends ConsumerState<AddEditCategory> with WidgetsBindingObserver, ZoomAwareMixin  {

  ///Init Override
  @override
  void initState() {
    if(ref.read(drawerController).isSubScreenCanViewSidebarAndCanView){
      final addEditCategoryWatch = ref.read(addEditCategoryController);
      addEditCategoryWatch.disposeController();
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        addEditCategoryWatch.getLanguageListModel();
        if(widget.isEdit == true){
          addEditCategoryWatch.categoryDetailsAPI(context, widget.uuid??'');
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
        return AddEditCategoryWeb(isEdit: widget.isEdit,uuid: widget.uuid);
      },
      desktop: (BuildContext context) {
        return AddEditCategoryWeb(isEdit: widget.isEdit,uuid: widget.uuid);
      },
      tablet: (BuildContext context) {
        return AddEditCategoryWeb(isEdit: widget.isEdit,uuid: widget.uuid);
      },
    );
  }
}

