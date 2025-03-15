import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:torii_client/presentation/session/cubit/session_cubit.dart';
import 'package:torii_client/utils/assets.dart';
import 'package:torii_client/utils/exports.dart';

/// Toggle between ETH and KIRA addresses
class ToggleBetweenWalletAddressTypes extends StatelessWidget {
  const ToggleBetweenWalletAddressTypes({super.key, this.padding});

  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    SessionCubit sessionCubit = getIt<SessionCubit>();
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: BlocBuilder<SessionCubit, SessionState>(
        bloc: sessionCubit,
        // TODO(Mykyta): add buildWhen once option will be in the state
        // buildWhen: (Wallet? previous, Wallet? current) => previous.option != current.option,
        builder: (BuildContext context, SessionState state) {
          if (!sessionCubit.state.isEthereumLoggedIn) {
            return const SizedBox.shrink();
          }
          return InkWell(
            onTap: () {
              // sessionCubit.toggleWalletAddress();
            },
            child: Container(
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
                  BlocBuilder<SessionCubit, SessionState>(
                    buildWhen:
                        (SessionState previous, SessionState current) =>
                            previous.kiraWallet?.isEthereum != current.kiraWallet?.isEthereum,
                    builder: (BuildContext context, SessionState state) {
                      if (state.kiraWallet == null) {
                        return const SizedBox(width: 24);
                      }
                      String asset = state.kiraWallet!.isEthereum ? Assets.kiraLogo : Assets.ethereumLogo;
                      return SizedBox(
                        width: 24,
                        height: 24,
                        child: SvgPicture.asset(
                          asset,
                          colorFilter: const ColorFilter.mode(DesignColors.white1, BlendMode.srcIn),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
