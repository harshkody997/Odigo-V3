import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'mobile/more_info_mobile.dart';
import 'web/more_info_web.dart';

class MoreInfo extends ConsumerStatefulWidget {
  const MoreInfo({Key? key}) : super(key: key);

  @override
  ConsumerState<MoreInfo> createState() => _MoreInfoState();
}

class _MoreInfoState extends ConsumerState<MoreInfo> with WidgetsBindingObserver, ZoomAwareMixin{
  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
        mobile: (BuildContext context) {
          return const MoreInfoMobile();
        },
        desktop: (BuildContext context) {
          return const MoreInfoWeb();
        }
    );
  }
}

