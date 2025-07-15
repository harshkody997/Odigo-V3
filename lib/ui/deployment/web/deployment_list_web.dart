import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/deployment/deployment_controller.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/drawer/web/base_drawer_page_widget.dart';
import 'package:odigov3/ui/master/helper/common_status_type_filter_widget.dart';
import 'package:odigov3/ui/routing/navigation_stack_item.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_dialog.dart';
import 'package:odigov3/ui/utils/widgets/common_status_button_widget.dart';
import 'package:odigov3/ui/utils/widgets/common_table_generator.dart';

class DeploymentListWeb extends ConsumerStatefulWidget {
  const DeploymentListWeb({super.key});

  @override
  ConsumerState<DeploymentListWeb> createState() => _DeploymentListWebState();
}

class _DeploymentListWebState extends ConsumerState<DeploymentListWeb> {

  ///Build Override
  @override
  Widget build(BuildContext context) {
    final deploymentWatch = ref.watch(deploymentController);
    return BaseDrawerPageWidget(
      showAddButton: true,
      addButtonOnTap: () {
        deploymentWatch.clearForm();
        ref.read(navigationStackController).push(NavigationStackItem.addDeployment());
      },
      addButtonText: LocaleKeys.keyAddNewDeployment.localized,
      totalCount: deploymentWatch.deploymentListState.success?.totalCount,
      listName: LocaleKeys.keyDeploy.localized,
      showSearchBar: true,
      searchController: deploymentWatch.searchCtr,
      searchPlaceHolderText: LocaleKeys.keySearchByDestination.localized,
      searchOnChanged: (value){
        final deploymentWatch = ref.read(deploymentController);
        if(!deploymentWatch.deploymentListState.isLoading) {
          deploymentWatch.deploymentListApi(context, searchKeyword: value);
        }
      },
      showFilters: true,
      isFilterApplied: deploymentWatch.isFilterApplied,
      filterButtonOnTap: (){
        /// open filter dialog
        showCommonDetailDialog(
          keyBadge: deploymentWatch.filterKey,
          context: context,
          dialogBody: Consumer(
              builder: (context,ref,child) {
                final deploymentWatch = ref.watch(deploymentController);
                return CommonStatusTypeFilterWidget(
                  isForBuildStatus: true,
                  groupValue: deploymentWatch.selectedTempFilter,
                  onSelectFilterTap: (filterType)=> deploymentWatch.updateTempSelectedStatus(filterType),
                  isFilterSelected: deploymentWatch.isFilterSelected,
                  isClearFilterCall: deploymentWatch.isClearFilterCall,
                  onCloseTap: (){
                    deploymentWatch.updateTempSelectedStatus(deploymentWatch.selectedFilter);
                  },
                  onApplyFilterTap: (){
                    deploymentWatch.updateSelectedStatus(deploymentWatch.selectedTempFilter);
                    deploymentWatch.deploymentListApi(context);
                  },
                  onClearFilterTap: (){
                    deploymentWatch.resetFilter();
                    deploymentWatch.deploymentListApi(context);
                  },
                );
              }
          ),
          height: 1,
          width: 0.5,
        );
      },
      body: _bodyWidget(),
    );
  }

  ///Body Widget
  Widget _bodyWidget() {
    final deploymentWatch = ref.watch(deploymentController);
    return CommonTableGenerator(
      headerContent: [
        CommonHeader(title: LocaleKeys.keyDestinationName.localized, flex: 2),
        CommonHeader(title: LocaleKeys.keyUpdateAt.localized, flex: 3),
        CommonHeader(title: LocaleKeys.keyVersionName.localized, flex: 2),
        CommonHeader(title: LocaleKeys.keyStatus.localized,flex: 3),

      ],
      childrenHeader: deploymentWatch.deploymentList,
      childrenContent: (index) {
        final item = deploymentWatch.deploymentList[index];
        return [CommonRow(title:  item?.destinationName ?? '', flex: 2),
          CommonRow(title: DateFormat('dd/MM/yyyy  |   h:mma').format(DateTime.fromMillisecondsSinceEpoch(item?.updatedAt ?? 0)), flex: 3),
          CommonRow(title: '${LocaleKeys.keyV.localized}${item?.version}',flex: 2),
          CommonRow(widget: Row( /// info
            children: [
              Expanded(flex:3,child: CommonStatusButton(status: item?.buildStatus ?? '',dotRequired: false,width: 50,)),
              Spacer(flex: 1),
            ],
          ),title: '',),
          CommonRow(title: '', flex: 2)
        ];
      },
      /// scroll listener
      isLoading: deploymentWatch.deploymentListState.isLoading,
      isLoadMore: deploymentWatch.deploymentListState.isLoadMore,
      onScrollListener: () {
        if (!deploymentWatch.deploymentListState.isLoadMore && deploymentWatch.deploymentListState.success?.hasNextPage == true) {
          if (mounted) {
            deploymentWatch.deploymentListApi(context, isForPagination: true);
          }
        }
      },
    );
  }
}
