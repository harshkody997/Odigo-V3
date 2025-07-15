import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/ads_timline/history_listing_controller.dart';
import 'package:odigov3/framework/controller/client/client_list_controller.dart';
import 'package:odigov3/framework/controller/destination/destination_controller.dart';
import 'package:odigov3/framework/repository/client/model/response/client_list_response_model.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/form_validations.dart';
import 'package:odigov3/ui/ads_timeline/web/helper/history_list.dart';
import 'package:odigov3/ui/drawer/web/base_drawer_page_widget.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/text_style.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';
import 'package:odigov3/ui/utils/widgets/common_dialog.dart';
import 'package:odigov3/ui/utils/widgets/common_form_field.dart';
import 'package:odigov3/ui/utils/widgets/common_range_date_picker.dart';
import 'package:odigov3/ui/utils/widgets/common_searchable_dropdown.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class HistoryListingWeb extends ConsumerStatefulWidget {
  const HistoryListingWeb({super.key});

  @override
  ConsumerState<HistoryListingWeb> createState() => _HistoryListingWebState();
}

class _HistoryListingWebState extends ConsumerState<HistoryListingWeb> {
  ///Build Override
  @override
  Widget build(BuildContext context) {
    final historyListingWatch = ref.watch(historyListingController);
    final destinationWatch = ref.watch(destinationController);

    return Scaffold(
      body: BaseDrawerPageWidget(
        showFilters: true,
        // showFilters: historyListingWatch.historyList.isNotEmpty,
        isFilterApplied: historyListingWatch.isFilterApplied,
        filterButtonOnTap: () {
          /// reset value
          // historyListingWatch.updateTempSelectedStatus(historyListingWatch.selectedFilter);
          // historyListingWatch.updateTempSelectedClient(historyListingWatch.selectedClientFilter);

          /// open filter dialog
          showCommonDetailDialog(
            keyBadge: historyListingWatch.filterKey,
            context: context,
            dialogBody: Consumer(
              builder: (context, ref, child) {
                final clientWatch = ref.watch(clientListController);
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
                            Navigator.of(context).pop();
                          },
                          child: CommonSVG(
                            strIcon: Assets.svgs.svgCrossIconBg.keyName,
                            height: context.height * 0.05,
                            width: context.height * 0.05,
                          ),
                        ),
                      ],
                    ).paddingSymmetric(horizontal: context.width * 0.01),

                    Divider(color: AppColors.clrE5E7EB).paddingSymmetric(vertical: context.height * 0.01),
                    CommonText(
                      title: LocaleKeys.keyFilterByClientName.localized,
                      fontSize: 14,
                      fontWeight: TextStyles.fwSemiBold,
                    ).paddingOnly(bottom: context.height * 0.015),
                    CommonSearchableDropdown<ClientData>(
                      onSelected: (value) {
                        historyListingWatch.updateTempSelectedClient(value);
                        historyListingWatch.getAdsSequenceHistoryApi(context, odigoClientUuid: value.uuid ?? '');
                        Navigator.of(context).pop();
                      },
                      title: (value) {
                        return (value.name ?? '');
                      },
                      textEditingController: historyListingWatch.clientCtr,
                      items: clientWatch.clientList,
                      validator: (value) => null,
                      hintText: LocaleKeys.keySelectClientName.localized,
                      onScrollListener: () async {
                        if (!clientWatch.clientListState.isLoadMore && clientWatch.clientListState.success?.hasNextPage == true) {
                          if (mounted) {
                            await clientWatch.getClientApi(context, pagination: true, activeRecords: true);
                            ref.read(searchController).notifyListeners();
                          }
                        }
                      },
                    ),

                    Spacer(),

                    Divider(color: AppColors.clrE5E7EB, height: context.height * 0.05),

                    /// Clear Button
                    CommonButton(
                      buttonText: LocaleKeys.keyClearFilter.localized,
                      buttonTextColor: AppColors.clr6A7282,
                      backgroundColor: AppColors.white,
                      borderColor: AppColors.clrD1D5DC,
                      onTap: () {
                        historyListingWatch.resetFilter();
                        historyListingWatch.getAdsSequenceHistoryApi(context);
                        Navigator.of(context).pop();
                      },
                    ).paddingOnly(bottom: 10),
                  ],
                ).paddingSymmetric(vertical: context.height * 0.01, horizontal: context.width * 0.01);
              },
            ),
            height: 1,
            width: 0.5,
          );
        },
        body: Column(
          children: [
            Row(
              children: [
                /// Destination Dropdown
                Expanded(
                  flex: 7,
                  child: CommonSearchableDropdown(
                    // isEnable: (widget.uuid?.isEmpty ?? false),
                    hintText: LocaleKeys.keySelectDestination.localized,
                    onSelected: (value) {
                      historyListingWatch.updateDestinationDropdown(value.name ?? '', value.uuid ?? '');
                      historyListingWatch.getAdsSequenceHistoryApi(context, destinationUuid: value.uuid ?? '');
                    },
                    textEditingController: historyListingWatch.searchDestinationController,
                    items: destinationWatch.destinationList,
                    validator: (value) {
                      return validateText(value, LocaleKeys.keyDestinationSelectionRequired.localized);
                    },
                    title: (str) {
                      return str.name ?? '';
                    },
                    onScrollListener: () async {
                      if (!destinationWatch.destinationListState.isLoadMore && destinationWatch.destinationListState.success?.hasNextPage == true) {
                        await destinationWatch.getDestinationListApi(context, isReset: true);
                      }
                    },
                  ),
                ),

                SizedBox(width: 10),

                /// Date Selection Field
                Expanded(
                  flex: 3,
                  child: InkWell(
                    onTap: () async {
                      ///Range Date Picker
                      commonRangeDatePickerDialog(
                        context,
                        isRangePicker: false,
                        selectedStartDate: DateTime.now(),
                        selectedEndDate: DateTime.now(),
                        firstDate: DateTime(2000, 1, 1),
                        lastDate: DateTime.now(),
                        onSelect: (dateList) {
                          ///Change Selected Date Value
                          historyListingWatch.changeSelectedDateValue(dateList);
                          historyListingWatch.getAdsSequenceHistoryApi(context);
                        },
                      );
                    },

                    child: CommonInputFormField(
                      hintText: LocaleKeys.keyDDMMYYYY.localized,
                      isEnable: false,
                      giveConstraints: false,
                      suffixWidget: CommonSVG(
                        strIcon: Assets.svgs.svgCalendar.keyName,
                        height: 10,
                        width: 10,
                        boxFit: BoxFit.scaleDown,
                      ),
                      fontSize: 13,
                      hintTextStyle: TextStyles.regular.copyWith(color: AppColors.clr7C7474, fontSize: 13),
                      textEditingController: historyListingWatch.dateController,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        ///Date Validation
                        return null;
                      },
                    ),
                  ),
                ),
              ],
            ).paddingOnly(bottom: 10),

            Expanded(child: HistoryList()),
          ],
        ),
      ),
    );
  }
}
