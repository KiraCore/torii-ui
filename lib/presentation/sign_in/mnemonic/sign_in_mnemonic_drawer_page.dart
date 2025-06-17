import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:torii_client/presentation/global/session/cubit/session_cubit.dart';
import 'package:torii_client/presentation/sign_in/mnemonic/grid/mnemonic_grid_cubit.dart';
import 'package:torii_client/presentation/sign_in/mnemonic/widgets/mnemonic_grid/mnemonic_grid.dart';
import 'package:torii_client/presentation/widgets/buttons/kira_elevated_button.dart';
import 'package:torii_client/presentation/widgets/drawer/drawer_subtitle.dart';
import 'package:torii_client/utils/exports.dart';

class SignInMnemonicDrawerPage extends StatelessWidget {
  const SignInMnemonicDrawerPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool loadingStatusBool = false;
    TextTheme textTheme = Theme.of(context).textTheme;
    Map<MnemonicValidationResult, String> mnemonicErrors = <MnemonicValidationResult, String>{
      // MnemonicValidationResult.invalidChecksum: S.of(context).mnemonicErrorInvalidChecksum,
      // MnemonicValidationResult.invalidMnemonic: S.of(context).mnemonicErrorInvalid,
      // MnemonicValidationResult.mnemonicTooShort: S.of(context).mnemonicErrorTooShort,
    };

    return BlocListener<SessionCubit, SessionState>(
      listener: (BuildContext context, SessionState sessionState) {
        if (sessionState.kiraWallet != null) {
          router.pop(true);
        }
      },
      child: BlocProvider(
        create: (_) => getIt<MnemonicGridCubit>()..init(initialMnemonicGridSize: 24),
        child: Builder(
          builder: (BuildContext context) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                DrawerTitle(
                  title: S.of(context).mnemonicSignIn,
                  subtitle: S.of(context).mnemonicEnter,
                  tooltipMessage: S.of(context).mnemonicLoginHint,
                ),
                const SizedBox(height: 24),
                if (loadingStatusBool)
                  SizedBox(
                    width: double.infinity,
                    height: 450,
                    child: Center(child: Text(S.of(context).connectWalletConnecting)),
                  )
                else
                  MnemonicGrid(),
                const SizedBox(height: 24),
                ValueListenableBuilder<MnemonicValidationResult>(
                  valueListenable: context.read<MnemonicGridCubit>().mnemonicValidationResultNotifier,
                  builder: (_, MnemonicValidationResult mnemonicValidationResult, __) {
                    bool mnemonicValidBool = mnemonicValidationResult != MnemonicValidationResult.success;
                    bool mnemonicCompleteBool = mnemonicValidationResult != MnemonicValidationResult.mnemonicTooShort;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        KiraElevatedButton(
                          onPressed: context.read<MnemonicGridCubit>().signIn,
                          title: S.of(context).connectWalletButtonSignIn,
                          disabled: mnemonicValidationResult != MnemonicValidationResult.success,
                        ),
                        const SizedBox(height: 8),
                        if (mnemonicValidBool && mnemonicCompleteBool)
                          Text(
                            mnemonicErrors[mnemonicValidationResult]!,
                            style: textTheme.bodySmall!.copyWith(color: DesignColors.redStatus1),
                          ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 32),
              ],
            );
          },
        ),
      ),
    );
  }

  // TODO: make as state of Grid cub
  void _setLoadingStatus({required bool loadingStatusBool}) {
    // if (mounted) {
    //   setState(() => this.loadingStatusBool = loadingStatusBool);
    // }
  }
}
