import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:torii_client/presentation/session/cubit/session_cubit.dart';
import 'package:torii_client/presentation/widgets/buttons/kira_elevated_button.dart';
import 'package:torii_client/presentation/widgets/drawer/drawer_subtitle.dart';
import 'package:torii_client/utils/exports.dart';

class SignInDrawerPage extends StatelessWidget {
  const SignInDrawerPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool disabledBool = false; //signInDrawerPageState.disabledBool;
    bool loadingBool = false; //signInDrawerPageState.refreshingBool || metamaskState.isLoadingBool;

    TextTheme textTheme = Theme.of(context).textTheme;
    return BlocListener<SessionCubit, SessionState>(
      listener: (BuildContext context, SessionState state) {
        if (state.kiraWallet != null) {
          router.pop();
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          DrawerTitle(
            title: S.of(context).connectWallet,
            subtitle: disabledBool ? S.of(context).connectWalletWarning : S.of(context).connectWalletOptions,
            subtitleColor: disabledBool ? DesignColors.yellowStatus1 : DesignColors.accent,
          ),
          const SizedBox(height: 32),
          KiraElevatedButton(
            title: S.of(context).keyfile,
            disabled: disabledBool || loadingBool,
            onPressed: () {
              router.push(SignInKeyfileDrawerRoute().location);
            },
          ),
          const SizedBox(height: 16),
          KiraElevatedButton(
            title: S.of(context).mnemonic,
            disabled: disabledBool || loadingBool,
            onPressed: () {
              router.push(SignInMnemonicDrawerRoute().location);
            },
          ),
          const SizedBox(height: 32),
          Text(
            'Do not have a wallet?\nCreate one using MIRO app.',
            style: textTheme.bodyMedium!.copyWith(
              color: disabledBool || loadingBool ? DesignColors.grey2 : DesignColors.white1,
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
