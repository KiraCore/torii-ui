import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:torii_client/presentation/metamask/cubit/metamask_cubit.dart';
import 'package:torii_client/presentation/session/cubit/session_cubit.dart';
import 'package:torii_client/presentation/widgets/buttons/kira_outlined_button.dart';
import 'package:torii_client/presentation/widgets/dialog_menu/kira_dialog_menu.dart';
import 'package:torii_client/presentation/widgets/dialog_menu/kira_dialog_menu_item.dart';
import 'package:torii_client/utils/exports.dart';
import 'package:url_launcher/url_launcher.dart';

class TransferAppBar extends StatelessWidget {
  const TransferAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return BlocBuilder<SessionCubit, SessionState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('Signed in with:', style: textTheme.bodyMedium),
              const SizedBox(width: 48),
              if (state.kiraWallet != null) ...[
                KiraDialogMenu(
                  popup: KiraDialogMenuItem(
                    title: 'Disconnect',
                    onTap: () {
                      context.read<SessionCubit>().signOutKira();
                    },
                  ),
                  button: Row(
                    children: [
                      SvgPicture.asset('assets/icons/kira_logo.svg', width: 24, height: 24),
                      const SizedBox(width: 8),
                      Text(state.kiraWallet!.address.address),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
              ],
              if (state.ethereumWallet != null)
                KiraDialogMenu(
                  popup: KiraDialogMenuItem(
                    title: 'Disconnect',
                    onTap: () {
                      context.read<SessionCubit>().signOutEthereum();
                    },
                  ),
                  button: Row(
                    children: [
                      SvgPicture.asset('assets/icons/ethereum_logo.svg', width: 24, height: 24),
                      const SizedBox(width: 8),
                      Text(state.ethereumWallet!.address.address),
                    ],
                  ),
                )
              else
                KiraOutlinedButton(
                  onPressed: () {
                    if (context.read<MetamaskCubit>().isSupported) {
                      context.read<MetamaskCubit>().connect();
                    } else {
                      launchUrl(Uri.parse('https://metamask.io/download/'));
                    }
                  },
                  title: 'Connect MetaMask',
                  width: 200,
                  height: 40,
                ),
              if (state.kiraWallet == null) ...[
                const SizedBox(width: 12),
                SvgPicture.asset('assets/icons/kira_logo.svg', width: 24, height: 24),
                const SizedBox(width: 8),
                KiraOutlinedButton(
                  onPressed: () {
                    router.push(SignInDrawerRoute().location);
                  },
                  title: 'Connect KIRA',
                  width: 200,
                  height: 40,
                ),
              ],
              const SizedBox(width: 12),
            ],
          ),
        );
      },
    );
  }
}
