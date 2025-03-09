import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:torii_client/presentation/metamask/cubit/metamask_cubit.dart';
import 'package:torii_client/presentation/session/cubit/session_cubit.dart';
import 'package:torii_client/utils/exports.dart';

class ToriiApp extends StatelessWidget {
  const ToriiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
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
        return ConstrainedBox(
          // TODO: make mobile responsive
          constraints: BoxConstraints(minWidth: 700),
          child: MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => getIt<SessionCubit>()),
              BlocProvider(create: (_) => getIt<MetamaskCubit>()),
            ],
            child: navigator!,
          ),
        );
      },
    );
  }
}
