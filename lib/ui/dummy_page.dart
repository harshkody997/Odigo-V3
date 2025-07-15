import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:odigov3/ui/drawer/web/base_drawer_page_widget.dart';

class DummyPage extends ConsumerStatefulWidget {
  const DummyPage({super.key});

  @override
  ConsumerState createState() => _DummyPageState();
}

class _DummyPageState extends ConsumerState<DummyPage> with WidgetsBindingObserver, ZoomAwareMixin {
  @override
  Widget buildPage(BuildContext context) {
    return BaseDrawerPageWidget(body: Container(color: Colors.blue,));
  }
}
