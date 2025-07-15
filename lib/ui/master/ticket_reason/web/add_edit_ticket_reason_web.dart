import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/master/ticket_reason/add_edit_ticket_reason_controller.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/drawer/web/base_drawer_page_widget.dart';
import 'package:odigov3/ui/master/ticket_reason/web/add_edit_ticket_reason_form_widget.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/theme/text_style.dart';
import 'package:odigov3/ui/utils/widgets/common_anim_loader.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class AddEditTicketReasonWeb extends ConsumerStatefulWidget {
  final bool? isEdit;
  final String? uuid;
  const AddEditTicketReasonWeb({Key? key,this.isEdit,this.uuid}) : super(key: key);

  @override
  ConsumerState<AddEditTicketReasonWeb> createState() => _AddEditTicketReasonWebState();
}

class _AddEditTicketReasonWebState extends ConsumerState<AddEditTicketReasonWeb> {

  ///Dispose Override
  @override
  void dispose() {
    super.dispose();
  }

  ///Build Override
  @override
  Widget build(BuildContext context) {
    final addEditTicketReasonWatch = ref.watch(addEditTicketReasonController);
    return BaseDrawerPageWidget(
      body: addEditTicketReasonWatch.ticketReasonDetailsState.isLoading
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
              /// add ticket reason text
              CommonText(title: widget.isEdit == true ? LocaleKeys.keyEditTicketReason.localized : LocaleKeys.keyAddTicketReason.localized, fontWeight: TextStyles.fwSemiBold).paddingOnly(bottom: 24),

              /// ticket reason textField form widget
              AddEditTicketReasonFormWidget(isEdit: widget.isEdit,uuid: widget.uuid,),
            ],
          ).paddingAll(context.height * 0.025).paddingAll(context.height * 0.01),
        ),
      ),
    );
  }
}
