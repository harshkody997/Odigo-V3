import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddEditCategoryMobile extends ConsumerStatefulWidget {
  const AddEditCategoryMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<AddEditCategoryMobile> createState() =>
      _AddEditCategoryMobileState();
}

class _AddEditCategoryMobileState extends ConsumerState<AddEditCategoryMobile> {

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
