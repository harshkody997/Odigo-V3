import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/company/company_controller.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/repository/company/model/company_details_response_model.dart';
import 'package:odigov3/framework/repository/dashboard/model/sidemenu_list_response_model.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/session.dart';
import 'package:odigov3/ui/company/web/helper/company_info_common_row.dart';
import 'package:odigov3/ui/drawer/web/base_drawer_page_widget.dart';
import 'package:odigov3/ui/profile/web/helper/dot_lines_widget.dart';
import 'package:odigov3/ui/routing/navigation_stack_item.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/cache_image.dart';
import 'package:odigov3/ui/utils/widgets/common_anim_loader.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class CompanyDetailsWeb extends ConsumerStatefulWidget {
  const CompanyDetailsWeb({super.key});

  @override
  ConsumerState<CompanyDetailsWeb> createState() => _CompanyDetailsWebState();
}

class _CompanyDetailsWebState extends ConsumerState<CompanyDetailsWeb> {
  ///Build Override
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _bodyWidget());
  }

  ///Body Widget
  Widget _bodyWidget() {
    final companyWatch = ref.watch(companyController);
    SidebarModel? selectedMainScreen = ref.read(drawerController).selectedMainScreen;

    CompanyInfo companyDetail =
        companyWatch.companyDetailState.success?.data ?? CompanyInfo();
    return BaseDrawerPageWidget(
      body: (companyWatch.companyDetailState.isLoading)
          ? Center(child: CommonAnimLoader()) : Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(8),
                      shape: BoxShape.rectangle,
                    ),
                    child:
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ///Company image,name  and edit button
                              Row(
                                children: [
                                  ///company image
                                  CacheImage(
                                    imageURL: companyWatch.companyImage,
                                    placeholderName:
                                        LocaleKeys.keyProfileImage.localized,
                                    height: context.height * 0.220,
                                    width: context.height * 0.220,
                                    bottomLeftRadius: context.height * 0.2,
                                    bottomRightRadius: context.height * 0.2,
                                    topLeftRadius: context.height * 0.2,
                                    topRightRadius: context.height * 0.2,
                                  ).paddingOnly(right: context.width * 0.03),
                          
                                  ///company name
                                  CommonText(
                                    title:
                                        companyDetail
                                            .companyValues
                                            ?.firstWhere(
                                              (element) => element.languageUuid == Session.sessionBox.get(keyAppLanguageUuid),)
                                            .companyName ??
                                        '',
                                    style: TextStyles.semiBold.copyWith(
                                      fontSize: 22,
                                      color: AppColors.black,
                                    ),
                                  ),
                                  Spacer(),
                          
                                  ///edit button
                                  Visibility(
                                    visible: selectedMainScreen?.canEdit ?? false,
                                    child: InkWell(
                                      onTap: () {
                                        ref.read(navigationStackController).push(NavigationStackItem.editCompany());
                                      },
                                      child: Container(
                                        height: context.height * 0.06,
                                        width: context.width * 0.065,
                                        decoration: BoxDecoration(
                                          color: AppColors.transparent,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                            color: AppColors.greyD0D5DD,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            CommonSVG(
                                              strIcon: Assets.svgs.svgEdit2.path,
                                            ),
                                            CommonText(
                                              title: LocaleKeys.keyEdit.localized,
                                              style: TextStyles.medium.copyWith(
                                                fontSize: 14,
                                                color: AppColors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          
                              ///Dot lines widget
                              DotLinesWidget().paddingSymmetric(
                                vertical: context.height * 0.03,
                              ),
                          
                              CompanyInfoCommonRow(
                                label: LocaleKeys.keyGSTNo.localized,
                                value: companyDetail.gstNo ?? '',
                              ),
                              CompanyInfoCommonRow(
                                label: LocaleKeys.keyEmailId.localized,
                                value: companyDetail.companyEmail ?? '',
                              ),
                              CompanyInfoCommonRow(
                                label: LocaleKeys.keyContact.localized,
                                value: companyDetail.companyContact ?? '',
                              ),
                              CompanyInfoCommonRow(
                                label: LocaleKeys.keyCompanyHours.localized,
                                value: '${companyWatch.openTime} ${LocaleKeys.keyTo.localized} ${companyWatch.closeTime}',
                              ),
                              CompanyInfoCommonRow(
                                label: LocaleKeys.keyCustomerCareEmail.localized,
                                value: companyDetail.customerCareEmail ?? '',
                              ),
                              CompanyInfoCommonRow(
                                label: LocaleKeys.keyAddress.localized,
                                value: '${companyDetail
                                    .companyValues
                                    ?.firstWhere(
                                      (element) => element.languageUuid == Session.sessionBox.get(keyAppLanguageUuid),)
                                    .companyAddress} , ${companyDetail.cityName} , ${companyDetail.stateName}',
                              ),
                            ],
                          ).paddingSymmetric(
                            horizontal: context.width * 0.02,
                            vertical: context.width * 0.02,
                          ),
                        ),
                  ),
                ),
              ],
            ),
    );
  }
}
