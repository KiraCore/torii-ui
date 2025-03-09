import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:torii_client/presentation/intro/intro_page.dart';
import 'package:torii_client/presentation/sign_in/keyfile_dropzone/sign_in_keyfile_drawer_page.dart';
import 'package:torii_client/presentation/sign_in/mnemonic/sign_in_mnemonic_drawer_page.dart';
import 'package:torii_client/presentation/sign_in/sign_in_drawer_page.dart';
import 'package:torii_client/utils/exports.dart';

import 'router_dialog_page.dart';
part 'router.g.dart';

final GoRouter router = GoRouter(
  routes: $appRoutes,
  navigatorKey: navigatorKey,
  debugLogDiagnostics: kDebugMode,
  initialLocation: const IntroRoute().location,
);

@TypedGoRoute<IntroRoute>(path: '/intro')
class IntroRoute extends GoRouteData {
  const IntroRoute();

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
  Widget build(BuildContext context, GoRouterState state) => const IntroPage();
}

class TransferInProgressRoute extends GoRouteData {
  const TransferInProgressRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const IntroPage();
}

class TransferReadyToClaimRoute extends GoRouteData {
  const TransferReadyToClaimRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const IntroPage();
}

// ---- Dialogs ----

// TODO: try mnemonic and keyfile as shell routes
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
