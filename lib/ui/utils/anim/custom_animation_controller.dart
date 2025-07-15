import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';

final customAnimationController = ChangeNotifierProvider((ref) => getIt<CustomAnimationController>());

@injectable
class CustomAnimationController extends ChangeNotifier {
  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}
