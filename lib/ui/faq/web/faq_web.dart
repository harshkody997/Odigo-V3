import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/controller/faq/faq_controller.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/session.dart';
import 'package:odigov3/ui/drawer/web/base_drawer_page_widget.dart';
import 'package:odigov3/ui/faq/web/helper/faq_list_widget.dart';
import 'package:odigov3/ui/faq/web/helper/faq_top_tab_widget.dart';
import 'package:odigov3/ui/master/helper/common_status_type_filter_widget.dart';
import 'package:odigov3/ui/routing/navigation_stack_item.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_dialog.dart';

class FaqWeb extends ConsumerStatefulWidget {
  const FaqWeb({super.key});

  @override
  ConsumerState<FaqWeb> createState() => _FaqWebState();
}

class _FaqWebState extends ConsumerState<FaqWeb> {

  ///Build Override
  @override
  Widget build(BuildContext context) {
    final faqWatch = ref.watch(faqController);
    final drawerWatch = ref.watch(drawerController);
    return BaseDrawerPageWidget(
      showAddButton: (drawerWatch.selectedMainScreen?.canAdd == true),
      addButtonOnTap: () {
        ref.read(navigationStackController).push(NavigationStackItem.addEditFaq());
      },
      addButtonText: LocaleKeys.keyAddFAQs.localized,
      showSearchBar: true,
      searchPlaceHolderText: LocaleKeys.keySearchHere.localized,
      searchController: faqWatch.searchCtr,
      searchOnChanged: (value){
        if(!faqWatch.faqListState.isLoading) {
          faqWatch.faqListApi(context, searchKeyword: value);
        }
      },
      showFilters: (drawerWatch.selectedMainScreen?.canDelete == true),
      filterButtonOnTap: (){

        /// open filter dialog
        showCommonDetailDialog(
          keyBadge: faqWatch.filterKey,
          context: context,
          dialogBody: Consumer(
              builder: (context,ref,child) {
                final faqWatch = ref.watch(faqController);
                return CommonStatusTypeFilterWidget(
                  groupValue: faqWatch.selectedTempFilter,
                  onSelectFilterTap: (filterType)=> faqWatch.updateTempSelectedStatus(filterType),
                  isFilterSelected: faqWatch.isFilterSelected,
                  isClearFilterCall: faqWatch.isClearFilterCall,
                  onCloseTap: (){
                    faqWatch.updateTempSelectedStatus(faqWatch.selectedFilter);
                  },
                  onApplyFilterTap: (){
                    faqWatch.updateSelectedStatus(faqWatch.selectedTempFilter);
                    faqWatch.faqListApi(context);
                  },
                  onClearFilterTap: (){
                    faqWatch.resetFilter();
                    faqWatch.faqListApi(context);
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
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.symmetric(horizontal: context.width * 0.01, vertical: context.height * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// top tab bar
          if((Session.getRoleType() != 'DESTINATION') && (Session.getRoleType() != 'CLIENT'))
            FaqTopTabWidget().paddingOnly(bottom: context.height * 0.02),

          /// faq list
          Expanded(child: FaqListWidget()),
        ],
      ),
    );
  }

}
