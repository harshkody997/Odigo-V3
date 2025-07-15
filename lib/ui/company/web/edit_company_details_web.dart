import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/company/company_controller.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/company/web/helper/edit_company_widget.dart';
import 'package:odigov3/ui/drawer/web/base_drawer_page_widget.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_anim_loader.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class EditCompanyDetailsWeb extends ConsumerStatefulWidget {
  const EditCompanyDetailsWeb({super.key});

  @override
  ConsumerState<EditCompanyDetailsWeb> createState() =>
      _EditCompanyDetailsWebState();
}

class _EditCompanyDetailsWebState extends ConsumerState<EditCompanyDetailsWeb> {
  ///Build Override
  @override
  Widget build(BuildContext context) {
    return BaseDrawerPageWidget(body: _bodyWidget());
  }

  ///Body Widget
  Widget _bodyWidget() {
    return ref.watch(companyController).companyDetailState.isLoading ? CommonAnimLoader() : Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.clr101828.withValues(alpha: 0.6),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
          BoxShadow(
            color: AppColors.clr101828.withValues(alpha: 0.1),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child:
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CommonText(
                  title: LocaleKeys.keyEdit.localized,
                  style: TextStyles.semiBold.copyWith(
                    fontSize: 14,
                    color: AppColors.black,
                  ),
                ).paddingOnly(bottom: context.height * 0.034),

                /// main form widget
                EditCompanyWidget().paddingOnly(bottom: context.height * 0.03),

                /// save and back button
                Consumer(
                  builder: (context, ref, child) {
                    final editCompanyWatch = ref.watch(companyController);
                    return Row(
                      children: [
                        ///save and continue
                        CommonButton(
                          buttonText: LocaleKeys.keySave.localized,
                          buttonTextStyle: TextStyles.medium.copyWith(
                            fontSize: 14,
                            color: AppColors.white,
                          ),
                          borderRadius: BorderRadius.circular(6),
                          width: 144,
                          height: 48,
                          isLoading:
                              editCompanyWatch.editCompanyState.isLoading ||
                              editCompanyWatch.uploadCompanyImageState.isLoading,
                          onTap: () async {
                            editCompanyWatch.editCompanyApiCall(context, ref);
                          },
                        ).paddingOnly(right: context.width * 0.02),

                        ///Back button
                        CommonButton(
                          buttonText: LocaleKeys.keyBack.localized,
                          buttonTextStyle: TextStyles.medium.copyWith(
                            fontSize: 14,
                            color: AppColors.clr787575,
                          ),
                          backgroundColor: AppColors.transparent,
                          borderColor: AppColors.clr9E9E9E,
                          borderRadius: BorderRadius.circular(6),
                          width: 145,
                          height: 48,
                          onTap: () {
                            //Navigator.of(context).pop();
                             ref.read(navigationStackController).pop();
                             // editCompanyWatch.getCompanyDetail(context);

                          },
                        ),
                      ],
                    );
                  },
                ),
              ],
            ).paddingSymmetric(
              horizontal: context.width * 0.020,
              vertical: context.height * 0.030,
            ),
          ),
    );
  }
}
