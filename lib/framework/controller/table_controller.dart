import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';


final tableController = ChangeNotifierProvider(
      (ref) => getIt<TableController>(),
);

@injectable
class TableController extends ChangeNotifier {

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

  /// Manage approved hover
  int hoverIndex = -1;
  updateHoverIndex(int value){
    hoverIndex = value;
    notifyListeners();
  }

  /// Manage reject hover
  int hoverRejectIndex = -1;
  updateRejectHoverIndex(int value){
    hoverRejectIndex = value;
    notifyListeners();
  }

  // /// Manage status index
  // int statusTapIndex = -1;
  // bool statusValue = false;
  // updateStatusIndex(int value){
  //   statusTapIndex = value;
  //   statusValue = !statusValue;
  //   notifyListeners();
  // }
}
