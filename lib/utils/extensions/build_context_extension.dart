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

extension RouterExtension on BuildContext {
  // Flutter Navigator
  void navigatorPopUntil(String routeLocation) {
    navigator.popUntil(
      (route) => route.isFirst || !route.willHandlePopInternally && route.settings.name == routeLocation,
    );
  }

  void navigatorPopUntilRoot() => navigatorPopUntil('/');

  void navigatorTryPop() => navigator.canPop() ? navigator.pop() : null;

  // GoRouter
  void tryPop() => canPop() ? pop() : null;

  String? get currentRouteLocation {
    try {
      return GoRouter.of(this).routerDelegate.currentConfiguration.last.matchedLocation;
    } catch (_) {
      return null;
    }
  }

  GoRoute? get currentRoute {
    try {
      return GoRouter.of(this).routerDelegate.currentConfiguration.last.route;
    } catch (_) {
      return null;
    }
  }

  GoRoute? get previousRoute {
    try {
      final routes = GoRouter.of(this).routerDelegate.currentConfiguration.routes;
      return routes[routes.length - 2] as GoRoute;
    } catch (_) {
      return null;
    }
  }

  bool isCurrentRoute(String route) => currentRouteLocation == route;

  bool isPreviousRouteDialog() => previousRoute?.parentNavigatorKey == navigatorKey;

  /// For example, route is in the context, but the current route is Dialog
  bool isRouteInContext(String route) {
    try {
      return GoRouter.of(this).routerDelegate.currentConfiguration.matches.any((r) => r.matchedLocation == route);
    } catch (_) {
      return false;
    }
  }

  /// ShellRoute has no `path`
  /// , so we need to check if any of the subRoutes has the same path as the currentRoute
  bool isShellRouteOpened(List<TypedGoRoute<GoRouteData>> subRoutes) {
    final path = currentRoute;
    return subRoutes.map((r) => r.path).any((p) => p == path);
  }
}
