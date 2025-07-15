import 'package:flutter/material.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';
import 'package:odigov3/ui/utils/widgets/common_search_form_field.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class CommonTopScreenWidget extends StatelessWidget {

  /// Title displayed on the left side
  final String title;

  /// Shows or hides the search TextField
  final bool isShowSearchBar;

  /// Shows or hides the export button
  final bool isShowExport;

  /// Shows or hides the import button
  final bool isShowImport;

  /// Shows or hides the create button
  final bool isShowCreate;

  /// Shows or hides the filter icon
  final bool isShowFilter;

  /// Optional width for the search bar
  final double? searchBarWidth;

  /// TextEditingController for search input
  final TextEditingController? searchCtr;

  /// Placeholder text for the search textField
  final String? searchHintText;

  /// Called when search input changes
  final Function(dynamic text)? onChanged;

  /// Callback for the create button tap
  final GestureTapCallback? onCreateTap;

  /// Callback for the export button tap
  final GestureTapCallback? onExportTap;

  /// Callback for the import button tap
  final GestureTapCallback? onImportTap;

  /// Callback for the filter icon tap
  final GestureTapCallback? onFilterTap;

  const CommonTopScreenWidget({
        super.key, required this.title,
        this.isShowSearchBar = true,
        this.searchCtr,
        this.searchHintText,
        this.onChanged,
        this.searchBarWidth,
        this.isShowExport = false,
        this.isShowImport = false,
        this.isShowCreate = false,
        this.isShowFilter = false,
        this.onCreateTap,
        this.onExportTap,
        this.onImportTap,
        this.onFilterTap
      });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CommonText(
          title: title,
          fontSize: 20,
        ),

        Row(
          children: [

            /// search textField
            Visibility(
              visible: isShowSearchBar,
                child: Container(
                  width: searchBarWidth ?? 300,
                  child: CommonSearchFormField(
                    controller: searchCtr,
                    placeholder: searchHintText ?? 'Search here...',
                    borderRadius: BorderRadius.circular(25),
                    onChanged: onChanged,
                  ),
                )),

            /// filter icon
            Visibility(
              visible: isShowFilter,
              child: InkWell(
                onTap: onFilterTap,
                child: Container(
                  height: context.height * 0.06,
                  width: context.height * 0.06,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.clrE4E4E7)
                  ),
                  child: CommonSVG(
                    strIcon: Assets.svgs.svgMasterFilter.keyName,
                  ).alignAtCenter(),
                ).paddingOnly(left: context.width * 0.01),
              ),
            ),

            /// export button
            Visibility(
              visible: isShowExport,
              child: CommonButton(
                width: context.width * 0.09,
                height: context.height * 0.06,
                buttonText: LocaleKeys.keyExport.localized,
                backgroundColor: AppColors.lightPink,
                borderColor: AppColors.greyD6D6D6,
                buttonTextColor: AppColors.grey626262,
                fontSize: 14,
                onTap: onExportTap,
              ).paddingOnly(left: context.width * 0.01),
            ),

            /// import button
            Visibility(
              visible: isShowImport,
              child: CommonButton(
                width: context.width * 0.09,
                height: context.height * 0.06,
                buttonText: LocaleKeys.keyImport.localized,
                backgroundColor: AppColors.lightPink,
                borderColor: AppColors.greyD6D6D6,
                buttonTextColor: AppColors.grey626262,
                fontSize: 14,
                onTap: onImportTap,
              ).paddingOnly(left: context.width * 0.01),
            ),

            /// create button
            Visibility(
              visible: isShowCreate,
              child: CommonButton(
                width: context.width * 0.09,
                height: context.height * 0.06,
                buttonText: LocaleKeys.keyCreate.localized,
                fontSize: 14,
                onTap: onCreateTap,
              ).paddingOnly(left: context.width * 0.01),
            )
          ],
        ),
      ],
    );
  }
}

/// Example usage of only Title:
/// ```dart
/// CommonTopScreenWidget(
///   title: 'City Master',
///   isShowSearchBar: false,
/// )
/// ```



/// Example usage:
/// ```dart
/// CommonTopScreenWidget(
///   title: 'City Master',
///   isShowSearchBar: true,
///   searchCtr: searchController,
///   onChanged: (val) => onSearchChanged(val),
///   isShowExport: true,
///   onExportTap: handleExport,
///   isShowCreate: true,
///   onCreateTap: handleCreate,
/// )
/// ```