import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';
import 'package:odigov3/framework/controller/cms/cms_controller.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/drawer/web/base_drawer_page_widget.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/app_enums.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/theme/text_style.dart';
import 'package:odigov3/ui/utils/widgets/common_anim_loader.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart' show CommonButton;
import 'package:odigov3/ui/utils/widgets/common_text.dart' show CommonText;
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class ShowCmsWeb extends ConsumerStatefulWidget {
  final String? title;
  const ShowCmsWeb({Key? key, required this.title}) : super(key: key);

  @override
  ConsumerState<ShowCmsWeb> createState() => _ShowCmsWebState();
}

class _ShowCmsWebState extends ConsumerState<ShowCmsWeb> {
  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      final cmsWatch = ref.read(cmsController);
      await cmsWatch.cmsAPI(context, cmsType: widget.title ?? '');
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
    return BaseDrawerPageWidget(body: _bodyWidget());
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///Title
          CommonText(title: widget.title == CmsValueEnum.PRIVACY_POLICY.name ? LocaleKeys.keyPrivacyPolicy.localized : widget.title == CmsValueEnum.REFUND.name ?LocaleKeys.keyRefund.localized :widget.title == CmsValueEnum.TERMS_AND_CONDITION.name ?LocaleKeys.keyTermsConditions.localized :LocaleKeys.keyAboutUs.localized, style: TextStyles.medium.copyWith(fontSize: 22)),

          Expanded(
            child: cmsWatch.cmsState.isLoading
                ? CommonAnimLoader()
                : SingleChildScrollView(
                    child: HtmlWidget(cmsWatch.cmsState.success?.data?.fieldValue ?? '', textStyle: TextStyles.regular.copyWith(fontSize: 14, color: AppColors.black)).paddingOnly(top: 16),
                  ),
          ),

          ///Back button
          CommonButton(
            height: context.height * 0.06,
            width: context.width * 0.123,
            onTap: () {
              ref.read(navigationStackController).pop();
            },
            buttonText: LocaleKeys.keyBack.localized,
            backgroundColor: AppColors.transparent,
            borderColor: AppColors.greyD0D5DD,
            buttonTextStyle: TextStyles.medium.copyWith(
              fontSize: 14,
              color: AppColors.clr787575,
            ),
          ),
        ],
      ).paddingSymmetric(horizontal: 21, vertical: 21),
    );
  }
}
