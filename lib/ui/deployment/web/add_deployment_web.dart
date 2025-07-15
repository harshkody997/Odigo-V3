
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/deployment/deployment_controller.dart';
import 'package:odigov3/framework/controller/destination/destination_controller.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/deployment/web/helper/add_new_deployment_form_widget.dart';
import 'package:odigov3/ui/drawer/web/base_drawer_page_widget.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_anim_loader.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class AddDeploymentWeb extends ConsumerStatefulWidget {
  const AddDeploymentWeb({super.key});

  @override
  ConsumerState<AddDeploymentWeb> createState() => _AddDeploymentWebState();
}

class _AddDeploymentWebState extends ConsumerState<AddDeploymentWeb> {

  ///Build Override
  @override
  Widget build(BuildContext context) {
    return BaseDrawerPageWidget(body: _bodyWidget());
  }

  ///Body Widget
  Widget _bodyWidget() {

    final destinationWatch = ref.watch(destinationController);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: AppColors.clr101828.withValues(alpha: 0.6), blurRadius: 2, offset: Offset(0, 1)),
          BoxShadow(color: AppColors.clr101828.withValues(alpha: 0.1), blurRadius: 3, offset: Offset(0, 1)),
        ],
      ),
      child: destinationWatch.destinationListState.isLoading
          ? CommonAnimLoader()
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          CommonText(
            title:  LocaleKeys.keyAddNewDeployment.localized ,
            style: TextStyles.semiBold.copyWith(fontSize: 14, color: AppColors.black),
          ).paddingOnly(bottom: context.height * 0.034),
          /// deployment form widget
          AddNewDeploymentFormWidget().paddingOnly(bottom: context.height * 0.03),
          /// save and back button
          Consumer(
              builder: (context, ref, child) {
                final destinationWatch = ref.watch(destinationController);
                final deploymentWatch = ref.watch(deploymentController);

                return Row(
                  children: [
                    Visibility(
                      visible: !(destinationWatch.destinationListState.isLoading),
                      child: CommonButton(
                        buttonText: LocaleKeys.keySave.localized,
                        buttonTextStyle : TextStyles.medium.copyWith(fontSize: 14, color: AppColors.white),
                        borderRadius: BorderRadius.circular(6),
                        width: context.width * 0.15,
                        height: context.height * 0.06,
                        isLoading: deploymentWatch.addDeploymentState.isLoading,
                        onTap: () async {
                          deploymentWatch.addDeploymentApiCall(context, ref);
                        },
                      ).paddingOnly(right: context.width * 0.02),
                    ),
                    CommonButton(
                      buttonText: LocaleKeys.keyBack.localized,
                      buttonTextStyle : TextStyles.medium.copyWith(fontSize: 14, color: AppColors.clr787575),
                      backgroundColor: AppColors.transparent,
                      borderColor: AppColors.clr9E9E9E,
                      borderRadius: BorderRadius.circular(6),
                      width: context.width * 0.16,
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
