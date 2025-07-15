import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/users_management/add_new_user_controller.dart';
import 'package:odigov3/ui/drawer/web/base_drawer_page_widget.dart';
import 'package:odigov3/ui/user_management/web/helper/add_new_user_form_widget.dart';
import 'package:odigov3/ui/utils/widgets/common_anim_loader.dart';

class AddNewUserWeb extends ConsumerWidget {
  final String? userUuid;
  final BuildContext mainContext;
  final Function? popCallBack;

  AddNewUserWeb({this.userUuid, required this.mainContext, this.popCallBack, super.key});

  ///Build Override
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addNewUserWatch = ref.watch(addNewUserController);
    return BaseDrawerPageWidget(
      body: addNewUserWatch.getUserDetailsApiState.isLoading || addNewUserWatch.getAssignTypeApiState.isLoading
          ? CommonAnimLoader()
          : AddNewUserFormWidget(userUuid: userUuid, mainContext: mainContext),
    );
  }
}
