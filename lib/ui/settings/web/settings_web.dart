import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';
import 'package:odigov3/ui/drawer/web/base_drawer_page_widget.dart';
import 'package:odigov3/ui/settings/web/helper/settings_main_widget.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';

class SettingsWeb extends ConsumerStatefulWidget {
  const SettingsWeb({super.key});

  @override
  ConsumerState<SettingsWeb> createState() => _SettingsWebState();
}

class _SettingsWebState extends ConsumerState<SettingsWeb> {

  ///Build Override
  @override
  Widget build(BuildContext context) {
    return BaseDrawerPageWidget(body: _bodyWidget());
  }

  ///Body Widget
  Widget _bodyWidget() {
    return const SettingsMainWidget();
  }


}
