import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/repository/common_response/common_enum_title_value_model.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/text_style.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';
import 'package:odigov3/ui/utils/widgets/common_radio_button.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

/// A reusable widget for showing a status-type filter dialog,
/// including status selection and Apply/Clear actions.
class CommonStatusTypeFilterWidget extends ConsumerStatefulWidget {
  /// The current selected value for radio group
  final CommonEnumTitleValueModel? groupValue;

  /// Callback fired when a filter is selected
  final GestureTapCallback? Function(CommonEnumTitleValueModel filterType)? onSelectFilterTap;

  /// Callback fired when Apply button is tapped
  final GestureTapCallback? onApplyFilterTap;

  /// Callback fired when Clear button is tapped
  final GestureTapCallback? onClearFilterTap;

  /// Callback fired when Close (X) button is tapped
  final GestureTapCallback? onCloseTap;

  /// Whether any filter is currently selected
  final bool isFilterSelected;

  /// Whether tapping Clear should close dialog
  final bool isClearFilterCall;

  /// Whether tapping Clear should close dialog
  final Widget? otherFilterWidget;

  /// for deployment build status
  final bool isForBuildStatus;

  const CommonStatusTypeFilterWidget({
    super.key,
    this.groupValue,
    this.onApplyFilterTap,
    this.onClearFilterTap,
    this.onSelectFilterTap,
    this.onCloseTap,
    this.isFilterSelected = false,
    this.isClearFilterCall = false,
    this.otherFilterWidget,
    this.isForBuildStatus = false
  });

  @override
  ConsumerState<CommonStatusTypeFilterWidget> createState() => _CommonStatusTypeFilterWidgetState();
}

class _CommonStatusTypeFilterWidgetState extends ConsumerState<CommonStatusTypeFilterWidget> {
  @override
  Widget build(BuildContext context) {
    List<CommonEnumTitleValueModel> statusList = !(widget.isForBuildStatus) ? commonActiveDeActiveList : commonFilterStatusList;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// Top Header: Title + Close Icon
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CommonText(
              title: LocaleKeys.keyFilters.localized,
              fontSize: 18,
              fontWeight: TextStyles.fwSemiBold,
            ),
            InkWell(
              onTap: () {
                widget.onCloseTap?.call();
                Navigator.of(context).pop();
              },
              child: CommonSVG(
                strIcon: Assets.svgs.svgCrossIconBg.keyName,
                height: context.height * 0.05,
                width: context.height * 0.05,
              ),
            )
          ],
        ).paddingSymmetric(horizontal: context.width * 0.01),

        Divider(color: AppColors.clrE5E7EB),

        /// Filter List Section
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonText(
                title: LocaleKeys.keyStatusType.localized,
                fontSize: 14,
                fontWeight: TextStyles.fwSemiBold,
              ).paddingSymmetric(vertical: context.height * 0.015),

              /// Radio Button List
              ListView.separated(
                shrinkWrap: true,
                itemCount: statusList.length,
                itemBuilder: (context, index) {
                  final item = statusList[index];
                  return CommonRadioButton<CommonEnumTitleValueModel>(
                    value: item,
                    title: item.title.localized,
                    borderRequired: true,
                    groupValue: widget.groupValue,
                    onTap: () {
                      widget.onSelectFilterTap?.call(item);
                    },
                  );
                },
                separatorBuilder: (context, index) => SizedBox(height: context.height * 0.015),
              ),

              widget.otherFilterWidget ?? Offstage()
            ],
          ).paddingSymmetric(horizontal: context.width * 0.01),
        ),

        Divider(color: AppColors.clrE5E7EB, height: context.height * 0.05),

        /// Bottom Buttons: Clear + Apply
        Row(
          children: [
            /// Clear Button
            Expanded(
              child: CommonButton(
                buttonText: LocaleKeys.keyClearFilter.localized,
                buttonTextColor: AppColors.clr6A7282,
                backgroundColor: AppColors.white,
                borderColor: AppColors.clrD1D5DC,
                onTap: () {
                  if (widget.isClearFilterCall) {
                    widget.onClearFilterTap?.call();
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),

            SizedBox(width: context.width * 0.012),

            /// Apply Button
            Expanded(
              child: CommonButton(
                buttonText: LocaleKeys.keyApplyFilter.localized,
                backgroundColor: widget.isFilterSelected
                    ? AppColors.clr2997FC
                    : AppColors.clrDCDDFF,
                onTap: () {
                  if (widget.isFilterSelected) {
                    widget.onApplyFilterTap?.call();
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
          ],
        ).paddingSymmetric(horizontal: context.width * 0.01),
      ],
    ).paddingSymmetric(vertical: context.height * 0.01);
  }
}
