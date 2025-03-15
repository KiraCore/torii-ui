import 'package:flutter/material.dart';
import 'package:torii_client/presentation/transfer/tx_broadcast/cubit/states/tx_broadcast_completed_state.dart';
import 'package:torii_client/presentation/transfer/tx_broadcast/widgets/tx_broadcast_status_icon.dart';
import 'package:torii_client/presentation/widgets/buttons/kira_outlined_button.dart';
import 'package:torii_client/utils/exports.dart';

class TxBroadcastCompleteBody extends StatelessWidget {
  final TxBroadcastCompletedState txBroadcastCompletedState;

  const TxBroadcastCompleteBody({required this.txBroadcastCompletedState, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const TxBroadcastStatusIcon(status: true, size: 57),
        const SizedBox(height: 30),
        Text(
          S.of(context).txCompleted,
          textAlign: TextAlign.center,
          style: textTheme.displaySmall!.copyWith(color: DesignColors.white1),
        ),
        const SizedBox(height: 12),
        //todo
        // CopyWrapper(
        //   value: '0x${txBroadcastCompletedState.broadcastRespModel.hash}',
        //   notificationText: S.of(context).txToastHashCopied,
        //   child: Text(
        //     S.of(context).txHash(txBroadcastCompletedState.broadcastRespModel.hash),
        //     textAlign: TextAlign.center,
        //     style: textTheme.bodySmall!.copyWith(color: DesignColors.white1),
        //   ),
        // ),
        const SizedBox(height: 42),
        KiraOutlinedButton(
          height: 51,
          width: 163,
          onPressed: () => _handleBackPressed(context),
          title: S.of(context).txButtonBackToAccount,
        ),
      ],
    );
  }

  void _handleBackPressed(BuildContext context) {
    router.go(const IntroRoute().location);
  }
}
