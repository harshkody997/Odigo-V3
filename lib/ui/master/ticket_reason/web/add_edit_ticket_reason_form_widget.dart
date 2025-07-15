import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/master/ticket_reason/add_edit_ticket_reason_controller.dart';
import 'package:odigov3/framework/controller/master/ticket_reason/ticket_reason_list_controller.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/form_validations.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/app_enums.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/theme/text_style.dart';
import 'package:odigov3/ui/utils/widgets/common_anim_loader.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';
import 'package:odigov3/ui/utils/widgets/common_searchable_dropdown.dart';
import 'package:odigov3/ui/utils/widgets/dynamic_lang_form_widget.dart';

class AddEditTicketReasonFormWidget extends ConsumerStatefulWidget {
  final bool? isEdit;
  final String? uuid;
  const AddEditTicketReasonFormWidget({super.key,this.isEdit,this.uuid,});

  @override
  ConsumerState<AddEditTicketReasonFormWidget> createState() => _AddEditTicketReasonFormWidgetState();
}

class _AddEditTicketReasonFormWidgetState extends ConsumerState<AddEditTicketReasonFormWidget> {

  @override
  Widget build(BuildContext context) {
    final addEditTicketReasonWatch = ref.watch(addEditTicketReasonController);
    return AbsorbPointer(
      absorbing: addEditTicketReasonWatch.isLoading || addEditTicketReasonWatch.ticketReasonDetailsState.isLoading,
      child: Form(
        key: addEditTicketReasonWatch.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [

            /// platform type dropdown
            CommonSearchableDropdown<TicketReasonPlatformType>(
              hintText: LocaleKeys.keyPlatformType.localized,
              enableSearch: false,
              onSelected: (value) => addEditTicketReasonWatch.updatePlatformTypeDropdown(value),
              textEditingController: addEditTicketReasonWatch.platformTypeCtr,
              items: addEditTicketReasonWatch.platformTypeList,
              validator: (value) => validateText(value, LocaleKeys.keyPlatformTypeIsRequired.localized),
              onFieldSubmitted: (value) => addEditTicketReasonWatch.languageListTextFields.first.focusNode?.requestFocus(),
              title: (value) => value.text,
            ).paddingOnly(bottom: context.height * 0.025),

            /// ticket reason form field
            DynamicLangFormManager.instance.dynamicWidget(
              addEditTicketReasonWatch.languageListTextFields,
              DynamicFormEnum.TICKET_REASON,
              fieldWidth: context.width,
              onFieldSubmitted: (value) => checkValidateAndApiCall(ref)
            ),

            /// save continue & back buttons
            Row(
              children: [
                /// save continue button
                CommonButton(
                  width: context.width * 0.1,
                  borderRadius: BorderRadius.circular(8),
                  fontSize: 14,
                  buttonText: LocaleKeys.keySave.localized,
                  isLoading: addEditTicketReasonWatch.isLoading,
                  onTap: () => checkValidateAndApiCall(ref)
                ).paddingOnly(right: context.width * 0.01),

                /// back button
                CommonButton(
                  width: context.width * 0.1,
                  borderRadius: BorderRadius.circular(8),
                  fontSize: 14,
                  buttonText: LocaleKeys.keyBack.localized,
                  borderColor: AppColors.black,
                  backgroundColor: AppColors.transparent,
                  buttonTextColor: AppColors.clr787575,
                  onTap: () => ref.read(navigationStackController).pop()
                ),
              ],
            ).paddingOnly(top: context.height * 0.025),
          ],
        ),
      ),
    );
  }

    void checkValidateAndApiCall(WidgetRef ref) {
    final addEditTicketReasonWatch = ref.watch(addEditTicketReasonController);
    bool isValid = addEditTicketReasonWatch.formKey.currentState?.validate() ?? false;
    if (isValid) {
      if(widget.isEdit == true){
        addEditTicketReasonWatch.editTicketReasonAPI(context,widget.uuid??'').then((value){
          if(value.success?.status == ApiEndPoints.apiStatus_200){
            ref.read(ticketReasonListController).clearTicketReasonList();
            ref.read(ticketReasonListController).getTicketReasonListAPI(context);
            ref.read(navigationStackController).pop();
          }
        });
      }else{
        addEditTicketReasonWatch.addTicketReasonAPI(context).then((value){
          if(value.success?.status == ApiEndPoints.apiStatus_200){
            ref.read(ticketReasonListController).clearTicketReasonList();
            ref.read(ticketReasonListController).getTicketReasonListAPI(context);
            ref.read(navigationStackController).pop();
          }
        });
      }
    }
  }
}
