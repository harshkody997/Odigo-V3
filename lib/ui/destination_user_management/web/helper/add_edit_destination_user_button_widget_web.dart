import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/destination_user_management/add_edit_destination_user_controller.dart';
import 'package:odigov3/framework/controller/destination_user_management/destination_user_controller.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/theme/text_style.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';
import 'package:odigov3/ui/utils/widgets/common_toast_widget.dart';

class AddEditDestinationUserButtonWidgetWeb extends ConsumerWidget {
  final String? userId;
  const AddEditDestinationUserButtonWidgetWeb({super.key, this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addEditUserWatch = ref.watch(addEditDestinationUserController);
    return Row(
      children: [
        CommonButton(
          height: 43,
          width: 144,
          borderRadius: BorderRadius.circular(7),
          buttonText: LocaleKeys.keySave.localized,
          loaderSize: 28,
          onTap: ()async{
            if(addEditUserWatch.formKey.currentState?.validate()??false){
              await addEditUserWatch.addUpdateDestinationUserApi(userId: userId).then((_){
                if(addEditUserWatch.addUpdateUserState.success?.status == ApiEndPoints.apiStatus_200){
                  /// Success toast
                  showToast(context: context,isSuccess:true,message: '${LocaleKeys.keyUser.localized} ${userId !=null?LocaleKeys.keyUpdatedSuccessMsg.localized:LocaleKeys.keyCreatedSuccessMsg.localized}');
                  /// List api call
                  ref.read(destinationUserController).destinationUserListApi(false);
                  /// Pop
                  ref.read(navigationStackController).pop();
                }
              });
            }
          },
          buttonTextStyle: TextStyles.medium.copyWith(
            fontSize:14,
            color:AppColors.white,
          ),
        ).paddingOnly(right: 20),
        CommonButton(
          height: 43,
          width: 144,
          borderRadius: BorderRadius.circular(7),
          buttonText: LocaleKeys.keyBack.localized,
          backgroundColor: AppColors.transparent,
          borderColor: AppColors.clr9E9E9E,
          buttonTextColor: AppColors.clr787575,
          onTap: (){
            ref.read(navigationStackController).pop();
          },
        ),
      ],
    ).paddingOnly(bottom: 15);
  }
}
