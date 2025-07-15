import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:odigov3/ui/cms/web/show_cms_web.dart';
import 'package:odigov3/ui/utils/app_enums.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ShowCms extends ConsumerStatefulWidget {
  final String title;
  ShowCms({super.key,required this.title});

  @override
  ConsumerState<ShowCms> createState() => _ShowCmsState();
}

class _ShowCmsState extends ConsumerState<ShowCms> with WidgetsBindingObserver, ZoomAwareMixin {
  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) {
        return ShowCmsWeb(title: widget.title);
      },
      desktop: (BuildContext context) {
        return ShowCmsWeb(title: widget.title);
      },
      tablet: (BuildContext context){
        return ShowCmsWeb(title: widget.title);
      }
    );
  }
}

