import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';


final addEditCountryController = ChangeNotifierProvider(
      (ref) => getIt<AddEditCountryController>(),
);

@injectable
class AddEditCountryController extends ChangeNotifier {

  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    formKey.currentState?.reset();
    countryNameENCtr.clear();
    countryNameARCtr.clear();
    countryCodeCtr.clear();
    currencyCtr.clear();
    if (isNotify) {
      notifyListeners();
    }
  }

  final formKey = GlobalKey<FormState>();
  TextEditingController countryNameENCtr = TextEditingController();
  TextEditingController countryNameARCtr = TextEditingController();
  TextEditingController countryCodeCtr = TextEditingController();
  TextEditingController currencyCtr = TextEditingController();

  /*
  /// ---------------------------- Api Integration ---------------------------------///
   */

}
