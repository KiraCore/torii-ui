import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:torii_client/presentation/session/cubit/session_cubit.dart';
import 'package:torii_client/presentation/transfer/input/cubit/transfer_input_cubit.dart';
import 'package:torii_client/presentation/widgets/kira_tooltip.dart';
import 'package:torii_client/utils/assets.dart';
import 'package:torii_client/utils/exports.dart';

/// Toggle between ETH and KIRA addresses
class ToggleBetweenWalletAddressTypes extends StatelessWidget {
  const ToggleBetweenWalletAddressTypes({super.key, this.padding});

  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: BlocBuilder<SessionCubit, SessionState>(
        builder: (BuildContext context, SessionState sessionState) {
          return BlocBuilder<TransferInputCubit, TransferInputState>(
            builder: (BuildContext context, TransferInputState state) {
              String asset = state.fromWallet.isKira ? Assets.ethereumLogo : Assets.kiraLogo;
              final widget = Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: SvgPicture.asset(
                        Assets.arrows,
                        colorFilter: const ColorFilter.mode(DesignColors.white1, BlendMode.srcIn),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: SvgPicture.asset(
                        asset,
                        colorFilter: const ColorFilter.mode(DesignColors.white1, BlendMode.srcIn),
                      ),
                    ),
                  ],
                ),
              );

              if (!sessionState.isEthereumLoggedIn || !sessionState.isKiraLoggedIn) {
                return KiraToolTip(
                  childMargin: EdgeInsets.zero,
                  message:
                      sessionState.isEthereumLoggedIn
                          ? 'You are not logged in to KIRA'
                          : 'You are not logged in to Ethereum',
                  child: widget,
                );
              }
              return InkWell(
                onTap: () {
                  context.read<TransferInputCubit>().toggleFromWallet();
                },
                child: widget,
              );
            },
          );
        },
      ),
    );
  }
}
