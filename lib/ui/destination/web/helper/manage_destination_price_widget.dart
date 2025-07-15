import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/destination/manage_destination_controller.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/form_validations.dart';
import 'package:odigov3/ui/dashboard/web/helper/common_dashboard_container.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/text_style.dart';
import 'package:odigov3/ui/utils/widgets/common_form_field.dart';
import 'package:odigov3/ui/utils/widgets/common_searchable_dropdown.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class ManageDestinationPriceWidget extends ConsumerWidget {
  const ManageDestinationPriceWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final manageDestinationWatch = ref.watch(manageDestinationController);
    return SizedBox(
      // height: context.height * 0.48,
      child: CommonDashboardContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonText(
              title: LocaleKeys.keyPriceDetails.localized,
              style: TextStyles.semiBold.copyWith(color: AppColors.clr080808),
            ),
            SizedBox(height: context.height * 0.02),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CommonInputFormField(
                    focusNode: manageDestinationWatch.premiumPriceFocusNode,
                    textEditingController: manageDestinationWatch.premiumPriceController,
                    hintText: LocaleKeys.keyPremiumPrice.localized,
                    textInputFormatter: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) => validatePrice(value, LocaleKeys.keyPremiumPriceRequired.localized,LocaleKeys.keyPremiumPriceZeroValidation.localized),
                    onFieldSubmitted: (value) => manageDestinationWatch.fillerPriceFocusNode.requestFocus(),
                    maxLength: AppConstants.maxAmountLength,
                  ),
                ),
                SizedBox(width: context.height * 0.025),
                Expanded(
                  child: CommonInputFormField(
                    focusNode: manageDestinationWatch.fillerPriceFocusNode,
                    textEditingController: manageDestinationWatch.fillerPriceController,
                    hintText: LocaleKeys.keyFillerPrice.localized,
                    textInputFormatter: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) => validatePrice(value, LocaleKeys.keyFillerPriceRequired.localized,LocaleKeys.keyFillerPriceZeroValidation.localized),
                    maxLength: AppConstants.maxAmountLength,
                    onFieldSubmitted: (value){
                      bool isValid = ref.read(manageDestinationController).destinationFormKey.currentState?.validate() ?? false;
                      if (isValid) {
                        ref.read(manageDestinationController).manageDestinationApi(context, destinationUuid: ref.read(manageDestinationController).destinationDetailsState.success?.data?.uuid);
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
