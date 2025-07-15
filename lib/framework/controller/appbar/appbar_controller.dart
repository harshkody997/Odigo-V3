import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';


final appbarController = ChangeNotifierProvider(
      (ref) => getIt<AppbarController>(),
);

@injectable
class AppbarController extends ChangeNotifier {

  ///Dispose Controller
  void disposeController({bool isNotify = true}) {
    isLoading = false;

    if (isNotify) {
      notifyListeners();
    }
  }



  ///Progress Indicator
  bool isLoading = false;

  void updateLoadingStatus(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
