import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/client_ads/client_ads_controller.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/form_validations.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';
import 'package:odigov3/ui/utils/widgets/common_form_field.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class RejectAdReasonDialog extends StatelessWidget {
  final String uuid;
  const RejectAdReasonDialog({super.key, required this.uuid});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final clientAdsWatch = ref.watch(clientAdsController);
        return Form(
          key: clientAdsWatch.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// title
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: CommonSVG(
                      strIcon: Assets.svgs.svgBackButtonWithoutBg.keyName,
                    ).paddingOnly(right: 10),
                  ),
                  CommonText(
                    title: LocaleKeys.keyReason.localized,
                    style: TextStyles.bold.copyWith(
                      fontSize: 20,
                    ),
                  )
                ],
              ).paddingOnly(bottom: context.height * 0.025),
              /// form field
              CommonInputFormField(
                textEditingController: clientAdsWatch.rejectReasonCtr,
                hintText: LocaleKeys.keyReason.localized,
                fieldTextStyle: TextStyles.regular.copyWith(
                  fontSize: 14,
                  color: AppColors.black272727,
                ),
                maxLength: 500,
                placeholderText: LocaleKeys.keyReason.localized,
                validator: (value) {
                  return validateTextIgnoreLength(value, LocaleKeys.keyReasonRequired.localized);
                },
              ).paddingOnly(bottom: context.height * 0.025),
              /// save button
              CommonButton(
                buttonText: LocaleKeys.keyOk.localized,
                height: context.height * 0.049,
                borderRadius: BorderRadius.circular(6),
                isLoading: clientAdsWatch.acceptRejectAdsState.isLoading,
                isShowLoader: clientAdsWatch.acceptRejectAdsState.isLoading,
                onTap: () async {
                  final bool? result = clientAdsWatch.formKey.currentState?.validate();
                  if(result == true){
                    await clientAdsWatch.acceptRejectAdsApi(context, uuid: uuid, status: 'REJECTED');
                    if(clientAdsWatch.acceptRejectAdsState.success?.status == ApiEndPoints.apiStatus_200){
                      clientAdsWatch.clientAdsListApi(context);
                      Navigator.pop(context);
                    }
                  }
                },
              )
            ],
          ).paddingSymmetric(horizontal: context.width * 0.020 , vertical: context.height * 0.03 ),
        );
      },
    );
  }
}
