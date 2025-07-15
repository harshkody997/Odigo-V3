import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:odigov3/ui/destination/store_mapping/mobile/store_mapping_mobile.dart';
import 'package:odigov3/ui/destination/store_mapping/web/store_mapping_web.dart';
import 'package:responsive_builder/responsive_builder.dart';

class StoreMapping extends ConsumerStatefulWidget {
  const StoreMapping({super.key});

  @override
  ConsumerState<StoreMapping> createState() => _StoreMapping();
}

class _StoreMapping extends ConsumerState<StoreMapping> with WidgetsBindingObserver, ZoomAwareMixin {
  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // final storeMappingRead = ref.read(storeMappingController);
      //storeMappingRead.disposeController(isNotify : true);
    });
  }

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) {
        return const StoreMappingMobile();
      },
      desktop: (BuildContext context) {
        return const StoreMappingWeb();
      },
    );
  }
}
