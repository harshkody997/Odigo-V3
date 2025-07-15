import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/session.dart';
import 'package:odigov3/ui/routing/navigation_stack_item.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/app_enums.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class ErrorWeb extends ConsumerStatefulWidget {
  final ErrorType? errorType;

  const ErrorWeb({super.key, this.errorType = ErrorType.error404});

  @override
  ConsumerState<ErrorWeb> createState() => _ErrorWebState();
}

class _ErrorWebState extends ConsumerState<ErrorWeb> {
  String errorAsset = Assets.images.icAccessDenied.keyName;
  String buttonText = '';
  String title = LocaleKeys.keyDeniedActionTitle.localized;
  String subTitle = LocaleKeys.keyDeniedActionSubtitle.localized;

  @override
  void initState() {
    super.initState();
    showLog("Session.userAccessToken ${Session.userAccessToken}");
    showLog("Session.userAccessToken ${widget.errorType}");

    switch (widget.errorType) {
      case ErrorType.error403:
        buttonText = LocaleKeys.keyBackToLogin.localized;
        break;
      case ErrorType.error404:
        if (Session.userAccessToken.isNotEmpty || Session.userAccessToken != '') {
          buttonText = LocaleKeys.keyBackToHome.localized;
        } else {
          buttonText = LocaleKeys.keyBackToLogin.localized;
          title = LocaleKeys.keyLoginActionTitle.localized;
          subTitle = LocaleKeys.keyLoginActionSubtitle.localized;
        }
        break;
      case ErrorType.noInternet:
        buttonText = LocaleKeys.keyRefresh.localized;
      default:
        buttonText = LocaleKeys.keyBackToHome.localized;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: context.height * 0.16, width: context.height * 0.16, child: Image.asset(errorAsset)),
            SizedBox(
              height: context.height * 0.024,
            ),

            CommonText(
              title: title,
              style: TextStyles.bold.copyWith(fontSize: 24),
            ),
            SizedBox(
              height: context.height * 0.01,
            ),
            CommonText(
              title: subTitle,
              style: TextStyles.regular.copyWith(fontSize: 16),
            ),
            SizedBox(
              height: context.height * 0.024,
            ),
            CommonButton(
              width: context.width * 0.20,
              height: context.height * 0.058,
              buttonText: buttonText,
              onTap: () {
                showLog('widget.errorType ${widget.errorType}');
                if (Session.userAccessToken.isNotEmpty) {
                  ref.read(navigationStackController).pushAndRemoveAll(const NavigationStackItem.dashboard());
                } else {
                  ref.read(navigationStackController).pushAndRemoveAll(const NavigationStackItem.login());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
