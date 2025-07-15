import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/ticket_management/ticket_management_controller.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/utils/app_enums.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';
import 'package:odigov3/ui/utils/widgets/common_form_field.dart';
import 'package:odigov3/ui/utils/widgets/common_radio_button.dart';
import 'package:odigov3/ui/utils/widgets/common_range_date_picker.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class TicketListFilterDialog extends ConsumerStatefulWidget {
  TicketListFilterDialog({super.key});

  @override
  ConsumerState<TicketListFilterDialog> createState() =>
      _TicketListFilterDialogState();
}

class _TicketListFilterDialogState
    extends ConsumerState<TicketListFilterDialog> {
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ///Filter title
            CommonText(
              title: LocaleKeys.keyFilters.localized,
              style: TextStyles.semiBold.copyWith(
                fontSize: 20,
                color: AppColors.clr101828,
              ),
            ),

            ///Cross Icon
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: CommonSVG(
                strIcon: Assets.svgs.svgCrossIconBg.keyName,
                height: context.height * 0.040,
                width: context.height * 0.040,
              ),
            ),
          ],
        ).paddingOnly(
          left: context.width * 0.02,
          right: context.width * 0.02,
          top: context.height * 0.02,
        ),
        Divider(
          color: AppColors.clrEAECF0,
          height: 1,
        ).paddingSymmetric(vertical: context.height * 0.02),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///filter by date text
            CommonText(
              title: LocaleKeys.keyFilterByDateRange.localized,
              style: TextStyles.semiBold.copyWith(color: AppColors.clr101828),
            ),

            SizedBox(height: context.height * 0.02),

            ///date selection field
            InkWell(
              onTap: () async {
                ///Range Date Picker
                commonRangeDatePickerDialog(
                  context,
                  isRangePicker: true,
                  selectedStartDate: DateTime.now(),
                  selectedEndDate: DateTime.now(),
                  firstDate: DateTime(2000, 1, 1),
                  lastDate: DateTime.now(),
                  onSelect: (dateList) {
                    ///Change Selected Date Value
                    ticketWatch.changeDateValue(dateList);
                  },
                );
              },

              child: CommonInputFormField(
                hintText: LocaleKeys.keyDDMMYYYY.localized,
                isEnable: false,
                prefixWidget: CommonSVG(
                  strIcon: Assets.svgs.svgCalendar.keyName,
                  height: 10,
                  width: 10,
                  boxFit: BoxFit.scaleDown,
                ),
                fontSize: 13,
                hintTextStyle: TextStyles.regular.copyWith(color: AppColors.clr7C7474, fontSize: 13),
                textEditingController: ticketWatch.dateController,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  ///Date Validation
                  return null;
                },
              ),
            ),

            Divider(
              color: AppColors.clrE5E7EB,
              height: 1,
            ).paddingSymmetric(vertical: context.height * 0.02),

            ///Select Status of ticket list
            CommonText(
              title: LocaleKeys.keyStatusType.localized,
              style: TextStyles.semiBold.copyWith(color: AppColors.black),
            ).paddingOnly(bottom: context.height * 0.016),

            ...ticketWatch.statusOptions.map(
                  (status) => CommonRadioButton<TicketStatusType>(
                      value: status,
                      title: status.key.localized,
                      borderRequired: true,
                      groupValue: ticketWatch.selectedStatus,
                      onTap: () {
                        ticketWatch.changeSelectedStatus(status);
                      },
              ).paddingOnly(bottom: 8),
            ),
          ],
        ).paddingOnly(
          left: context.width * 0.02,
          right: context.width * 0.02,
          bottom: context.height * 0.02,
        ),
        Spacer(),
        Divider(color: AppColors.clrEAECF0, height: 1),

        ///Applied and cancel  button
        Row(
          children: [
            ///Back button
            Expanded(
              child: CommonButton(
                onTap: () async {
                  ticketWatch.clearFilterValues(isNotify: true);
                  Navigator.pop(
                    ticketWatch.ticketFilterDialogKey.currentContext!,
                  );
                  if (ticketWatch.isFilterApplied) {
                    await ticketWatch.ticketListApi(context);
                  }
                  ticketWatch.updateFilterApplied(false);
                },
                buttonText: LocaleKeys.keyClearFilter.localized,
                buttonTextColor: AppColors.clr6A7282,
                backgroundColor: AppColors.white,
                borderColor: AppColors.clrD1D5DC,
              ),
            ),
            SizedBox(width: context.width * 0.012),

            ///Applied filter button
            Expanded(
              child: CommonButton(
                buttonText: LocaleKeys.keyApplyFilter.localized,
                backgroundColor: (ticketWatch.dateController.text != '' ||
                    (ticketWatch.selectedStatus != null && ticketWatch.selectedStatus != TicketStatusType.ALL))
                    ? AppColors.clr2997FC
                    : AppColors.clrDCDDFF,
                onTap: () async {
                  Navigator.pop(
                    ticketWatch.ticketFilterDialogKey.currentContext!,
                  );
                  ticketWatch.updateFilterApplied(true);
                  if (ticketWatch.dateController.text != '' ||
                      ticketWatch.selectedStatus != null) {
                    await ticketWatch.ticketListApi(context);
                  }
                },
              ),
            ),
          ],
        ).paddingSymmetric(
          horizontal: context.width * 0.025,
          vertical: context.height * 0.016,
        ),
      ],
    );
  }
}
