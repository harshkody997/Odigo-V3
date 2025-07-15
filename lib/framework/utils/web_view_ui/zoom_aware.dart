import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:odigov3/ui/utils/app_constants.dart';

class ZoomAware {
  ZoomAware._();

  static var zoomBox = Hive.box(AppConstants.zoomBoxName);

  static ZoomAware zoomAware = ZoomAware._();

  double get fixedHeight => zoomBox.get('fixedHeight') ?? 0;

  set fixedHeight(double fixedHeight) => zoomBox.put('fixedHeight', fixedHeight);

  double get fixedWidth => zoomBox.get('fixedWidth') ?? 0;

  set fixedWidth(double fixedWidth) => zoomBox.put('fixedWidth', fixedWidth);

  double get lastDevicePixelRatio => zoomBox.get('lastDevicePixelRatio') ?? 0;

  set lastDevicePixelRatio(double lastDevicePixelRatio) => zoomBox.put('lastDevicePixelRatio', lastDevicePixelRatio);

  double get initialDevicePixelRatio => zoomBox.get('initialDevicePixelRatio') ?? 0;

  set initialDevicePixelRatio(double initialDevicePixelRatio) => zoomBox.put('initialDevicePixelRatio', initialDevicePixelRatio);
}

final zoomController = ChangeNotifierProvider((ref) => ZoomController());

class ZoomController extends ChangeNotifier {
  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}
