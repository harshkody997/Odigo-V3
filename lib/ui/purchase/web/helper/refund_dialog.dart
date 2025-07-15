import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/purchase/purchase_list_controller.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/form_validations.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_anim_loader.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';
import 'package:odigov3/ui/utils/widgets/common_form_field.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class RefundDialog extends ConsumerWidget {
  final String? purchaseUuid;
  const RefundDialog({super.key,required this.purchaseUuid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final purchaseListWatch = ref.watch(purchaseListController);
    return Form(
      key: purchaseListWatch.refundFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///Back button and title
          Row(
            children: [
              InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: CommonSVG(
                  strIcon: Assets.svgs.svgBackArrow.keyName,
                ),
              ),
              SizedBox(width: context.width*0.015),
              CommonText(
                title: LocaleKeys.keyRefund.localized,
                style: TextStyles.semiBold.copyWith(
                  fontSize: 22
                ),
              )
            ],
          ),

          purchaseListWatch.purchaseRefundDetailState.isLoading
              ? Expanded(child: Center(child: CommonAnimLoader()))
              : Expanded(
            child: Column(
              children: [
                Spacer(),

                ///Refunded
                CommonText(
                  title: LocaleKeys.keyRefundedPrice.localized,
                  maxLines: 3,
                  style: TextStyles.regular.copyWith(
                      fontSize: 16
                  ),
                ),

                Spacer(),

                ///Refunded Price Field
                CommonInputFormField(
                  focusNode: purchaseListWatch.refundedPriceNode,
                  textEditingController: purchaseListWatch.refundedPriceTextController,
                  hintText: LocaleKeys.keyRefundedPrice.localized,
                  validator: (value) {
                    return validateText(value, LocaleKeys.keyRefundedPriceRequired.localized);
                  },
                  textInputType: TextInputType.number,
                  onFieldSubmitted: (value) {
                    purchaseListWatch.remarkNode.requestFocus();
                  },
                  textInputFormatter: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,}$')),
                  ],
                ),

                Spacer(),

                ///Remarks(Optional)
                CommonText(
                  title: LocaleKeys.keyRemarksOptional.localized,
                  maxLines: 3,
                  style: TextStyles.regular.copyWith(
                      fontSize: 16
                  ),
                ),

                Spacer(),

                ///Remarks Field
                CommonInputFormField(
                  focusNode: purchaseListWatch.remarkNode,
                  textEditingController: purchaseListWatch.remarkTextController,
                  hintText: LocaleKeys.keyEnterRemarksHere.localized,
                  validator: (value) {
                    //return validateText(value, LocaleKeys.keyPleaseEnterName.localized);
                  },
                  maxLines: 4,
                  textInputType: TextInputType.name,
                  onFieldSubmitted: (value) {
                    //addUpdateClientWatch.emailFocusNode.requestFocus();
                  },
                ),

                Spacer(),

                ///Button
                CommonButton(
                  buttonText: LocaleKeys.keyDone.localized,
                  isLoading: purchaseListWatch.purchaseRefundState.isLoading,
                  onTap: () async {
                    if(purchaseListWatch.refundFormKey.currentState?.validate()==true){
                      await purchaseListWatch.purchaseRefundApi(purchaseUuid: purchaseUuid);
                      if(purchaseListWatch.purchaseRefundState.success?.status==ApiEndPoints.apiStatus_200){
                        Navigator.pop(context);
                        purchaseListWatch.purchaseListApi(false);
                      }
                    }
                  },
                ),
              ],
            ),
          )
        ],
      ).paddingAll(context.height*0.035),
    );
  }


}
