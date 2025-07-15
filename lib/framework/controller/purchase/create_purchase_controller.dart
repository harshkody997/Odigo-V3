import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';

final createPurchaseController = ChangeNotifierProvider((ref) => getIt<CreatePurchaseController>());

@injectable
class CreatePurchaseController extends ChangeNotifier {
  ///Dispose Controller
  void disposeController({bool isNotify = false}) {


    if (isNotify) {
      notifyListeners();
    }
  }

  /*
  /// ---------------------------- Api Integration ---------------------------------///
   */


}
