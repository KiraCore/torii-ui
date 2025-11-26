import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:torii_client/domain/exports.dart';
import 'package:torii_client/domain/models/tokens/list/tx_list_item_model.dart';
import 'package:torii_client/main.dart';
import 'package:torii_client/presentation/intro/intro_page.dart';
import 'package:torii_client/presentation/loading/loading_page.dart';
import 'package:torii_client/presentation/network/network_drawer_page/network_drawer_page.dart';
import 'package:torii_client/presentation/global/session/cubit/session_cubit.dart';
import 'package:torii_client/presentation/sign_in/keyfile_dropzone/sign_in_keyfile_drawer_page.dart';
import 'package:torii_client/presentation/sign_in/mnemonic/sign_in_mnemonic_drawer_page.dart';
import 'package:torii_client/presentation/sign_in/sign_in_drawer_page.dart';
import 'package:torii_client/presentation/transaction_list/transaction_details_drawer_page.dart';
import 'package:torii_client/presentation/transaction_list/transactions_page.dart';
import 'package:torii_client/presentation/transfer/claim/claim_drawer_page.dart';
import 'package:torii_client/presentation/transfer/claim/notifications_drawer_page.dart';
import 'package:torii_client/presentation/transfer/claim/transfer_claim_page.dart';
import 'package:torii_client/presentation/transfer/input/transfer_input_page.dart';
import 'package:torii_client/utils/browser/rpc_browser_url_controller.dart';
import 'package:torii_client/utils/exports.dart';
import 'package:torii_client/utils/router/kira_go_router.dart';

import 'router_dialog_page.dart';
part 'router.g.dart';
part 'router_extra_models.dart';

final KiraGoRouter router = KiraGoRouter(
  routes: $appRoutes,
  navigatorKey: navigatorKey,
  debugLogDiagnostics: kDebugMode,
  initialLocation:
      getIt<RpcBrowserUrlController>().getRpcAddress() != null
          ? const LoadingRoute().location
          : const IntroRoute().location,
  // TODO: refactor
  redirect: (context, state) {
    debugPrint('redirecting ${state.fullPath}');
    return null;
  },
);

@TypedGoRoute<LoadingRoute>(path: '/loading')
class LoadingRoute extends GoRouteData {
  const LoadingRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const LoadingPage();
}

@TypedGoRoute<IntroRoute>(path: '/intro')
class IntroRoute extends GoRouteData {
  const IntroRoute();

  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) async {
    if (context.read<SessionCubit>().state.isLoggedIn) {
      return TransferRoute.initialRoute;
    }
    return super.redirect(context, state);
  }

  @override
  Widget build(BuildContext context, GoRouterState state) => const IntroPage();
}

@TypedShellRoute<TransferRoute>(
  routes: <TypedRoute<RouteData>>[
    TypedGoRoute<TransferInputRoute>(
      path: '/',
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<NotificationsDrawerRoute>(path: 'notifications'),
        TypedGoRoute<NotificationDetailsDrawerRoute>(path: 'notifications/:hash'),
      ],
    ),
    // TODO: deprecated. Remove in future.
    // TypedGoRoute<ClaimProgressRoute>(path: '/claim'),
  ],
)
class TransferRoute extends ShellRouteData {
  const TransferRoute();

  static String initialRoute = '/';

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
    // TODO:
    // final pendingSenderTransaction = context.read<ToriiLogsCubit>().state.pendingSenderTransaction;
    // final pendingRecipientTransaction = context.read<ToriiLogsCubit>().state.pendingRecipientTransaction;
    // if (pendingSenderTransaction != null || pendingRecipientTransaction != null) {
    //   return ClaimProgressRoute(
    //     ClaimProgressRouteExtra(
    //       pendingSenderTransaction: pendingSenderTransaction,
    //       pendingRecipientTransaction: pendingRecipientTransaction,
    //       signedTx: null,
    //       msgSendFormModel: null,
    //     ),
    //   ).location;
    // }
    return super.redirect(context, state);
  }

  @override
  Widget build(BuildContext context, GoRouterState state) => const TransferInputPage();
}

@Deprecated('Use ClaimDrawerRoute instead')
class ClaimProgressRoute extends GoRouteData {
  const ClaimProgressRoute(this.$extra);

  final ClaimProgressRouteExtra? $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return TransferClaimPage(
      signedTx: $extra?.signedTx,
      msgSendFormModel: $extra?.msgSendFormModel,
      // TODO: extra is not saved during redirect due to issue  https://github.com/flutter/flutter/issues/146616
      pendingSenderTransaction:
          $extra?.pendingSenderTransaction, // ?? context.read<ToriiLogsCubit>().state.pendingSenderTransaction,
      pendingRecipientTransaction:
          $extra?.pendingRecipientTransaction, // ?? context.read<ToriiLogsCubit>().state.pendingRecipientTransaction,
    );
  }
}

@TypedGoRoute<TransactionListRoute>(path: '/transactions')
class TransactionListRoute extends GoRouteData {
  const TransactionListRoute({required this.forKira});

  final bool forKira;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return TransactionsPage(forKira: forKira);
  }
}

