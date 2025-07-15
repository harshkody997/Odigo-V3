import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import '../../dependency_injection/inject.dart';


final settleWalletController = ChangeNotifierProvider(
      (ref) => getIt<SettleWalletController>(),
);

@injectable
class SettleWalletController extends ChangeNotifier {

  ///Dispose Controller
  void disposeController({bool isNotify = true}) {
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
