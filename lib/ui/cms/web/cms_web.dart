import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';
import 'package:odigov3/framework/controller/cms/cms_controller.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/repository/dashboard/model/sidemenu_list_response_model.dart';
import 'package:odigov3/framework/repository/master/country/model/get_language_list_response_model.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/session.dart';
import 'package:odigov3/ui/cms/web/helper/cms_expansion_tile_widget.dart';
import 'package:odigov3/ui/cms/web/helper/language_dropdown.dart';
import 'package:odigov3/ui/drawer/web/base_drawer_page_widget.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/widgets/common_anim_loader.dart';
import 'package:odigov3/ui/utils/widgets/common_tabs_widget.dart';

class CmsWeb extends ConsumerStatefulWidget {
  const CmsWeb({Key? key}) : super(key: key);

  @override
  ConsumerState<CmsWeb> createState() => _CmsWebState();
}

class _CmsWebState extends ConsumerState<CmsWeb> {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final cmsWatch = ref.watch(cmsController);
      cmsWatch.disposeController(isNotify : true);

      SidebarModel? selectedMainScreen = ref.read(drawerController).selectedMainScreen;
      if(selectedMainScreen?.canViewSidebar == true && selectedMainScreen?.canView == true) {
        if(Session.languageModel.isNotEmpty)
          {
            cmsWatch.getLanguageFromSession();
          }
        else{
          cmsWatch.getLanguageListAPI(context,ref);
        }


      }
    });
  }

  ///Dispose Override
  @override
  void dispose() {
    super.dispose();
  }

  ///Build Override
  @override
  Widget build(BuildContext context) {
    return BaseDrawerPageWidget(
      addButtonText: LocaleKeys.keyCMSManagement.localized,
      body: _bodyWidget(),
    );
  }

  ///Body Widget
  Widget _bodyWidget() {
    final cmsWatch = ref.watch(cmsController);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: AppColors.clr101828.withValues(alpha: 0.6), blurRadius: 2, offset: Offset(0, 1)),
          BoxShadow(color: AppColors.clr101828.withValues(alpha: 0.1), blurRadius: 3, offset: Offset(0, 1)),

        ],
      ),
      child: cmsWatch.languageListState.isLoading? CommonAnimLoader() :Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomTabBarScreen(
                selectedIndex:cmsWatch.selectedTabIndex,
                items:cmsWatch.getTabList(context),
                onTap: (int selectedInd) {
                  cmsWatch.updateSelectedTabIndex(selectedInd);
                  cmsWatch.closeAllTiles();
                },),
              LanguageDropdown(),


            ],
          ),
          SizedBox(height: 20,),
          CmsExpansionTileWidget()

        ],
      ).paddingSymmetric(horizontal: 21,vertical: 21),
    );

  }

}
