import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:odigov3/framework/controller/cms/cms_controller.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/repository/dashboard/model/sidemenu_list_response_model.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/theme/text_style.dart';
import 'package:odigov3/ui/utils/widgets/common_anim_loader.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';

import 'package:odigov3/ui/utils/widgets/common_text.dart';


class CmsExpansionTileWidget extends ConsumerStatefulWidget {

  const CmsExpansionTileWidget({super.key});

  @override
  ConsumerState<CmsExpansionTileWidget> createState() => _CmsExpansionTileWidgetState();
}

class _CmsExpansionTileWidgetState extends ConsumerState<CmsExpansionTileWidget> {


  @override
  Widget build(BuildContext context) {
    final cmsWatch = ref.watch(cmsController);
    SidebarModel? selectedMainScreen = ref.read(drawerController).selectedMainScreen;

    return     Expanded(
      child: ListView(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.clrEAECF0),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.clr101828.withValues(alpha: 0.055), // softer shadow
                  blurRadius: 1.5,
                  offset: Offset(0, 1),
                ),
                BoxShadow(
                  color: AppColors.clr101828.withValues(alpha: 0.022), // very subtle
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              children: List.generate(cmsWatch.getCmsTypeList(context).length, (index) {
                final item = cmsWatch.getCmsTypeList(context)[index];
                final key = item['key'] ?? '';

                return Column(
                  children: [
                    _buildExpansionTile(item['label'] ?? '',key, (isExpanding) {

                      isExpanding? cmsWatch.updateCmsType(key) :cmsWatch.updateCmsType(null);

                      if(isExpanding && selectedMainScreen?.canViewSidebar == true && selectedMainScreen?.canView == true)
                      {
                        cmsWatch.cmsListApi(context);
                      }


                    },cmsWatch.expandedTileKey==key),
                    if (index < cmsWatch.getCmsTypeList(context).length - 1)
                      Divider(height: 1, color: AppColors.clrEAECF0),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );

  }


  Widget _buildExpansionTile(String title,var key, ValueChanged<bool> onExpansionChanged,bool isExpanded) {
    final cmsWatch = ref.watch(cmsController);
    final drawerWatch = ref.watch(drawerController);

    return Theme(
      data: ThemeData().copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        key: ValueKey('${key}_${isExpanded ? 'open' : 'closed'}'),
        initiallyExpanded: isExpanded,
        onExpansionChanged: onExpansionChanged,
        tilePadding:  EdgeInsets.symmetric(horizontal: 0, vertical: isExpanded? 5:20),
        childrenPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        title: CommonText(
          title:title,
          style: TextStyles.medium.copyWith(
            fontSize: 14,
            color: AppColors.clr101828,
          ),
        ),
        children: [
          Container(
              padding: EdgeInsets.zero,
              height: 350,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.whiteEAEAEA, width: 1.18),
                borderRadius: BorderRadius.circular(11),
              ),
              child:
              cmsWatch.cmsTypeState.isLoading?  CommonAnimLoader():

              Consumer(builder: (context, ref, _)  {
                return   HtmlEditor(
                  controller: cmsWatch.cmsTypeState.success?.data?.cmsValues
                      ?.firstWhere((e) => e.languageUuid == cmsWatch.selectedLanguageData?.uuid).controller ?? cmsWatch.htmlController,

                  /// Editor Options
                  htmlEditorOptions: HtmlEditorOptions(
                    hint: LocaleKeys.keyEnterYourText.localized,
                    darkMode: false,
                    shouldEnsureVisible: false,
                    initialText: '',
                  ),
                  callbacks: Callbacks(
                    onChangeContent: (String? changed) {

                      if (changed != null && changed.trim().isNotEmpty) {
                        if (cmsWatch.debounceTimer?.isActive ?? false) cmsWatch.debounceTimer?.cancel();

                        cmsWatch.debounceTimer = Timer(const Duration(milliseconds: 600), () {

                          ref.watch(cmsController).setCmsDataForLanguage(changed.trim());

                        });
                      }},
                  ),
                  otherOptions: OtherOptions(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(27),
                      color: AppColors.lightPinkF7F7FC,
                    ),
                  ),

                  /// Bottom ToolBar Options
                  htmlToolbarOptions: HtmlToolbarOptions(
                    toolbarPosition: ToolbarPosition.belowEditor,
                    dropdownMenuDirection: DropdownMenuDirection.up,
                    toolbarType: ToolbarType.nativeScrollable,
                    buttonColor: AppColors.black171717,
                    buttonBorderColor: AppColors.black171717,
                    dropdownBackgroundColor: AppColors.white,
                    buttonFillColor: AppColors.black171717,
                    buttonBorderRadius: BorderRadius.circular(8),
                    dropdownIconColor: AppColors.greyE6E6E6,
                    dropdownFocusColor: AppColors.white,
                    buttonHighlightColor: AppColors.greyE6E6E6,
                    buttonFocusColor: AppColors.greyE6E6E6,
                    buttonSelectedColor: AppColors.white,
                    dropdownMenuMaxHeight: context.height ,
                    dropdownItemHeight:  context.height ,
                    mediaUploadInterceptor: (fileType, insertType) {
                      return true;
                    },
                  ),
                );
              })



          ),
          SizedBox(height: 12,),

          Visibility(
            visible:!cmsWatch.cmsTypeState.isLoading && cmsWatch.cmsTypeState.success?.data?.isEdit==false && drawerWatch.selectedMainScreen?.canAdd==true,
            child: Row(
              children: [
                CommonButton(
                  width: 144,
                  height: 48,
                  isLoading: cmsWatch.addCmsState.isLoading,
                  buttonText: LocaleKeys.keySave.localized,
                  borderRadius: BorderRadius.circular(8),
                  backgroundColor: AppColors.black,
                  buttonTextStyle: TextStyles.regular.copyWith(
                    color: AppColors.white,
                  ),
                  onTap: () async {
                    final allLanguagesFilled = cmsWatch.cmsTypeState.success?.data?.cmsValues?.every(
                          //  (cms) => (cms.fieldValue ?? '').trim().isNotEmpty && (cms.fieldValue?.trim()!='<br>') && (cms.fieldValue?.trim()!='<h1><br></h1>')
                            (cms) =>  cmsWatch.isMeaningfulHtml(cms.fieldValue ?? '')
                    );
                    if(allLanguagesFilled==true)
                    {
                      await cmsWatch.addCmsApi(context);
                    }
                    else {
                      context.showSnackBar(LocaleKeys.keyDataAlert.localized);

                    }



                  },
                ),
                SizedBox(width: 20),
                CommonButton(
                  width: 144,
                  height: 48,
                  buttonText: LocaleKeys.keyCancel.localized,
                  borderRadius: BorderRadius.circular(8),
                  borderColor: AppColors.clr9E9E9E,
                  backgroundColor: AppColors.transparent,
                  buttonTextStyle: TextStyles.regular.copyWith(
                    color: AppColors.clr787575,
                  ),
                  onTap: () async {
                    cmsWatch.closeAllTiles();

                  },
                ),
              ],
            ),

          ),
          Visibility(
            //visible: !cmsWatch.cmsTypeState.isLoading && (cmsWatch.cmsTypeState.success?.data?.cmsValues??[]).isNotEmpty,
            visible: !cmsWatch.cmsTypeState.isLoading && cmsWatch.cmsTypeState.success?.data?.isEdit==true && drawerWatch.selectedMainScreen?.canEdit==true,
            child: Align(
              alignment: Alignment.centerLeft,
              child: CommonButton(
                width: 144,
                height: 48,
                isLoading: cmsWatch.editCmsState.isLoading,
                buttonText: LocaleKeys.keyEdit.localized,
                borderRadius: BorderRadius.circular(8),
                backgroundColor: AppColors.black,
                buttonTextStyle: TextStyles.regular.copyWith(
                  color: AppColors.white,
                ),
                onTap: () async {
                  final allLanguagesFilled = cmsWatch.cmsTypeState.success?.data?.cmsValues?.every(
                        //  (cms) => (cms.fieldValue ?? '').trim().isNotEmpty && (cms.fieldValue?.trim()!='<br>') && (cms.fieldValue?.trim()!='<h1><br></h1>')
                          (cms) => cmsWatch.isMeaningfulHtml(cms.fieldValue ?? '')
                  );
                  if(allLanguagesFilled==true)
                  {
                    await cmsWatch.editCmsApi(context,cmsWatch.cmsTypeState.success?.data?.uuid??'');
                  }
                  else {
                    context.showSnackBar(LocaleKeys.keyDataAlert.localized);

                  }


                },
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ).paddingSymmetric(horizontal: 24),
    );
  }


}

