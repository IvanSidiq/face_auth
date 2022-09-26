import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';

import '../services/di_service.dart';
import '../services/navigation_service.dart';

class MainRepository {
  MainRepository() {
    _init();
  }

  _init() async {
    await setConfig();
    GetIt.I<NavigationServiceMain>().pushReplacementNamed('/choose_nisn');

    // LocationPermission permission = await Geolocator.checkPermission();
    // if (permission == LocationPermission.denied) {
    //   permission = await Geolocator.requestPermission();
    // } else {
    //   await Future.delayed(Duration(milliseconds: 1500));
    // }
  }

  Future<void> setConfig() async {
    Dio dio = await _setupDio();
    DIService.initializeConfig(dio);
  }

  Future<Dio> _setupDio() async {
    BaseOptions options = BaseOptions(
        baseUrl: FlavorConfig.instance.variables["baseUrl"],
        connectTimeout: 8000,
        receiveTimeout: 8000,
        sendTimeout: 8000,
        headers: {
          'accept': 'application/json',
          'X-Localization': 'id',
        });

    Dio dio = Dio(options);

    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };

    final value = await getApplicationDocumentsDirectory();
    final appDocPath = value.path;
    final presistCookie = PersistCookieJar(
      ignoreExpires: true,
      storage: FileStorage(
        '$appDocPath/face_auth/cookies/',
      ),
    );

    dio.interceptors.add(CookieManager(presistCookie));
    dio.interceptors.add(LogInterceptor(
      responseBody: true,
      error: true,
      request: true,
      requestBody: true,
      // requestHeader: true,
      // responseHeader: true,
    ));

    return dio;
  }

  /// Create a [AndroidNotificationChannel] for heads up notifications
  /*AndroidNotificationChannel androidChannel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.high,
    enableVibration: true,
    playSound: true,
  );*/

  /*Future _setupLocalNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings();

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );*/

  /*await GetIt.I<FlutterLocalNotificationsPlugin>().initialize(
      initializationSettings,
      onSelectNotification: _selectNotification,
    );*/

  /*if (Platform.isAndroid) {
      await GetIt.I<FlutterLocalNotificationsPlugin>()
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()!
          .createNotificationChannel(androidChannel);
    }
  }*/
/*
  Future _selectNotification(String? payload) async {
    if (payload != null) {
      print('notification payload: $payload');
    }

    return GetIt.I<NavigationServiceMain>()
        .pushReplacementNamed('/notification');
  }

  _setupFCM() {
    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        GetIt.I<FlutterLocalNotificationsPlugin>().show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              androidChannel.id,
              androidChannel.name,
              androidChannel.description,
            ),
          ),
        );
      }
    });
  }*/
}
