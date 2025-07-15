import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/controller/faq/faq_controller.dart';
import 'package:odigov3/framework/repository/faq/model/response/faq_list_response_model.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/session.dart';
import 'package:odigov3/ui/routing/navigation_stack_item.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_anim_loader.dart';
import 'package:odigov3/ui/utils/widgets/common_empty_state_widget.dart';
import 'package:odigov3/ui/utils/widgets/common_switch_widget.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class FaqListWidget extends ConsumerWidget {
  const FaqListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final faqWatch = ref.watch(faqController);
    final drawerWatch = ref.watch(drawerController);
    return faqWatch.faqListState.isLoading
        ? CommonAnimLoader()
        : faqWatch.faqList.isEmpty
        ? Center(child: CommonEmptyStateWidget())
    : Column(
          children: [
            Expanded(
              child: ListView.builder(
                    controller: faqWatch.faqListScrollCtr,
                    itemCount: faqWatch.faqList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
              FaqData? faqData = faqWatch.faqList[index];
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.clrF3F4F6,
                  border: Border.all(color: AppColors.clrEEEFF2),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.all(context.height * 0.02),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        /// question
                        Expanded(
                          child: CommonText(
                            title: '${LocaleKeys.keyQuestion.localized} ${index+1} :',
                            style: TextStyles.semiBold.copyWith(fontSize: 14, color: AppColors.black),
                            maxLines: 5,
                          ),
                        ),
                        /// edit button
                        Visibility(
                          visible: (drawerWatch.selectedMainScreen?.canEdit == true) && (faqData?.active == true),
                          child: InkWell(
                            onTap: () {
                              ref.read(navigationStackController).push(NavigationStackItem.addEditFaq(faqUuid: faqData?.uuid));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.transparent,
                                border: Border.all(color: AppColors.clrD0D5DD, width: 1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              padding: EdgeInsets.symmetric(vertical: context.height * 0.008, horizontal: context.width * 0.01),
                              child: Row(
                                children: [
                                  /// edit icon
                                  SvgPicture.asset(Assets.svgs.svgEditPen.keyName, height: context.height * 0.025).paddingOnly(right: context.width * 0.004),

                                  /// edit text
                                  CommonText(
                                    title: LocaleKeys.keyEdit.localized,
                                    style: TextStyles.medium.copyWith(fontSize: 14, color: AppColors.black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: (drawerWatch.selectedMainScreen?.canDelete == true),
                          child: Row(
                            children: [
                              /// status text
                              CommonText(
                                title: LocaleKeys.keyStatus.localized,
                                style: TextStyles.medium.copyWith(fontSize: 11, color: AppColors.clr667085),
                              ),
                              ///status button
                              Transform.scale(
                                scale: 0.8,
                                child: SizedBox(
                                  height: context.height * 0.04,
                                  width: context.width * 0.04,
                                  child: (faqWatch.changeFaqStatusState.isLoading == true) && (faqWatch.statusTapIndex == index)
                                      ? Center(child: LoadingAnimationWidget.waveDots(color: AppColors.black, size: 20),)
                                      : CommonCupertinoSwitch(
                                          switchValue: (faqData?.active) ?? false,
                                          onChanged: (val) {
                                            faqWatch.changeFaqStatusApi(context, faqUuid: faqData?.uuid ?? '', isActive: val, index: index);
                                          }
                                        ),
                                ),
                              ),
                            ],
                          ).paddingOnly(left: context.width * 0.02),
                        ),
                      ],
                    ),
                    SizedBox(height: context.height * 0.01,),
                    CommonText(
                      title: faqData?.question ?? '',
                      style: TextStyles.regular.copyWith(fontSize: 14, color: AppColors.black),
                      maxLines: 1000,
                    ),
                    SizedBox(height: context.height * 0.015,),
                    CommonText(
                      title: faqData?.answer ?? '',
                      style: TextStyles.regular.copyWith(fontSize: 14, color: AppColors.clr7C7474),
                      maxLines: 1000,
                    ),
                  ],
                ),
              ).paddingOnly(bottom: context.height * 0.02);
                    }
                  ),
            ),
            if (faqWatch.faqListState.isLoadMore)
              CircularProgressIndicator(strokeWidth: 3, color: AppColors.black,).paddingSymmetric(vertical: context.height * 0.008)
          ],
        );
  }
}
