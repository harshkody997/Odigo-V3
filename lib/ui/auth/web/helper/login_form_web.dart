import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/auth/login_controller.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/controller/profile/profile_controller.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/form_validations.dart';
import 'package:odigov3/ui/routing/navigation_stack_item.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/text_style.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';
import 'package:odigov3/ui/utils/widgets/common_form_field.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';


class LoginFormWeb extends ConsumerStatefulWidget {

  const LoginFormWeb({super.key});

  @override
  ConsumerState<LoginFormWeb> createState() => _LoginFormWebState();
}

class _LoginFormWebState extends ConsumerState<LoginFormWeb> {

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

// @override
//   void initState() {
//   SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
//     final loginWatch = ref.read(loginController);
//
//     // emailFocusNode.addListener(() {
//     //   loginWatch.updateEmailFocus(emailFocusNode.hasFocus);
//     // });
//     // passwordFocusNode.addListener(() {
//     //   loginWatch.updatePswFocus(passwordFocusNode.hasFocus);
//     // });
//
//     super.initState();
//   });
// }

  @override
  Widget build(BuildContext context) {
    final loginWatch = ref.watch(loginController);
    GlobalKey<FormState> globalKey = GlobalKey();

    return   Form(
      key: globalKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          CommonText(
            title: LocaleKeys.keyHelloAgain.localized,
            style: TextStyles.bold.copyWith(fontSize: 24),
          ),
          SizedBox(height: context.height * 0.013),
          CommonText(
            title: LocaleKeys.keyLoginNote.localized,
            style: TextStyles.regular.copyWith(fontSize: 16),
            maxLines: 2,
          ),

          SizedBox(height: context.height * 0.022),
          Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity( loginWatch.isEmailFocused?0.04:0), // soft shadow
                    blurRadius: 10,
                    offset: Offset(0, 0), // shadow position
                  ),
                ],
              ),
              child:
              CommonInputFormField(
                textEditingController: loginWatch.emailController,
                borderRadius: BorderRadius.circular(11),
                cursorColor: AppColors.black,
                focusNode: emailFocusNode,
                backgroundColor: AppColors.white,
                onFieldSubmitted: (value) {
                passwordFocusNode.requestFocus();
                },
                textInputFormatter: [
                  FilteringTextInputFormatter.deny(RegExp(r'\s')),
                ],
                hintTextStyle: TextStyles.regular.copyWith(
                  fontSize: 14,
                  color: AppColors.grey8D8C8C,
                ),
                textInputAction: TextInputAction.next,
                fieldTextStyle: TextStyles.regular.copyWith(
                  fontSize: 14,
                  color: AppColors.black272727,
                ),
                hintText: LocaleKeys.keyEmailID.localized,
                validator: (email) => validateEmail(email),
              )),

          SizedBox(height: context.height * 0.040),
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity( loginWatch.isPasswordFocused?0.04:0), // soft shadow
                  blurRadius: 10,
                  offset: Offset(0, 0), // shadow position
                ),
              ],
            ),
            child: CommonInputFormField(
              textEditingController: loginWatch.passwordController,
              obscureText: !loginWatch.isPasswordVisible,
              hintText: LocaleKeys.keyPassword.localized,
              focusNode: passwordFocusNode,
              cursorColor: AppColors.black,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (val){
                bool isValid = globalKey.currentState?.validate() ?? false;
                if (isValid) {
                  _loginApiCall(context, ref);
                }

              },
              borderRadius: BorderRadius.circular(12),
              suffixWidget: InkWell(
                onTap: () {
                  loginWatch.updateIsPasswordVisible(!loginWatch.isPasswordVisible);
                },
                child: CommonSVG(strIcon: loginWatch.isPasswordVisible ? Assets.svgs.svgHidePasswordSvg.path : Assets.svgs.svgShowPasswordSvg.path),
              ),

              hintTextStyle: TextStyles.regular.copyWith(
                fontSize: 14,
                color: AppColors.grey8D8C8C,
              ),
              fieldTextStyle: TextStyles.regular.copyWith(
                fontSize: 14,
                color: AppColors.black272727,
              ),
              validator: (password) => validatePassword(password),
            ),
          ),
          SizedBox(height: context.height * 0.026),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                child: CommonText(
                  title: '${LocaleKeys.keyForgetPassword.localized}?',

                  style: TextStyles.regular.copyWith(
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                    color: AppColors.black333333,
                  ),
                ),
                onTap: () {

                  ref.read(navigationStackController)
                      .push(NavigationStackItem.forgotPassword());
                },
              ),

              /*removed as per latest figma*/
              // Row(
              //   children: [
              //     CommonSVG(strIcon: Assets.svgs.svgContactUs.path,height: 21,width: 21,),
              //     CommonText(
              //       title: '${LocaleKeys.keyContactUs.localized}',
              //
              //       style: TextStyles.regular.copyWith(
              //         fontSize: 16,
              //         color: AppColors.black333333,
              //       ),
              //     ).paddingOnly(left: 5),
              //   ],
              // )
            ],
          ),
          SizedBox(height: context.height * 0.036),

          CommonButton(
            height: context.height * 0.077,
            borderRadius: BorderRadius.circular(9),
            isLoading: loginWatch.loginState.isLoading,
            onValidateTap: () {
              globalKey.currentState?.validate();
            },
            buttonTextStyle: TextStyles.regular.copyWith(
              fontSize: 16,
              color: AppColors.white,
            ),
            buttonText: LocaleKeys.keyContinue.localized,
            onTap: () {
              bool isValid = globalKey.currentState?.validate() ?? false;
              if (isValid) {
               _loginApiCall(context, ref);
              }
            },
          ),
        ],
      ),
    );
  }






  _loginApiCall(BuildContext context, WidgetRef ref) async {
    final loginWatch = ref.read(loginController);
    final drawerWatch = ref.watch(drawerController);
    final profileWatch = ref.watch(profileController);
    await loginWatch.loginApi(context).then((value) async {
      if (loginWatch.loginState.success?.status == ApiEndPoints.apiStatus_200) {
        if(context.mounted){
          await profileWatch.changeLanguageApi(context);
          await drawerWatch.getSideMenuListAPI(context);
        }
        ref.read(navigationStackController).pushAndRemoveAll(const NavigationStackItem.dashboard());

      }
    },
    );
  }



}

