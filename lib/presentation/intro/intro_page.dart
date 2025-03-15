import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:torii_client/domain/exports.dart';
import 'package:torii_client/presentation/metamask/cubit/metamask_cubit.dart';
import 'package:torii_client/presentation/widgets/buttons/kira_outlined_button.dart';
import 'package:torii_client/utils/exports.dart';
import 'package:torii_client/utils/router/router.dart';
import 'package:url_launcher/url_launcher.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    // TODO: move this somewhere else
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getIt<KeyValueRepository>().setIntroShown();
    });

    double width = 300;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 600,
            child: Column(
              children: [
                SelectableText('Welcome to TORII', style: textTheme.titleLarge),
                SelectableText(
                  '\n\nThis app allows you to securely sign and process transactions between ERC20 and Kira Chain networks using MetaMask via Ethereum Threshold Signing.'
                  '\n\nTo get started, please connect your MetaMask or/and KIRA wallet.'
                  '\nOnce connected, you can initiate transactions, track their progress, and claim approved transactions after confirmation.',
                  style: textTheme.titleMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 70),
          Row(
            children: [
              const Spacer(flex: 2),
              SizedBox(width: width, child: Text('Kira:', textAlign: TextAlign.center, style: textTheme.titleSmall)),
              const Spacer(flex: 1),
              SizedBox(
                width: width,
                child: Text('Ethereum:', textAlign: TextAlign.center, style: textTheme.titleSmall),
              ),
              const Spacer(flex: 2),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              const Spacer(flex: 2),
              Column(
                children: [
                  KiraOutlinedButton(
                    width: width,
                    onPressed: () {
                      router.push(SignInKeyfileDrawerRoute().location);
                    },
                    title: S.of(context).keyfile,
                  ),
                  const SizedBox(height: 10),
                  KiraOutlinedButton(
                    width: width,
                    onPressed: () {
                      router.push(SignInMnemonicDrawerRoute().location);
                    },
                    title: S.of(context).mnemonic,
                  ),
                ],
              ),
              const Spacer(flex: 1),
              BlocBuilder<MetamaskCubit, MetamaskState>(
                builder: (context, state) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (context.read<MetamaskCubit>().isSupported)
                        KiraOutlinedButton(
                          width: width,
                          onPressed: () {
                            context.read<MetamaskCubit>().connect();
                          },
                          title: S.of(context).metamask,
                        )
                      else
                        KiraOutlinedButton(
                          width: width,
                          onPressed: () {
                            launchUrl(Uri.parse('https://metamask.io/download/'));
                          },
                          title: 'Install MetaMask',
                        ),
                      const SizedBox(height: 51 + 10),
                    ],
                  );
                },
              ),
              const Spacer(flex: 2),
            ],
          ),
          const SizedBox(height: 30),
          KiraOutlinedButton(
            width: width * 2 + 20, // Width of two buttons plus spacing
            onPressed: () {
              router.go(NetworkListRoute().location);
            },
            title: 'Network Settings',
          ),
        ],
      ),
    );
  }
}
