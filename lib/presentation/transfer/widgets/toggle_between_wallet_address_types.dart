import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:torii_client/presentation/global/session/cubit/session_cubit.dart';
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
              String fromAsset = state.fromWallet.isKira ? Assets.kiraLogo : Assets.ethereumLogo;
              String toAsset = state.fromWallet.isKira ? Assets.ethereumLogo : Assets.kiraLogo;
              final widget =
              // Container(
              //   // height: 48,
              //   padding: const EdgeInsets.symmetric(horizontal: 10),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: <Widget>[
              // Column(
              //   children: <Widget>[
              //     SizedBox(
              //       width: 24,
              //       height: 24,
              //       child: SvgPicture.asset(
              //         fromAsset,
              //         colorFilter: const ColorFilter.mode(DesignColors.white1, BlendMode.srcIn),
              //       ),
              //     ),
              //     const SizedBox(height: 12),
              //     SizedBox(
              //       width: 24,
              //       height: 24,
              //       child: SvgPicture.asset(
              //         toAsset,
              //         colorFilter: const ColorFilter.mode(DesignColors.white1, BlendMode.srcIn),
              //       ),
              //     ),
              //   ],
              // ),
              // const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: DesignColors.background, borderRadius: BorderRadius.circular(12)),
                child: Icon(
                  Icons.arrow_downward_rounded,
                  color:
                      !sessionState.isEthereumLoggedIn || !sessionState.isKiraLoggedIn
                          ? DesignColors.greenStatus2
                          : DesignColors.greenStatus1,
                  size: 36,
                ),
                //     ),
                //   ],
                // ),
              );

              if (!sessionState.isEthereumLoggedIn || !sessionState.isKiraLoggedIn) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: KiraToolTip(
                    childMargin: EdgeInsets.zero,
                    message:
                        sessionState.isEthereumLoggedIn
                            ? 'You are not logged in to KIRA'
                            : 'You are not logged in to Ethereum',
                    child: widget,
                  ),
                );
              }
              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: () {
                    context.read<TransferInputCubit>().toggleFromWallet();
                  },
                  child: widget,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
