import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/purchase/add_purchase_controller.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/purchase/web/helper/purchase_successful_dialog.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';
import 'package:odigov3/ui/utils/widgets/common_dialog.dart';
import 'package:odigov3/ui/utils/widgets/common_form_field.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class RemarksDialog extends ConsumerWidget {
  final String? purchaseUuid;
  const RemarksDialog({super.key,required this.purchaseUuid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addPurchaseWatch = ref.watch(addPurchaseController);
    return Column(
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
              title: LocaleKeys.keyAddRemark.localized,
              style: TextStyles.semiBold.copyWith(
                  fontSize: 22
              ),
            )
          ],
        ),

        Spacer(),

        ///Remarks Field
        CommonInputFormField(
          focusNode: addPurchaseWatch.remarkNode,
          textEditingController: addPurchaseWatch.remarkTextController,
          hintText: LocaleKeys.keyEnterRemarksHere.localized,
          validator: (value) {
            //return validateText(value, LocaleKeys.keyPleaseEnterName.localized);
          },
          maxLength: AppConstants.maxDescriptionLength,
          maxLines: 4,
          textInputType: TextInputType.name,
          onFieldSubmitted: (value) {
            //addUpdateClientWatch.emailFocusNode.requestFocus();
          },
        ),

        Spacer(),

        ///Button
        CommonButton(
          buttonText: LocaleKeys.keyConfirmPurchase.localized,
          // isLoading: purchaseListWatch.purchaseRefundState.isLoading,
          onTap: () async {
            Navigator.pop(context);
            showCommonWebDialog(
              keyBadge: addPurchaseWatch.purchaseSuccessfulDialogKey,
              context: context,
              dialogBody: PurchaseSuccessfulDialog(),
              height: 0.55,
              width: 0.4,
            );
          },
        ),
      ],
    ).paddingAll(context.height*0.035);
  }


}
