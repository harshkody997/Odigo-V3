import 'package:display_metrics/display_metrics.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/utils/web_helpers.dart';
import 'package:odigov3/ui/routing/delegate.dart';
import 'package:odigov3/ui/routing/parser.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/anim/notification_manager.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/widgets/no_thumb_scroll_indicator.dart';
import 'dart:html' as html;
import 'package:js/js.dart';

@JS('trimVideoJS')external trimVideoJS(html.Blob file, double startTime, double endTime);
Future<void> main() async {
  await Hive.initFlutter();
  await Hive.openBox(AppConstants.userBoxName);
  await Hive.openBox(AppConstants.zoomBoxName);
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await configureMainDependencies(environment: Env.debug);
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyDggKmq4QvKzvnC6X0bz965wEmhqBhBps8',
          authDomain: 'odigo-v3.firebaseapp.com',
          projectId: 'odigo-v3',
          storageBucket: 'odigo-v3.firebasestorage.app',
          messagingSenderId: '778431670895',
          appId: '1:778431670895:web:3050f7b190e01ef393bb9a',
          measurementId: 'G-P5BC7B0MEJ'
      )
  );
  setUrlStrategy(PathUrlStrategy());
  runApp(
    ProviderScope(
      child: EasyLocalization(supportedLocales: const <Locale>[Locale('en'), Locale('ar')], useOnlyLangCode: true, path: 'assets/lang', child: const MyApp()),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    WebHelper.setDefaultFavicon();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      AppConstants.constant.globalRef = ref;
      FirebasePushNotificationManager.instance.setupInteractedMessage(ref);

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DisplayMetricsWidget(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: AppConstants.appName,
        theme: ThemeData(highlightColor: Colors.transparent, splashColor: Colors.transparent, hoverColor: Colors.transparent),
        supportedLocales: EasyLocalization.of(context)!.supportedLocales,
        scrollBehavior: NoThumbScrollBehavior().copyWith(scrollbars: false),
        localizationsDelegates: context.localizationDelegates,
        locale: EasyLocalization.of(context)!.locale,
        routerDelegate: getIt<MainRouterDelegate>(param1: ref.read(navigationStackController)),
        routeInformationParser: getIt<MainRouterInformationParser>(param1: ref, param2: context),
      ),
    );
  }
}
