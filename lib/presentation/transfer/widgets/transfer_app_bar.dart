import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:torii_client/presentation/metamask/cubit/metamask_cubit.dart';
import 'package:torii_client/presentation/network/network_drawer_page/current_network_button.dart';
import 'package:torii_client/presentation/session/cubit/session_cubit.dart';
import 'package:torii_client/presentation/widgets/exports.dart';
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
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
          child: Align(
            alignment: Alignment.centerRight,
            child: Wrap(
              alignment: WrapAlignment.end,
              crossAxisAlignment: WrapCrossAlignment.center,
              runSpacing: 8,
              children: [
                CurrentNetworkButton(),
                const SizedBox(width: 24),
                Text(
                  'Signed in with:',
                  style: textTheme.bodySmall?.copyWith(leadingDistribution: TextLeadingDistribution.even),
                ),
                const SizedBox(width: 12),
                if (state.kiraWallet != null) ...[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      KiraDialogMenu(
                        key: const ValueKey('kira-dialog-menu'),
                        popupWidth: 170,
                        popupItems: [
                          KiraDialogMenuItem(
                            title: 'Disconnect',
                            onTap: () {
                              context.read<SessionCubit>().signOutKira();
                            },
                          ),
                        ],
                        button: KiraToolTip(
                          childMargin: EdgeInsets.zero,
                          message: state.kiraWallet!.address.address,
                          child: Row(
                            children: [
                              SvgPicture.asset('assets/icons/kira_logo.svg', width: 24, height: 24),
                              const SizedBox(width: 8),
                              Text(
                                state.kiraWallet!.address.address.toShortenedAddress(),
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.bodyMedium!.copyWith(color: DesignColors.white2),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 2),
                      CopyButton(
                        value: state.kiraWallet!.address.address,
                        notificationText: S.of(context).toastHashCopied,
                      ),
                    ],
                  ),
                  const SizedBox(width: 18),
                ],
                if (state.ethereumWallet != null)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      KiraDialogMenu(
                        key: const ValueKey('eth-dialog-menu'),
                        popupWidth: 170,
                        popupItems: [
                          KiraDialogMenuItem(
                            title: 'Disconnect',
                            onTap: () {
                              context.read<SessionCubit>().signOutEthereum();
                            },
                          ),
                        ],
                        button: KiraToolTip(
                          childMargin: EdgeInsets.zero,
                          message: state.ethereumWallet!.address.address,
                          child: Row(
                            children: [
                              SvgPicture.asset('assets/icons/ethereum_logo.svg', width: 24, height: 24),
                              const SizedBox(width: 8),
                              Text(
                                state.ethereumWallet!.address.address.toShortenedAddress(),
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.bodyMedium!.copyWith(color: DesignColors.white2),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 2),
                      CopyButton(
                        value: state.ethereumWallet!.address.address,
                        notificationText: S.of(context).toastHashCopied,
                      ),
                    ],
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
                  const SizedBox(width: 18),
                  KiraOutlinedButton(
                    onPressed: () {
                      router.push(SignInDrawerRoute().location);
                    },
                    title: 'Connect KIRA',
                    width: 200,
                    height: 40,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
