import 'package:flutter/material.dart';

class NavigationServiceMain extends _NavigationService {
  NavigationServiceMain() : super(GlobalKey<NavigatorState>());
}

class _NavigationService {
  final GlobalKey<NavigatorState> navigatorKey;
  String activeTitle = '';

  _NavigationService(this.navigatorKey);

  void pop<T extends Object>([T? result]) {
    return navigatorKey.currentState?.pop(result);
  }

  void popUntil(bool Function(Route<dynamic>) predicate) {
    return navigatorKey.currentState?.popUntil(predicate);
  }

  Future? pushNamed(String routeName, {Object? args}) {
    return navigatorKey.currentState?.pushNamed(routeName, arguments: args);
  }

  Future? pushReplacementNamed(String routeName, {Object? args}) {
    return navigatorKey.currentState
        ?.pushReplacementNamed(routeName, arguments: args);
  }

  Future? pushRemoveUntil(String routeName, {Object? args}) {
    return navigatorKey.currentState?.pushNamedAndRemoveUntil(
        routeName, (Route<dynamic> route) => false,
        arguments: args);
  }
}
