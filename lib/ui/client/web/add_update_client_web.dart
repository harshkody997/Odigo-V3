import 'package:flutter/material.dart';
import 'package:odigov3/ui/client/web/helper/add_edit_client_form_widget.dart';
import 'package:odigov3/ui/drawer/web/base_drawer_page_widget.dart';

class AddUpdateClientWeb extends StatelessWidget {
  final Function? popCallBack;
  final String? clientUuid;

  const AddUpdateClientWeb({super.key, this.popCallBack, this.clientUuid});

  ///Build Override
  @override
  Widget build(BuildContext context) {
    return BaseDrawerPageWidget(
      body: Container(
        decoration: BoxDecoration(shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(20)),
        child: AddEditClientFormWidget(clientUuid: clientUuid, popCallBack: popCallBack),
      ),
    );
  }
}
