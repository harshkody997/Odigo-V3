import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/dependency_injection/inject.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureMainDependencies({required String environment}) async => GetItInjectableX(getIt).init(environment: environment);

abstract class Env {
  static const production = 'production';
  static const debug = 'debug';
  static const List<String> environments = [Env.production, Env.debug];
}
