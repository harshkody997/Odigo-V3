import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/drawer/web/base_drawer_page_widget.dart';
import 'package:odigov3/ui/master/destination_type/web/helper/add_edit_destination_type_form_widget.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/theme/text_style.dart';
import 'package:odigov3/ui/utils/widgets/common_anim_loader.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';
import '../../../../framework/controller/master/destination_type/add_edit_destination_type_controller.dart';

class AddEditDestinationTypeWeb extends ConsumerStatefulWidget {
  final String? uuid;
  const AddEditDestinationTypeWeb({Key? key,this.uuid}) : super(key: key);

  @override
  ConsumerState<AddEditDestinationTypeWeb> createState() => _AddEditDestinationTypeWebState();
}

class _AddEditDestinationTypeWebState extends ConsumerState<AddEditDestinationTypeWeb> {

  ///Dispose Override
  @override
  void dispose() {
    super.dispose();
  }

  ///Build Override
  @override
  Widget build(BuildContext context) {
    final addEditDestinationTypeWatch = ref.watch(addEditDestinationTypeController);
    return BaseDrawerPageWidget(
      body: addEditDestinationTypeWatch.destinationTypeDetailsState.isLoading
          ? CommonAnimLoader()
          : Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: AppColors.clr101828.withValues(alpha: 0.6), blurRadius: 2, offset: Offset(0, 1)),
            BoxShadow(color: AppColors.clr101828.withValues(alpha: 0.1), blurRadius: 3, offset: Offset(0, 1)),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// add/edit destination type text
              CommonText(title: widget.uuid != null ? LocaleKeys.keyEditDestinationType.localized : LocaleKeys.keyAddDestinationType.localized,
                  fontWeight: TextStyles.fwSemiBold
              ).paddingOnly(bottom: context.height * 0.024),

              /// destination textFields
              AddEditDestinationTypeFormWidget(uuid: widget.uuid)
            ],
          ).paddingAll(context.height * 0.025),
        ).paddingAll(context.height * 0.01),
      ),
    );
  }

}
