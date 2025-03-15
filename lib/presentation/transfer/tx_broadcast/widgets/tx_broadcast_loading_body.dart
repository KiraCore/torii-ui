import 'package:flutter/material.dart';
import 'package:torii_client/presentation/transfer/tx_broadcast/cubit/states/tx_broadcast_loading_state.dart';
import 'package:torii_client/utils/assets.dart';
import 'package:torii_client/utils/exports.dart';

class TxBroadcastLoadingBody extends StatelessWidget {
  final TxBroadcastLoadingState txBroadcastLoadingState;

  const TxBroadcastLoadingBody({required this.txBroadcastLoadingState, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Image.asset(Assets.assetsLogoLoading, height: 61, width: 61),
        const SizedBox(height: 30),
        Text(
          S.of(context).txIsBeingBroadcast,
          textAlign: TextAlign.center,
          style: textTheme.displaySmall!.copyWith(color: DesignColors.white1),
        ),
        const SizedBox(height: 12),
        Text(
          S.of(context).txWarningDoNotCloseWindow,
          textAlign: TextAlign.center,
          style: textTheme.bodySmall!.copyWith(color: DesignColors.white2),
        ),
      ],
    );
  }
}
