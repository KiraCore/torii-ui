import 'package:go_router/go_router.dart';
import 'package:torii_client/utils/exports.dart';

extension GoRouterExtension on GoRouter {
  void tryPop() => canPop() ? pop() : null;

  String? get currentRouteLocation {
    try {
      return routerDelegate.currentConfiguration.last.matchedLocation;
    } catch (_) {
      return null;
    }
  }

  GoRoute? get currentRoute {
    try {
      return routerDelegate.currentConfiguration.last.route;
    } catch (_) {
      return null;
    }
  }

  GoRoute? get previousRoute {
    try {
      final routes = routerDelegate.currentConfiguration.routes;
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
      return routerDelegate.currentConfiguration.matches.any((r) => r.matchedLocation == route);
    } catch (_) {
      return false;
    }
  }

  /// ShellRoute has no `path`
  /// , so we need to check if any of the subRoutes has the same path as the currentRoute
  bool isShellRouteOpened(List<TypedGoRoute<GoRouteData>> subRoutes) {
    final path = currentRoute?.path;
    return subRoutes.map((r) => r.path).any((p) => p == path);
  }

  void popUntilRoot() {
    final GoRouterDelegate delegate = routerDelegate;
    final routes = delegate.currentConfiguration.routes;
    if (routes.length <= 1) return;
    for (var i = 0; i < routes.length - 1; i++) {
      pop();
    }
  }
}
