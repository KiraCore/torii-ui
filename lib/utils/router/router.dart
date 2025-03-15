import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:torii_client/domain/models/connection/connection_error_type.dart';
import 'package:torii_client/presentation/intro/intro_page.dart';
import 'package:torii_client/presentation/network/bloc/network_module_bloc.dart';
import 'package:torii_client/presentation/network/network_drawer_page/network_drawer_page.dart';
import 'package:torii_client/presentation/network/network_list_page.dart';
import 'package:torii_client/presentation/session/cubit/session_cubit.dart';
import 'package:torii_client/presentation/sign_in/keyfile_dropzone/sign_in_keyfile_drawer_page.dart';
import 'package:torii_client/presentation/sign_in/mnemonic/sign_in_mnemonic_drawer_page.dart';
import 'package:torii_client/presentation/sign_in/sign_in_drawer_page.dart';
import 'package:torii_client/presentation/transfer/input/transfer_input_page.dart';
import 'package:torii_client/utils/browser/rpc_browser_url_controller.dart';
import 'package:torii_client/utils/exports.dart';
import 'package:torii_client/utils/router/kira_go_router.dart';

import 'router_dialog_page.dart';
part 'router.g.dart';

final KiraGoRouter router = KiraGoRouter(
  routes: $appRoutes,
  navigatorKey: navigatorKey,
  debugLogDiagnostics: kDebugMode,
  initialLocation: const IntroRoute().location,
  // TODO: refactor
  redirect: (context, state) {
    print('redirecting ${state.fullPath}');
    return null;
  },
);

extension GoRouterStateX on GoRouter {
  Future<T?> pushWithState<T extends Object?>(String location, {Object? extra}) async {
    // GoRouteData goRouteData = _addQueryParameters(GoRouteData(location));
    return push(location, extra: extra);
  }

  void popWithState<T extends Object?>([T? result]) {
    print('ppp popping ${routerDelegate.currentConfiguration.uri}');
    routerDelegate.pop<T>(result);
  }

  // GoRouteData _addQueryParameters(String location) {
  //   List<GoRouteData> pageRouteInfoList = pageRouteInfo.flattened.reversed.toList();
  //   late GoRouteData newGoRouteData;

  //   for (int i = 0; i < pageRouteInfoList.length; i++) {
  //     GoRouteData localGoRouteData = pageRouteInfoList[i].copyWith(children: <GoRouteData>[]);

  //     if (i == 0) {
  //       newGoRouteData = _setupTargetRoute(localGoRouteData);
  //     } else {
  //       newGoRouteData = _wrapRoute(localGoRouteData, newGoRouteData);
  //     }
  //   }
  //   return newGoRouteData;
  // }

  // Map<String, dynamic> _parseQueryParameters(String location) {
  //   // GoRouteData _setupTargetRoute(GoRouteData pageRouteInfo) {
  //   //   String networkUrl = getIt<NetworkModuleBloc>().state.networkUri.toString();

  //   //   return pageRouteInfo.copyWith(
  //   //     queryParams: <String, dynamic>{RpcBrowserUrlController.rpcQueryParameterKey: networkUrl},
  //   //   );
  //   // }

  //   // GoRouteData _wrapRoute(GoRouteData parentGoRouteData, GoRouteData childGoRouteData) {
  //   //   return parentGoRouteData.copyWith(children: <GoRouteData>[childGoRouteData]);
  //   // }
  // }
}

@TypedGoRoute<IntroRoute>(path: '/intro')
class IntroRoute extends GoRouteData {
  const IntroRoute();

  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) async {
    if (context.read<SessionCubit>().state.isLoggedIn) {
      await Future.delayed(Duration.zero);
      return TransferRoute.initialRoute;
    }
    return super.redirect(context, state);
  }
  
  @override
  Widget build(BuildContext context, GoRouterState state) => const IntroPage();
}

