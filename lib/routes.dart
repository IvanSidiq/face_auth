import 'package:face_auth/pages/camera_page.dart';
import 'package:face_auth/pages/choose_nisn_page.dart';
import 'package:face_auth/pages/home_page.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:velocity_x/velocity_x.dart';

void configureRoutes() {
  final router = GetIt.I<FluroRouter>();

  router.notFoundHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return const _RoutesNotFound();
    },
  );

  router.define(
    '/camera',
    handler: Handler(
      handlerFunc: (BuildContext? context, Map<String, List<String>> params) =>
          const CameraPage(),
    ),
    transitionType: TransitionType.none,
  );

  router.define(
    '/choose_nisn',
    handler: Handler(
      handlerFunc: (BuildContext? context, Map<String, List<String>> params) =>
          const ChooseNisnPage(),
    ),
    transitionType: TransitionType.none,
  );
}

class _RoutesNotFound extends StatelessWidget {
  const _RoutesNotFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            'Route not found'.text.make(),
          ],
        ),
      ),
    );
  }
}
