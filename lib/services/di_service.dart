import 'package:fluro/fluro.dart';
import 'package:get_it/get_it.dart';

import 'camera_service.dart';
import 'image_service.dart';
import 'ml_service.dart';
import 'navigation_service.dart';

class DIService {
  static void initialize() {
    GetIt.I.registerSingleton<NavigationServiceMain>(NavigationServiceMain());
    GetIt.I.registerSingleton<CameraService>(CameraService());
    GetIt.I.registerSingleton<ImageService>(ImageService());
    GetIt.I.registerSingleton<MLService>(MLService());
    GetIt.I.registerSingleton<FluroRouter>(FluroRouter());
    // GetIt.I
    //     .registerSingleton<FlutterSecureStorage>(const FlutterSecureStorage());
  }

  // static void initializeConfig(Dio dio) {
  //   GetIt.I.registerSingleton<UserService>(UserService());
  //   GetIt.I.registerSingleton<Dio>(dio);
  // }
}
