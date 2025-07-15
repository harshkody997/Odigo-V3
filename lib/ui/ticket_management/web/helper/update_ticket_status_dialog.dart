import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/ticket_management/ticket_management_controller.dart';
import 'package:odigov3/framework/provider/network/network.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/form_validations.dart';
import 'package:odigov3/ui/utils/app_enums.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';
import 'package:odigov3/ui/utils/widgets/common_form_field.dart';
import 'package:odigov3/ui/utils/widgets/common_searchable_dropdown.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class UpdateTicketStatusDialog extends ConsumerStatefulWidget {
  final String ticketUuid;
  final String status;
  UpdateTicketStatusDialog({super.key, required this.ticketUuid,required this.status });

  @override
  ConsumerState<UpdateTicketStatusDialog> createState() =>
      _UpdateTicketStatusDialogState();
}

class _UpdateTicketStatusDialogState
    extends ConsumerState<UpdateTicketStatusDialog> {
  ///Build Override
  @override
  Widget build(BuildContext context) {
    return _bodyWidget();
  }

  ///Body Widget
  Widget _bodyWidget() {
    final ticketWatch = ref.watch(ticketManagementController);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            ///Back Icon
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: CommonSVG(
                strIcon: Assets.svgs.svgLeftArrow.keyName,
                height: context.height * 0.020,
                width: context.height * 0.020,
              ),
            ),
            SizedBox(width: context.width * 0.01),

            ///Change ticket title
            CommonText(
              title: LocaleKeys.keyUpdateTicketStatus.localized,
              style: TextStyles.bold.copyWith(
                fontSize: 24,
                color: AppColors.black,
              ),
            ),
          ],
        ),
        SizedBox(height: context.height * 0.01),

        ///ticket description
        CommonText(
          title: LocaleKeys.keyUpdateTicketStatusDescriptionTitle.localized,
          style: TextStyles.regular.copyWith(color: AppColors.black),
          maxLines: 2,
        ),
        const Spacer(),

        ///Form
        Form(
          key: ticketWatch.formKey,
          child: Column(
            children: [
              /// ticket status dropdown
              CommonSearchableDropdown<TicketStatusType>(
                hintText: LocaleKeys.keySelectStatus.localized,
                enableSearch: false,
                hintTextStyle: TextStyles.regular.copyWith(
                  fontSize: 12,
                  color: AppColors.clr8D8D8D,
                ),
                onSelected: (value) => ticketWatch.updateStatusDropdown(value),
                textEditingController: ticketWatch.ticketStatusCtr,
                items: widget.status ==  TicketStatus.ACKNOWLEDGED.name ? ticketWatch.statusForAcknowledge : ticketWatch.statusList,
                validator: (value) => validateText(
                  value,
                  LocaleKeys.keyTicketStatusRequired.localized,
                ),
                //onFieldSubmitted: (value) => addEditTicketReasonWatch.languageListTextFields.first.focusNode?.requestFocus(),
                title: (value) => value.text,
              ),

              SizedBox(height: context.height * 0.025),

              ///comment text field
              CommonInputFormField(
                textEditingController: ticketWatch.ticketCommentCtr,
                hintText: LocaleKeys.keyComment.localized,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (value) {
                  //profileWatch.passwordFocus.requestFocus();
                },
                maxLines: 4,
                maxLength: 400,
                validator: (value) {
                  return validateText(value, LocaleKeys.keyCommentIsRequired.localized);
                },
              ),
            ],
          ),
        ),
        const Spacer(),

        ///Change status
        CommonButton(
          onTap: () async {
            if (ticketWatch.formKey.currentState?.validate() ?? false) {
              if (context.mounted) {
                await ticketWatch.updateTicketStatusApi(
                  context,
                  ticketUuid: widget.ticketUuid,
                );
                if (ticketWatch.updateTicketStatusState.success?.status ==
                    ApiEndPoints.apiStatus_200) {
                  Navigator.pop(
                    ticketWatch.ticketStatusDialogKey.currentContext!,
                  );
                  ticketWatch.ticketListApi(context);
                }
              }
            }
          },
          isLoading: ticketWatch.updateTicketStatusState.isLoading,
          width: context.width,
          height: context.height * 0.080,
          buttonText: LocaleKeys.keyDone.localized,
        ),
      ],
    ).paddingSymmetric(
      horizontal: context.height * 0.050,
      vertical: context.height * 0.030,
    );
  }
}
