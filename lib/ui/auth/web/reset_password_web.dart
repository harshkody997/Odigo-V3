import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/ui/auth/web/helper/common_auth_background.dart';
import 'package:odigov3/ui/auth/web/helper/reset_password_form.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import '../../../framework/controller/auth/reset_password_controller.dart';




class ResetPasswordWeb extends ConsumerStatefulWidget {
  String? email;
  String? otp;
   ResetPasswordWeb({super.key,this.email,this.otp});

  @override
  ConsumerState<ResetPasswordWeb> createState() => _ForgotPasswordWebState();
}

class _ForgotPasswordWebState extends ConsumerState<ResetPasswordWeb> {


  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final resetPasswordWatch = ref.read(resetPasswordController);
      resetPasswordWatch.disposeController(isNotify : true);
      print('email======${widget.email}');
      print('otp======${widget.otp}');
    });
  }


  ///Build Override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor:AppColors.greyF7F7F7,body: _bodyWidget());
  }

  Widget _bodyWidget() {

    return  Stack(
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
              // shadowColor: Colors.black26,
              child: CommonAuthBackground(
                  width: context.width * 0.34,
               // height: context.height * 0.62,
               //  decoration: BoxDecoration(
               //    color: AppColors.white,
               //    borderRadius: BorderRadius.circular(12), // From Figma
               //    border: Border.all(color: AppColors.greyD6D6D6, width: 1.18),
               //  ),
                content: ResetPasswordForm(email: widget.email,otp: widget.otp,)

              ),
            ),
        ),
      ],
    );


  }

}