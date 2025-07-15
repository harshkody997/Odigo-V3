import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/master/ticket_reason/ticket_reason_list_controller.dart';
import 'package:odigov3/framework/controller/ticket_management/ticket_management_controller.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/repository/master/ticket_reason/model/ticket_reason_list_response_model.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/form_validations.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';
import 'package:odigov3/ui/utils/widgets/common_form_field.dart';
import 'package:odigov3/ui/utils/widgets/common_searchable_dropdown.dart';

class CreateTicketFormWidget extends ConsumerStatefulWidget {
  const CreateTicketFormWidget({super.key});

  @override
  ConsumerState<CreateTicketFormWidget> createState() =>
      _CreateTicketFormWidgetState();
}

class _CreateTicketFormWidgetState
    extends ConsumerState<CreateTicketFormWidget> {
  @override
  Widget build(BuildContext context) {
    final ticketWatch = ref.watch(ticketManagementController);
    final ticketReasonListWatch = ref.read(ticketReasonListController);

    return Form(
      key: ticketWatch.createTicketFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          /// select ticket reason dropdown
          CommonSearchableDropdown<TicketReasonModel>(
            hintText: LocaleKeys.keySelectReason.localized,
            onSelected: (value) => ticketWatch.updateReasonDropdown(value),
            textEditingController: ticketWatch.ticketReasonController,
            items: ticketReasonListWatch.ticketReasonList,
            validator: (value) => validateText(
              value,
              LocaleKeys.keyTicketReasonRequired.localized,
            ),
            title: (value) {
              return value.reason ?? '';
            },
            onScrollListener: () async {
              if (!ticketReasonListWatch.ticketReasonListState.isLoadMore &&
                  ticketReasonListWatch
                          .ticketReasonListState
                          .success
                          ?.hasNextPage ==
                      true) {
                if (mounted) {
                  await ticketReasonListWatch.getTicketReasonListAPI(
                    context,
                    pagination: true,
                    activeRecords: true,
                    platformType: 'DESTINATION'
                  );
                }
              }
            },
          ).paddingOnly(bottom: 24),

          ///message for ticket text field
          CommonInputFormField(
            textEditingController: ticketWatch.ticketCommentCtr,
            hintText: LocaleKeys.keyMessage.localized,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (value) {
              createTicketApiCall(ref);
            },
            maxLines: 4,
            maxLength: 400,
            onChanged: (value) {
            },
            validator: (value) {
              return validateText(value, LocaleKeys.keyMessageRequired.localized);
            },
          ),

          /// save continue & back buttons
          Row(
            children: [
              /// save continue button
              CommonButton(
                width: context.width * 0.12,
                borderRadius: BorderRadius.circular(8),
                fontSize: 14,
                buttonText: LocaleKeys.keySave.localized,
                isLoading: ticketWatch.createTicketState.isLoading,
                ///create ticket api call
                onTap: () => createTicketApiCall(ref),
              ).paddingOnly(right: context.width * 0.01),

              /// back button
              CommonButton(
                width: context.width * 0.12,
                borderRadius: BorderRadius.circular(8),
                fontSize: 14,
                buttonText: LocaleKeys.keyBack.localized,
                borderColor: AppColors.clr9E9E9E,
                backgroundColor: AppColors.transparent,
                buttonTextColor: AppColors.clr787575,
                onTap: () => ref.read(navigationStackController).pop(),
              ),
            ],
          ).paddingOnly(top: 24),
        ],
      ),
    );
  }

  ///create ticket api
  void createTicketApiCall(WidgetRef ref) {
    final ticketWatch = ref.watch(ticketManagementController);
    bool isValid =
        ticketWatch.createTicketFormKey.currentState?.validate() ?? false;
    if (isValid) {
      ticketWatch.createTicketApi(context).then((value) {
        if (ticketWatch.createTicketState.success?.status ==
            ApiEndPoints.apiStatus_200) {
          ref.read(navigationStackController).pop();
          ///ticket list api
          ticketWatch.ticketListApi(context);

        }
      });
    }
  }
}
