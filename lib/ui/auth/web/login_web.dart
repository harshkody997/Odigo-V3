import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/auth/login_controller.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/ui/auth/web/helper/common_auth_background.dart';
import 'package:odigov3/ui/auth/web/helper/login_form_dropdown_widget.dart';
import 'package:odigov3/ui/auth/web/helper/login_form_web.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';


class LoginWeb extends ConsumerStatefulWidget {
  const LoginWeb({super.key});

  @override
  ConsumerState<LoginWeb> createState() => _LoginWebState();
}

class _LoginWebState extends ConsumerState<LoginWeb> {

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final loginWatch = ref.read(loginController);
      loginWatch.disposeController(isNotify: true);

      if(loginWatch.languageList.isEmpty)
        {
          loginWatch.getLanguageListAPI(context,ref);

        }

      if(kDebugMode) {
        loginWatch.setLoginData();
      }

    });
    super.initState();
  }


  @override
  void dispose() {
    // emailFocusNode.dispose();
    // passwordFocusNode.dispose();
    super.dispose();
  }
  ///Build Override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: _bodyWidget());
  }


  ///Body Widget
  Widget _bodyWidget() {
    final loginWatch = ref.watch(loginController);
    return Stack(
      children: [
        Positioned.fill(
          child: CommonSVG(
            strIcon: Assets.svgs.svgLoginBackground.keyName,
            boxFit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: context.height * 0.045,
          left: 0,
          right: 0,
          child: Center(
            child: CommonSVG(
              strIcon: Assets.svgs.svgOdigoIcon.keyName,
              colorFilter: ColorFilter.mode(AppColors.black, BlendMode.srcIn),  // Apply black color to SVG
            ),
          ),
        ),
        Center(
            child: Material(
              elevation: 1,
              borderRadius: BorderRadius.circular(12),
              child: CommonAuthBackground(
                width: context.width * 0.3,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12), // From Figma
                  border: Border.all(color: AppColors.greyD6D6D6, width: 1.18),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    LoginFormDropdownWidget(),
                    SizedBox(height: context.height * 0.03),
                    LoginFormWeb(),
                  ],
                )
              ),
            ),

        ),
      ],
    );

  }
}
