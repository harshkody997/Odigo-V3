import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/ui/drawer/web/drawer_web.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_appbar.dart';

class BaseDrawerPageWidget extends ConsumerWidget {
  final Widget body;

  ///Total item count(Country : 5)
  final int? totalCount;

  ///To show full screen loader with ignorePointer
  final bool? isApiLoading;

  ///List Name (Countries)
  final String? listName;

  ///Search Controller
  final TextEditingController? searchController;

  ///Search Place holder Text
  final String? searchPlaceHolderText;

  ///Add Button Text
  final String? addButtonText;

  ///Search On Changed
  final Function(dynamic text)? searchOnChanged;

  ///Search OnTap
  final void Function()? searchOnTap;

  ///Import OnTap
  final void Function()? importOnTap;

  ///Export OnTap
  final void Function()? exportOnTap;

  ///Add Button OnTap
  final void Function()? addButtonOnTap;

  ///Show Search Bar
  final bool? showSearchBar;

  ///Show Export
  final bool? showExport;

  ///Show Import
  final bool? showImport;

  ///show add icon in button (default-true)
  final bool showAddIconInButton;

  ///Show Add Button
  final bool? showAddButton;


  ///Show App Bar
  final bool? showAppBar;

  ///Show Filters
  final bool? showFilters;

  final bool? showClearAll;

  ///Filter Button OnTap
  final void Function()? filterButtonOnTap;

  final void Function()? clearAllTap;

  ///Show Emergency Mode
  final bool? showEmergencyMode;

  ///Emergency Mode Switch On Changed
  final void Function()? emergencyModeOnChanged;

  ///Emergency Mode Value
  final bool? emergencyModeValue;

  ///Show More Info
  final bool? showMoreInfo;

  ///More Info On Changed
  final void Function()? moreInfoOnTap;

  ///show settings
  final bool? showSettings;

  ///show profile
  final bool? showProfile;
  final bool? showNotification;

  ///set searchbarWidth
  final double? searchbarWidth;

  ///set addButtonTextFontSize
  final double? addButtonTextFontSize;

  /// Set if filter is applied
  final bool? isFilterApplied;
  const BaseDrawerPageWidget({super.key,this.isApiLoading = false, required this.body, this.showAppBar, this.totalCount, this.listName, this.searchController, this.searchPlaceHolderText, this.searchOnChanged, this.searchOnTap, this.showSearchBar, this.importOnTap, this.exportOnTap, this.addButtonOnTap, this.addButtonText, this.showExport, this.showImport, this.showAddIconInButton = true, this.showAddButton,this.showFilters,this.showClearAll,this.filterButtonOnTap,this.clearAllTap,this.moreInfoOnTap,this.showMoreInfo,this.emergencyModeOnChanged,this.emergencyModeValue,this.showEmergencyMode, this.showSettings, this.showProfile,this.showNotification,this.searchbarWidth,this.addButtonTextFontSize, this.isFilterApplied});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IgnorePointer(
      ignoring: isApiLoading ?? false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.whiteF7F7FC,
        body: Column(
          children: [
            Visibility(
              visible: showAppBar??true,
              child: CommonAppbar(
                totalCount: totalCount,
                listName: listName,
                searchPlaceHolderText: searchPlaceHolderText,
                addButtonText: addButtonText,
                searchController: searchController,
                showExport: showExport,
                showImport: showImport,
                showSearchBar: showSearchBar,
                showAddIconInButton: showAddIconInButton,
                showAddButton: showAddButton,
                searchOnChanged: searchOnChanged,
                importOnTap: importOnTap,
                exportOnTap: exportOnTap,
                addButtonOnTap: addButtonOnTap,
                searchOnTap: searchOnTap,
                showFilters: showFilters,
                showClearAll: showClearAll,
              filterButtonOnTap: filterButtonOnTap,
              clearAllTap: clearAllTap,
              emergencyModeOnChanged: emergencyModeOnChanged,
              emergencyModeValue: emergencyModeValue,
              showEmergencyMode: showEmergencyMode,
              showMoreInfo: showMoreInfo,
              moreInfoOnTap: moreInfoOnTap,
              showSettings: showSettings,
              showProfile: showProfile,
              showNotification: showNotification,
                searchbarWidth: searchbarWidth,
                addButtonTextFontSize: addButtonTextFontSize,
                  isFilterApplied:isFilterApplied
              ),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///Left Widget
                  Expanded(child: DrawerWeb()),

                  ///Right Widget
                  ///
                  Expanded(
                    flex: 18,
                    child: Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: AppColors.whiteF7F7FC),
                      child: body,
                    ).paddingSymmetric(horizontal: context.width * 0.01, vertical: context.height * 0.02),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
