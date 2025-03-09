import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:torii_client/utils/exports.dart';

extension BuildContextExtension on BuildContext {
  void clearFocus() => FocusScope.of(this).requestFocus(FocusNode());

  DefaultTextStyle get defaultTextStyle => DefaultTextStyle.of(this);

  MediaQueryData get mediaQuery => MediaQuery.of(this);

  NavigatorState get navigator => Navigator.of(this);

  FocusScopeNode get focusScope => FocusScope.of(this);

  ScaffoldState get scaffold => Scaffold.of(this);

  ScaffoldMessengerState get scaffoldMessenger => ScaffoldMessenger.of(this);
}

extension RouterContextExtension on BuildContext {
  // Flutter Navigator
  void navigatorPopUntil(String routeLocation) {
    navigator.popUntil(
      (route) => route.isFirst || !route.willHandlePopInternally && route.settings.name == routeLocation,
    );
  }

  void navigatorPopUntilRoot() => navigatorPopUntil('/');

  void navigatorTryPop() => navigator.canPop() ? navigator.pop() : null;
}

