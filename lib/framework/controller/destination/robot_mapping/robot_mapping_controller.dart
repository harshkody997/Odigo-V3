import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';

/// Riverpod provider to access StoreMappingController via dependency injection
final robotMappingController = ChangeNotifierProvider((ref) => getIt<RobotMappingController>());

@injectable
class RobotMappingController extends ChangeNotifier {
  /// Dispose controller and optionally notify listeners
  void disposeController({bool isNotify = false}) {
    isLoading = false;

    if (isNotify) {
      notifyListeners();
    }
  }

  /// Key to access and validate the form
  GlobalKey<FormState> robotMappingFormKey = GlobalKey();

  /// Global key to manage the robot assignment dialog widget.
  GlobalKey assignRobotDialogKey = GlobalKey();

  /// Text editing controllers for the dropdown fields
  final TextEditingController robotIdController = TextEditingController();

  /*
  /// ---------------------------- Api Integration ---------------------------------///
   */

  /// Show/hide loading indicator (used for future API integration)
  bool isLoading = false;

  /// Update loading status and notify listeners
  void updateLoadingStatus(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
