import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:torii_client/utils/browser/rpc_browser_url_controller.dart';
import 'package:torii_client/utils/exports.dart';
import 'package:torii_client/utils/extensions/go_router_extension.dart';

class KiraGoRouter extends GoRouter {
  KiraGoRouter({
    required List<RouteBase> routes,
    super.onException,
    super.errorPageBuilder,
    super.errorBuilder,
    GoRouterRedirect? redirect,
    int redirectLimit = 5,
    super.routerNeglect = false,
    super.initialLocation,
    super.overridePlatformDefaultLocation = false,
    super.initialExtra,
    super.debugLogDiagnostics = false,
    super.navigatorKey,
    super.restorationScopeId,
    super.requestFocus = true,
  }) : super.routingConfig(
         routingConfig: _ConstantRoutingConfig(
           RoutingConfig(
             routes: routes,
             redirect: (context, state) {
               // Preserve the redirect function passed in the constructor
               final userRedirect = redirect?.call(context, state);
               if (userRedirect != null) {
                 return userRedirect;
               }

               final rpcAddress = getIt<RpcBrowserUrlController>().getRpcAddress();
               // If no redirect from user, ensure our query parameter is preserved
               if (!state.uri.queryParameters.containsKey('rpc')) {
                 // Create a new URI with the rpc parameter
                 final uri = state.uri;
                 final newUri = uri.replace(
                   queryParameters: {...uri.queryParameters, if (rpcAddress != null) 'rpc': rpcAddress},
                 );
                 return newUri.toString();
               }

               return null;
             },
             redirectLimit: redirectLimit,
           ),
         ),
       );

  // Helper method to add RPC parameter to any location
  String _addRpcParameter(String location) {
    final uri = Uri.parse(location);
    if (uri.queryParameters.containsKey('rpc')) {
      return location;
    }

    final rpcAddress = getIt<RpcBrowserUrlController>().getRpcAddress();
    final newUri = uri.replace(queryParameters: {...uri.queryParameters, if (rpcAddress != null) 'rpc': rpcAddress});

    return newUri.toString();
  }

  @override
  Future<T?> push<T extends Object?>(String location, {Object? extra}) async {
    return super.push(_addRpcParameter(location), extra: extra);
  }

  @override
  Future<T?> pushReplacement<T extends Object?>(String location, {Object? extra}) async {
    return super.pushReplacement(_addRpcParameter(location), extra: extra);
  }

  @override
  Future<T?> replace<T extends Object?>(String location, {Object? extra}) async {
    return super.replace(_addRpcParameter(location), extra: extra);
  }

  @override
  void go(String location, {Object? extra}) {
    return super.go(_addRpcParameter(location), extra: extra);
  }

  @override
  void pop<T extends Object?>([T? result]) {
    // For pop operations, we rely on the redirect function to ensure
    // the query parameter is preserved when returning to the previous route
    super.pop(result);
  }
}

class _ConstantRoutingConfig extends ValueListenable<RoutingConfig> {
  _ConstantRoutingConfig(this.config);

  final RoutingConfig config;

  @override
  void addListener(VoidCallback listener) {
    // TODO: implement addListener
  }

  @override
  void removeListener(VoidCallback listener) {
    // TODO: implement removeListener
  }

  @override
  RoutingConfig get value => config;
}
