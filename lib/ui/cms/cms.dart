import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:odigov3/ui/cms/web/cms_web.dart';

class Cms extends ConsumerStatefulWidget {
  const Cms({super.key});

  @override
  ConsumerState<Cms> createState() => _CmsState();
}

class _CmsState extends ConsumerState<Cms> with WidgetsBindingObserver, ZoomAwareMixin {
  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) {
        return CmsWeb();
      },
      desktop: (BuildContext context) {
        return const CmsWeb();
      },
      tablet: (BuildContext context){
        return const CmsWeb();
      }
    );
  }
}

