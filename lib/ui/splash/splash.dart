import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/master/country/country_list_controller.dart';
import 'package:odigov3/framework/utils/session.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:odigov3/ui/routing/navigation_stack_item.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/splash/mobile/splash_mobile.dart';
import 'package:odigov3/ui/splash/web/splash_web.dart';
import 'package:responsive_builder/responsive_builder.dart';

class Splash extends ConsumerStatefulWidget {
  const Splash({super.key});

  @override
  ConsumerState<Splash> createState() => _SplashState();
}

class _SplashState extends ConsumerState<Splash> with WidgetsBindingObserver, ZoomAwareMixin {
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      final countryListWatch = ref.read(countryListController);
      countryListWatch.disposeController(isNotify: true);
      await countryListWatch.getLanguageListAPI(context, ref);
      // ref.read(navigationStackController).pushAndRemoveAll(const NavigationStackItem.error());
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          if (Session.userAccessToken.isNotEmpty) {
            ref.read(navigationStackController).pushAndRemoveAll(const NavigationStackItem.dashboard());
          } else {
            ref.read(navigationStackController).pushAndRemoveAll(const NavigationStackItem.login());
          }
        }
      });
    });
    super.initState();
  }

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) {
        return const SplashWeb();
      },
      desktop: (BuildContext context) {
        return const SplashWeb();
      },
      tablet: (BuildContext context)
      {
        return const SplashWeb();
      },
    );
  }
}
