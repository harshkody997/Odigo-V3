import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/auth/login_controller.dart';
import 'package:odigov3/framework/controller/settings/settings_controller.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:odigov3/ui/settings/web/settings_web.dart';

class Settings extends ConsumerStatefulWidget {
  const Settings({super.key});

  @override
  ConsumerState<Settings> createState() => _SettingsState();
}

class _SettingsState extends ConsumerState<Settings> with WidgetsBindingObserver, ZoomAwareMixin {

  ///Init Override
  @override
  void initState() {
    super.initState();
    final settingsRead = ref.read(settingsController);
    settingsRead.disposeController();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async{
      settingsRead.getSettingsList(context);
    });
  }

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) {
        return const SettingsWeb();
      },
      tablet: (BuildContext context) {
        return const SettingsWeb();
      },
      desktop: (BuildContext context) {
        return const SettingsWeb();
      },
    );
  }
}

