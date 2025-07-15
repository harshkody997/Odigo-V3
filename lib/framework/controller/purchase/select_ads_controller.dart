import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';

final selectAdsController = ChangeNotifierProvider((ref) => getIt<SelectAdsController>());

@injectable
class SelectAdsController extends ChangeNotifier {
  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    isLoading = false;

    if (isNotify) {
      notifyListeners();
    }
  }

  /*
  /// ---------------------------- Api Integration ---------------------------------///
   */

  ///Progress Indicator
  bool isLoading = false;

  void updateLoadingStatus(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
