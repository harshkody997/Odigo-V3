import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/faq/faq_controller.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/utils/app_enums.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';

class FaqTopTabWidget extends ConsumerWidget {
  const FaqTopTabWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        _commonFaqTab(context, ref, faqType: FaqType.Destinations),
        SizedBox(
          width: context.width * 0.01,
        ),
        _commonFaqTab(context, ref, faqType: FaqType.Clients),
      ],
    );
  }

  _commonFaqTab(BuildContext context, WidgetRef ref, {required FaqType faqType}){
    final faqWatch = ref.watch(faqController);
    return CommonButton(
      onTap: () {
        if(!faqWatch.faqListState.isLoading && (faqType != faqWatch.selectedFaqType)) {
          faqWatch.updateFaqType(faqType);
          faqWatch.faqListApi(context);
        }
      },
      height: context.height * 0.06,
      width: context.width * 0.1,
      buttonText: (faqType == FaqType.Destinations) ? LocaleKeys.keyDestination.localized : LocaleKeys.keyClients.localized,
      backgroundColor: (faqType == faqWatch.selectedFaqType) ? AppColors.clr2997FC : AppColors.transparent,
      borderColor: (faqType == faqWatch.selectedFaqType) ? null : AppColors.clrE0E0E0,
      buttonTextStyle: TextStyles.medium.copyWith(color: (faqType == faqWatch.selectedFaqType) ? AppColors.white : AppColors.clrC1C4D6, fontSize: 12),
      borderRadius: BorderRadius.circular(8),
    );
  }
}
