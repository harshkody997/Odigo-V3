import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/store/add_edit_store_controller.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:odigov3/ui/store/web/add_edit_store_web.dart';

class AddEditStore extends ConsumerStatefulWidget {
  final String? storeUuid;
  const AddEditStore({super.key, this.storeUuid});

  @override
  ConsumerState<AddEditStore> createState() => _AddEditStoreState();
}

class _AddEditStoreState extends ConsumerState<AddEditStore> with WidgetsBindingObserver, ZoomAwareMixin {

  ///Init Override
  @override
  void initState() {
    super.initState();
    final addEditStoreRead = ref.read(addEditStoreController);
    addEditStoreRead.disposeController();
    if(widget.storeUuid != null){
      addEditStoreRead.storeDetailState.isLoading = true;
    }

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      await addEditStoreRead.categoryDataListApi(context);
      if(widget.storeUuid != null) {
        await addEditStoreRead.storeDetailApi(context, widget.storeUuid ?? '');
        if(addEditStoreRead.storeDetailState.success?.status == ApiEndPoints.apiStatus_200){
          /// adding category to selected categories
          for(String item in addEditStoreRead.storeDetailState.success?.data?.categoryUuids ?? []) {
            addEditStoreRead.updateSelectedCategory(addEditStoreRead.categoryList.firstWhere((element) => element.uuid == item,), true);
          }
        }
      }
      addEditStoreRead.getLanguageListModel(widget.storeUuid != null);
    });
  }

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
        mobile: (BuildContext context) {
          return AddEditStoreWeb(storeUuid: widget.storeUuid);
        },
        tablet: (BuildContext context) {
          return AddEditStoreWeb(storeUuid: widget.storeUuid);
        },
        desktop: (BuildContext context) {
          return AddEditStoreWeb(storeUuid: widget.storeUuid);
        },
    );
  }
}

