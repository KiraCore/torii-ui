import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:torii_client/presentation/metamask/cubit/metamask_cubit.dart';
import 'package:torii_client/presentation/network/bloc/network_module_bloc.dart';
import 'package:torii_client/presentation/session/cubit/session_cubit.dart';
import 'package:torii_client/utils/exports.dart';

class ToriiApp extends StatelessWidget {
  const ToriiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (BuildContext context) => S.of(context).torii,
      // TODO:
      theme: ThemeConfig.buildTheme(isSmallScreen: false),
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      routerConfig: router,
      builder: (BuildContext context, Widget? navigator) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => getIt<SessionCubit>()),
            BlocProvider(create: (_) => getIt<MetamaskCubit>()),
            BlocProvider(create: (_) => getIt<NetworkModuleBloc>()),
          ],
          child: BlocListener<SessionCubit, SessionState>(
            listenWhen:
                (previous, current) =>
                    previous.isKiraLoggedIn != current.isKiraLoggedIn ||
                    previous.isEthereumLoggedIn != current.isEthereumLoggedIn,
            listener: (context, state) {
              // NOTE: we shouldn't need to refresh the router if the current 2 routes are dialogs because the dialog is already working on closing itself, and refresh will cause a conflict
              if (router.isPreviousRouteDialog()) {
                return;
              }
              router.refresh();
            },
            child: navigator!,
                
          ),
        );
      },
    );
  }
}
