import 'dart:async';
import 'dart:isolate';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trainingpods/pages/home_page.dart';
import 'package:trainingpods/pages/ui_view/sign_in_view.dart';
import 'package:trainingpods/utils/globals.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  firebaseApp = await Firebase.initializeApp();
  runZonedGuarded<Future<void>>(() async {
    SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    Isolate.current.addErrorListener(RawReceivePort((pair) async {
      final List<dynamic> errorAndStacktrace = pair;
      await FirebaseCrashlytics.instance.recordError(
        errorAndStacktrace.first,
        errorAndStacktrace.last,
      );
    }).sendPort);
    runApp(MyApp());
  }, FirebaseCrashlytics.instance.recordError);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  String getHomeScreen() {
    User? user = auth.auth.currentUser;
    if(user != null) {
      return '/alreadyLogged';
    } else {
      return '/';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Training Pods',
      initialRoute: getHomeScreen(),
      routes: {
        '/': (context) => const SignIn(),
        '/alreadyLogged': (context) => const HomeScreen(),
      },
    );
  }
}

