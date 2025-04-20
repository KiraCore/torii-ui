import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:torii_client/presentation/widgets/buttons/kira_elevated_button.dart';
import 'package:torii_client/presentation/widgets/drawer/drawer_subtitle.dart';
import 'package:torii_client/utils/exports.dart';
import 'package:url_launcher/url_launcher.dart';

class SignInDrawerPage extends StatelessWidget {
  const SignInDrawerPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool disabledBool = false; //signInDrawerPageState.disabledBool;
    bool loadingBool = false; //signInDrawerPageState.refreshingBool || metamaskState.isLoadingBool;

    TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
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
          onPressed: () async {
            final result = await router.push<bool>(SignInKeyfileDrawerRoute().location);
            if (result == true) {
              // NOTE: we need to delay the pop to ensure the previous dialog is closed
              await Future.delayed(Duration.zero);
              router.pop();
            }
          },
        ),
        const SizedBox(height: 16),
        KiraElevatedButton(
          title: S.of(context).mnemonic,
          disabled: disabledBool || loadingBool,
          onPressed: () async {
            final result = await router.push<bool>(SignInMnemonicDrawerRoute().location);
            if (result == true) {
              // NOTE: we need to delay the pop to ensure the previous dialog is closed
              await Future.delayed(Duration.zero);
              router.pop();
            }
          },
        ),
        const SizedBox(height: 32),
        Text('Do not have a wallet?', style: textTheme.bodyMedium),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(text: 'Create one using ', style: textTheme.bodyMedium),
              TextSpan(
                text: 'MIRO app',
                style: textTheme.bodyMedium!.copyWith(color: DesignColors.hyperlink),
                recognizer:
                    TapGestureRecognizer()
                      ..onTap = () {
                        launchUrl(Uri.parse('https://github.com/KiraCore/miro/releases'));
                      },
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
