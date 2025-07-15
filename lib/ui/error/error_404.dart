import 'package:flutter/material.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:odigov3/ui/error/mobile/error_404_mobile.dart';
import 'package:odigov3/ui/error/web/error_404_web.dart';
import 'package:odigov3/ui/utils/app_enums.dart';
import 'package:responsive_builder/responsive_builder.dart';


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';

class Error404 extends ConsumerStatefulWidget {
  final ErrorType? errorType;
  const Error404({Key? key,this.errorType}) : super(key: key);

  @override
  ConsumerState<Error404> createState() => _Error404State();
}

class _Error404State extends ConsumerState<Error404>  with WidgetsBindingObserver, ZoomAwareMixin{
  ///Init
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {});
  }

  ///Dispose
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  ///Build
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) {
        return Error404Mobile();
      },
      desktop: (BuildContext context) {
        return ErrorWeb(errorType: widget.errorType);
      },
      tablet: (BuildContext context) {
        return OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
            return orientation == Orientation.landscape ? ErrorWeb(errorType: widget.errorType) : const Error404Mobile();
          },
        );
      },
    );
  }
}
