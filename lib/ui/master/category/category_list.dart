import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/controller/master/category/category_list_controller.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:odigov3/ui/master/category/web/category_list_web.dart';

class CategoryList extends ConsumerStatefulWidget {
  const CategoryList({super.key});

  @override
  ConsumerState<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends ConsumerState<CategoryList> with WidgetsBindingObserver, ZoomAwareMixin {

  ///Init Override
  @override
  void initState() {
    if(ref.read(drawerController).isSubScreenCanViewSidebarAndCanView){
      final categoryListWatch = ref.read(categoryListController);
      categoryListWatch.disposeController();
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        categoryListWatch.getCategoryListAPI(context);
      });
    }
    super.initState();
  }

  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) {
        return const CategoryListWeb();
      },
      desktop: (BuildContext context) {
        return const CategoryListWeb();
      },
      tablet: (BuildContext context) {
        return const CategoryListWeb();
      },
    );
  }
}


