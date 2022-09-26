import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:face_auth/services/user_service.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';

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
    GetIt.I.registerSingleton<CacheManager>(CacheManager(
      Config(
        'faplus_cache',
        stalePeriod: const Duration(days: 7),
        maxNrOfCacheObjects: 10,
        repo: JsonCacheInfoRepository(databaseName: 'faplus_cache'),
        fileService: HttpFileService(),
      ),
    ));

    GetIt.I
        .registerSingleton<FlutterSecureStorage>(const FlutterSecureStorage());
  }

  static void initializeConfig(Dio dio) {
    GetIt.I.registerSingleton<UserService>(UserService());
    GetIt.I.registerSingleton<Dio>(dio);
  }
}