@TypedShellRoute<TransferRoute>(
  routes: <TypedRoute<RouteData>>[
    TypedGoRoute<TransferInputRoute>(path: '/transfer-input'),
    TypedGoRoute<TransferInProgressRoute>(path: '/transfer-in-progress'),
    TypedGoRoute<TransferReadyToClaimRoute>(path: '/transfer-ready-to-claim'),
  ],
)
class TransferRoute extends ShellRouteData {
  const TransferRoute();

  static String initialRoute = '/transfer-input';

  @override
  Widget builder(BuildContext context, GoRouterState state, Widget navigator) => navigator;
}

class TransferInputRoute extends GoRouteData {
  const TransferInputRoute();

  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) {
    if (!context.read<SessionCubit>().state.isLoggedIn) {
      return const IntroRoute().location;
    }
    return super.redirect(context, state);
  }

  @override
  Widget build(BuildContext context, GoRouterState state) => const TransferInputPage();
}

class TransferInProgressRoute extends GoRouteData {
  const TransferInProgressRoute();

  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) {
    if (!context.read<SessionCubit>().state.isLoggedIn) {
      return const IntroRoute().location;
    }
    return super.redirect(context, state);
  }

  @override
  Widget build(BuildContext context, GoRouterState state) => const IntroPage();
}

class TransferReadyToClaimRoute extends GoRouteData {
  const TransferReadyToClaimRoute();

  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) {
    if (!context.read<SessionCubit>().state.isLoggedIn) {
      return const IntroRoute().location;
    }
    return super.redirect(context, state);
  }

  @override
  Widget build(BuildContext context, GoRouterState state) => const IntroPage();
}

@TypedGoRoute<NetworkListRoute>(path: '/network-list')
class NetworkListRoute extends GoRouteData {
  final ConnectionErrorType? connectionErrorType;

  const NetworkListRoute({this.connectionErrorType});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return NetworkListPage(connectionErrorType: connectionErrorType ?? ConnectionErrorType.canceledByUser);
  }
}

// ---- Dialogs ----

@TypedGoRoute<SignInDrawerRoute>(path: '/sign-in-drawer')
class SignInDrawerRoute extends GoRouteData {
  const SignInDrawerRoute();

  // NOTE: obligated for dialogs: go from navigator key state because of parent ShellRoutes
  static final GlobalKey<NavigatorState> $parentNavigatorKey = navigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return RouterDialogPage(builder: (_) => SignInDrawerPage());
  }
}

@TypedGoRoute<SignInMnemonicDrawerRoute>(path: '/sign-in-mnemonic-drawer')
class SignInMnemonicDrawerRoute extends GoRouteData {
  const SignInMnemonicDrawerRoute();

  // NOTE: obligated for dialogs: go from navigator key state because of parent ShellRoutes
  static final GlobalKey<NavigatorState> $parentNavigatorKey = navigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return RouterDialogPage(builder: (_) => SignInMnemonicDrawerPage());
  }
}

@TypedGoRoute<SignInKeyfileDrawerRoute>(path: '/sign-in-keyfile-drawer')
class SignInKeyfileDrawerRoute extends GoRouteData {
  const SignInKeyfileDrawerRoute();

  // NOTE: obligated for dialogs: go from navigator key state because of parent ShellRoutes
  static final GlobalKey<NavigatorState> $parentNavigatorKey = navigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return RouterDialogPage(builder: (_) => SignInKeyfileDrawerPage());
  }
}

@TypedGoRoute<NetworkDrawerRoute>(path: '/network-drawer')
class NetworkDrawerRoute extends GoRouteData {
  const NetworkDrawerRoute();

  // NOTE: obligated for dialogs: go from navigator key state because of parent ShellRoutes
  static final GlobalKey<NavigatorState> $parentNavigatorKey = navigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return RouterDialogPage(builder: (_) => NetworkDrawerPage());
  }
}
