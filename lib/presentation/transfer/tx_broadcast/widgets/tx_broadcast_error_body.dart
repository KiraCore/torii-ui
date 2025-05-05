import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:torii_client/domain/exports.dart';
import 'package:torii_client/domain/models/network/error_explorer_model.dart';
import 'package:torii_client/domain/models/tokens/a_msg_form_model.dart';
import 'package:torii_client/domain/models/tokens/msg_send_form_model.dart';
import 'package:torii_client/domain/models/transaction/signed_transaction_model.dart';
import 'package:torii_client/presentation/transfer/error_explorer_dialog/error_explorer_dialog.dart';
import 'package:torii_client/presentation/transfer/tx_broadcast/cubit/tx_broadcast_cubit.dart';
import 'package:torii_client/presentation/transfer/tx_broadcast/widgets/tx_broadcast_status_icon.dart';
import 'package:torii_client/presentation/transfer/tx_process_cubit/tx_process_cubit.dart';
import 'package:torii_client/presentation/widgets/exports.dart';
import 'package:torii_client/utils/exports.dart';

class TxBroadcastErrorBody<T extends AMsgFormModel> extends StatelessWidget {
  final ErrorExplorerModel errorExplorerModel;
  final SignedTxModel? signedTxModel;
  final String? passphrase;
  final String kiraRecipient;
  final Decimal ukexAmount;

  const TxBroadcastErrorBody({
    required this.errorExplorerModel,
    required this.signedTxModel,
    required this.passphrase,
    required this.kiraRecipient,
    required this.ukexAmount,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const TxBroadcastStatusIcon(status: false, size: 57),
        const SizedBox(height: 30),
        Text(
          S.of(context).txErrorFailed,
          textAlign: TextAlign.center,
          style: textTheme.displaySmall!.copyWith(color: DesignColors.white1),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('<${errorExplorerModel.code}>', style: textTheme.bodySmall!.copyWith(color: DesignColors.white1)),
            const SizedBox(width: 8),
            TextLink(
              textStyle: textTheme.bodySmall!.copyWith(color: DesignColors.white1),
              onTap: () => _showErrorExplorerDialog(context),
              text: S.of(context).txErrorSeeMore,
            ),
          ],
        ),
        const SizedBox(height: 42),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            KiraOutlinedButton(
              height: 51,
              width: 163,
              onPressed: () => _pressEditTransactionButton(context),
              title: S.of(context).txButtonEditTransaction,
            ),
            const SizedBox(height: 8),
            KiraOutlinedButton(
              height: 51,
              width: 163,
              onPressed: () => _pressTryAgainButton(context),
              title: S.of(context).txTryAgain,
            ),
          ],
        ),
      ],
    );
  }

  void _showErrorExplorerDialog(BuildContext context) {
    showDialog<void>(context: context, builder: (_) => ErrorExplorerDialog(errorExplorerModel: errorExplorerModel));
  }

  void _pressTryAgainButton(BuildContext context) {
    if (signedTxModel != null) {
      context.read<TxBroadcastCubit>().broadcastFromKira(signedTxModel: signedTxModel!);
    } else if (passphrase != null) {
      context.read<TxBroadcastCubit>().broadcastFromEth(
        passphrase: passphrase!,
        kiraRecipient: kiraRecipient,
        ukexAmount: ukexAmount,
      );
    }
  }

  void _pressEditTransactionButton(BuildContext context) {
    BlocProvider.of<TxProcessCubit<T>>(context).editTransactionForm();
  }
}
