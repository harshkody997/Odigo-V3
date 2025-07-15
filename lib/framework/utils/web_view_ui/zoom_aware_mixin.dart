import 'dart:ui';

import 'package:display_metrics/display_metrics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';

mixin ZoomAwareMixin<T extends ConsumerStatefulWidget> on ConsumerState<T>, WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        updateFixedSize();
      }
    });
  }

  @override
  void dispose() {
    if (mounted) {
      WidgetsBinding.instance.removeObserver(this);
    }
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    updateFixedSize();
  }

  void updateFixedSize() {
    if (!mounted) return;

    final window = WidgetsBinding.instance.window;
    final zoom = ZoomAware.zoomAware;

    final currentPixelRatio = window.devicePixelRatio;
    final physicalSize = window.physicalSize;
    final currentDPR = window.devicePixelRatio;
    final initialDPR = ZoomAware.zoomAware.initialDevicePixelRatio;
    final zoomFactor = currentDPR / initialDPR;

    // Initialize initial ratio only once
    zoom.initialDevicePixelRatio = zoom.initialDevicePixelRatio == 0 ? currentPixelRatio : zoom.initialDevicePixelRatio;

    final initialRatio = zoom.initialDevicePixelRatio;

    final newFixedHeight = physicalSize.height / initialRatio;
    final newFixedWidth = physicalSize.width / initialRatio;
    final sizeIncreased = newFixedHeight > zoom.fixedHeight || newFixedWidth > zoom.fixedWidth;

    // Check if zoom level has changed
    final zoomChanged = zoom.lastDevicePixelRatio != currentPixelRatio;

    // If neither changed, size not increased, and values already set, skip
    if (!zoomChanged && !sizeIncreased && zoom.fixedHeight != 0 && zoom.fixedWidth != 0) return;

    setState(() {
      zoom.lastDevicePixelRatio = currentPixelRatio;
      zoom.fixedHeight = newFixedHeight;
      zoom.fixedWidth = newFixedWidth;
    });
  }

  /// Classes using this mixin must implement this
  Widget buildPage(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.greyF7F7F7,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(width: ZoomAware.zoomAware.fixedWidth, height: ZoomAware.zoomAware.fixedHeight, child: buildPage(context)),
        ),
        // child: SizedBox(height: ZoomAware.zoomAware.fixedHeight, child: buildPage(context)),
      ),
    );
  }

  @override
  void didChangeAccessibilityFeatures() {
    // TODO: implement didChangeAccessibilityFeatures
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    // TODO: implement didChangeLocales
  }

  @override
  void didChangePlatformBrightness() {
    // TODO: implement didChangePlatformBrightness
  }

  @override
  void didChangeTextScaleFactor() {
    // TODO: implement didChangeTextScaleFactor
  }

  @override
  void didChangeViewFocus(ViewFocusEvent event) {
    // TODO: implement didChangeViewFocus
  }

  @override
  void didHaveMemoryPressure() {
    // TODO: implement didHaveMemoryPressure
  }

  @override
  Future<bool> didPopRoute() {
    // TODO: implement didPopRoute
    throw UnimplementedError();
  }

  @override
  Future<bool> didPushRoute(String route) {
    // TODO: implement didPushRoute
    throw UnimplementedError();
  }

  @override
  Future<bool> didPushRouteInformation(RouteInformation routeInformation) {
    // TODO: implement didPushRouteInformation
    throw UnimplementedError();
  }

  @override
  Future<AppExitResponse> didRequestAppExit() {
    // TODO: implement didRequestAppExit
    throw UnimplementedError();
  }

  @override
  void handleCancelBackGesture() {
    // TODO: implement handleCancelBackGesture
  }

  @override
  void handleCommitBackGesture() {
    // TODO: implement handleCommitBackGesture
  }

  @override
  bool handleStartBackGesture(PredictiveBackEvent backEvent) {
    // TODO: implement handleStartBackGesture
    throw UnimplementedError();
  }

  @override
  void handleUpdateBackGestureProgress(PredictiveBackEvent backEvent) {
    // TODO: implement handleUpdateBackGestureProgress
  }
}