// ---- Dialogs ----

@TypedGoRoute<SignInDrawerRoute>(path: '/sign-in')
class SignInDrawerRoute extends GoRouteData {
  const SignInDrawerRoute();

  // NOTE: obligated for dialogs: go from navigator key state because of parent ShellRoutes
  static final GlobalKey<NavigatorState> $parentNavigatorKey = navigatorKey;

  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) {
    if (!kiraEthEnabled) {
      return TransferRoute.initialRoute;
    }
    return super.redirect(context, state);
  }

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return RouterDialogPage(builder: (_) => SignInDrawerPage());
  }
}

@TypedGoRoute<SignInMnemonicDrawerRoute>(path: '/sign-in-mnemonic')
class SignInMnemonicDrawerRoute extends GoRouteData {
  const SignInMnemonicDrawerRoute();

  // NOTE: obligated for dialogs: go from navigator key state because of parent ShellRoutes
  static final GlobalKey<NavigatorState> $parentNavigatorKey = navigatorKey;

  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) {
    if (!kiraEthEnabled) {
      return TransferRoute.initialRoute;
    }
    return super.redirect(context, state);
  }

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return RouterDialogPage(builder: (_) => SignInMnemonicDrawerPage());
  }
}

@TypedGoRoute<SignInKeyfileDrawerRoute>(path: '/sign-in-keyfile')
class SignInKeyfileDrawerRoute extends GoRouteData {
  const SignInKeyfileDrawerRoute();

  // NOTE: obligated for dialogs: go from navigator key state because of parent ShellRoutes
  static final GlobalKey<NavigatorState> $parentNavigatorKey = navigatorKey;

  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) {
    if (!kiraEthEnabled) {
      return TransferRoute.initialRoute;
    }
    return super.redirect(context, state);
  }

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return RouterDialogPage(builder: (_) => SignInKeyfileDrawerPage());
  }
}

@TypedGoRoute<NetworkDrawerRoute>(path: '/network')
class NetworkDrawerRoute extends GoRouteData {
  const NetworkDrawerRoute();

  // NOTE: obligated for dialogs: go from navigator key state because of parent ShellRoutes
  static final GlobalKey<NavigatorState> $parentNavigatorKey = navigatorKey;

  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) {
    if (!kiraEthEnabled) {
      return TransferRoute.initialRoute;
    }
    return super.redirect(context, state);
  }

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return RouterDialogPage(builder: (_) => NetworkDrawerPage());
  }
}

@TypedGoRoute<TransactionDetailsDrawerRoute>(path: '/transactions/:id')
class TransactionDetailsDrawerRoute extends GoRouteData {
  const TransactionDetailsDrawerRoute(this.$extra, {required this.id});

  final String id;
  final TxListItemModel? $extra;

  // NOTE: obligated for dialogs: go from navigator key state because of parent ShellRoutes
  static final GlobalKey<NavigatorState> $parentNavigatorKey = navigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return RouterDialogPage(builder: (_) => TransactionDetailsDrawerPage(txListItemModel: $extra!));
  }
}

class NotificationsDrawerRoute extends GoRouteData {
  const NotificationsDrawerRoute();

  // NOTE: obligated for dialogs: go from navigator key state because of parent ShellRoutes
  static final GlobalKey<NavigatorState> $parentNavigatorKey = navigatorKey;

  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) {
    if (!kiraEthEnabled || !context.read<SessionCubit>().state.isEthereumLoggedIn) {
      return TransferRoute.initialRoute;
    }
    return super.redirect(context, state);
  }

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return RouterDialogPage(padding: EdgeInsets.zero, builder: (_) => NotificationsDrawerPage());
  }
}

class NotificationDetailsDrawerRoute extends GoRouteData {
  const NotificationDetailsDrawerRoute({required this.hash});

  final String hash;

  // NOTE: obligated for dialogs: go from navigator key state because of parent ShellRoutes
  static final GlobalKey<NavigatorState> $parentNavigatorKey = navigatorKey;

  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) {
    if (!kiraEthEnabled || !context.read<SessionCubit>().state.isEthereumLoggedIn) {
      return TransferRoute.initialRoute;
    }
    return super.redirect(context, state);
  }

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return RouterDialogPage(
      padding: EdgeInsets.zero,
      builder: (_) => NotificationsDrawerPage(hash: hash.trim().isEmpty ? null : hash),
    );
  }
}

@TypedGoRoute<ClaimDrawerRoute>(path: '/claim')
class ClaimDrawerRoute extends GoRouteData {
  const ClaimDrawerRoute(this.$extra);

  final TxListItemModel? $extra;

  // NOTE: obligated for dialogs: go from navigator key state because of parent ShellRoutes
  static final GlobalKey<NavigatorState> $parentNavigatorKey = navigatorKey;

  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) {
    if (!kiraEthEnabled && !context.read<SessionCubit>().state.isEthereumLoggedIn) {
      return TransferRoute.initialRoute;
    }
    return super.redirect(context, state);
  }

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return RouterDialogPage(padding: EdgeInsets.zero, builder: (_) => ClaimDrawerPage(pendingTransaction: $extra!));
  }
}
