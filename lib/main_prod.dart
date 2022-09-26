import 'package:face_auth/routes.dart';
import 'package:face_auth/services/di_service.dart';
import 'package:face_auth/services/navigation_service.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:get_it/get_it.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'pages/nisn/choose_nisn_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DIService.initialize();
  configureRoutes();

  FlavorConfig(
    name: "PRODUCTION",
    color: Colors.green,
    location: BannerLocation.topStart,
    variables: {
      "baseUrl": "https://api.production.belajarplus.id",
      "baseAvatar": "",
      "username": "",
      "password": "",
    },
  );

  runApp(const FaceAuthApp());
}

class FaceAuthApp extends StatelessWidget {
  const FaceAuthApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ColorScheme lightScheme = ColorScheme.fromSeed(
        seedColor: const Color(0xFF2155CF), brightness: Brightness.light);
    final ColorScheme darkScheme = ColorScheme.fromSeed(
        seedColor: const Color(0xFFB4C5FF), brightness: Brightness.dark);

    return MaterialApp(
      navigatorObservers: [
        SentryNavigatorObserver(),
      ],
      navigatorKey: GetIt.I<NavigationServiceMain>().navigatorKey,
      onGenerateRoute: GetIt.I<FluroRouter>().generator,
      theme: ThemeData(
        backgroundColor: lightScheme.surface,
        colorScheme: lightScheme,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Inter',
      ),
      darkTheme: ThemeData(
        backgroundColor: darkScheme.surface,
        colorScheme: darkScheme,
        scaffoldBackgroundColor: Colors.black,
        fontFamily: 'Inter',
      ),
      home: const ChooseNisnPage(),
    );
  }
}
