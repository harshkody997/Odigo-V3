
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/faq/add_edit_faq_controller.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/drawer/web/base_drawer_page_widget.dart';
import 'package:odigov3/ui/faq/web/helper/add_edit_faq_widget.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_anim_loader.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class AddEditFaqWeb extends ConsumerStatefulWidget {
  final String? faqUuid;
  const AddEditFaqWeb({super.key, this.faqUuid});

  @override
  ConsumerState<AddEditFaqWeb> createState() => _AddEditFaqWebState();
}

class _AddEditFaqWebState extends ConsumerState<AddEditFaqWeb> {

  ///Build Override
  @override
  Widget build(BuildContext context) {
    return BaseDrawerPageWidget(body: _bodyWidget());
  }

  ///Body Widget
  Widget _bodyWidget() {
    final addEditFaqWatch = ref.watch(addEditFaqController);
    return ((widget.faqUuid != null) && addEditFaqWatch.faqDetailState.isLoading)
        ? CommonAnimLoader()
        : Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: AppColors.clr101828.withValues(alpha: 0.6), blurRadius: 2, offset: Offset(0, 1)),
          BoxShadow(color: AppColors.clr101828.withValues(alpha: 0.1), blurRadius: 3, offset: Offset(0, 1)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          CommonText(
            title: (widget.faqUuid == null) ? LocaleKeys.keyAddFAQ.localized : LocaleKeys.keyEditFAQ.localized,
            style: TextStyles.semiBold.copyWith(fontSize: 14, color: AppColors.black),
          ).paddingOnly(bottom: context.height * 0.034),
          /// main form widget
          AddEditFaqWidget(uuid: widget.faqUuid).paddingOnly(bottom: context.height * 0.03),
          /// save and back button
          Consumer(
              builder: (context, ref, child) {
                final addEditFaqWatch = ref.watch(addEditFaqController);
                return Row(
                  children: [
                    Visibility(
                      visible: !((widget.faqUuid != null) && addEditFaqWatch.faqDetailState.isLoading),
                      child: CommonButton(
                        buttonText: LocaleKeys.keySave.localized,
                        buttonTextStyle : TextStyles.medium.copyWith(fontSize: 14, color: AppColors.white),
                        borderRadius: BorderRadius.circular(6),
                        width: context.width * 0.1,
                        height: context.height * 0.06,
                        isLoading: addEditFaqWatch.addEditFaqState.isLoading,
                        onTap: () async {
                          addEditFaqWatch.addEditFaqApiCall(context, ref, faqUuid: widget.faqUuid);
                        },
                      ).paddingOnly(right: context.width * 0.02),
                    ),
                    CommonButton(
                      buttonText: LocaleKeys.keyBack.localized,
                      buttonTextStyle : TextStyles.medium.copyWith(fontSize: 14, color: AppColors.clr787575),
                      backgroundColor: AppColors.transparent,
                      borderColor: AppColors.clr9E9E9E,
                      borderRadius: BorderRadius.circular(6),
                      width: context.width * 0.1,
                      height: context.height * 0.06,
                      onTap: () {
                        ref.read(navigationStackController).pop();
                      },
                    ),
                  ],
                );
              }
          ),
        ],
      ).paddingSymmetric(horizontal: context.width * 0.020, vertical: context.height * 0.030),
    );
  }

}
