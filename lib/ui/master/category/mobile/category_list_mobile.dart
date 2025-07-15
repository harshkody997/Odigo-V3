import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';
import 'package:odigov3/framework/controller/master/category/category_list_controller.dart';

class CategoryListMobile extends ConsumerStatefulWidget {
  const CategoryListMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<CategoryListMobile> createState() => _CategoryListMobileState();
}

class _CategoryListMobileState extends ConsumerState<CategoryListMobile> {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final categoryListWatch = ref.read(categoryListController);
      categoryListWatch.disposeController(isNotify : true);
    });
  }

  ///Dispose Override
  @override
  void dispose() {
    super.dispose();
  }

  ///Build Override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyWidget(),
    );
  }

  ///Body Widget
  Widget _bodyWidget() {
    return Container();
  }


}
