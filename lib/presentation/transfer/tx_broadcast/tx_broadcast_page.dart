import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:torii_client/domain/exports.dart';
import 'package:torii_client/domain/models/tokens/a_msg_form_model.dart';
import 'package:torii_client/domain/models/tokens/list/tx_direction_type.dart';
import 'package:torii_client/domain/models/tokens/list/tx_list_item_model.dart';
import 'package:torii_client/domain/models/tokens/list/tx_status_type.dart';
import 'package:torii_client/domain/models/transaction/signed_transaction_model.dart';
import 'package:torii_client/presentation/global/logs/torii_logs_cubit.dart';
import 'package:torii_client/presentation/transfer/input/cubit/transfer_input_cubit.dart';
import 'package:torii_client/presentation/transfer/tx_broadcast/cubit/a_tx_broadcast_state.dart';
import 'package:torii_client/presentation/transfer/tx_broadcast/cubit/states/tx_broadcast_completed_state.dart';
import 'package:torii_client/presentation/transfer/tx_broadcast/cubit/states/tx_broadcast_error_state.dart';
import 'package:torii_client/presentation/transfer/tx_broadcast/cubit/states/tx_broadcast_loading_state.dart';
import 'package:torii_client/presentation/transfer/tx_broadcast/cubit/tx_broadcast_cubit.dart';
import 'package:torii_client/presentation/transfer/tx_broadcast/widgets/tx_broadcast_error_body.dart';
import 'package:torii_client/presentation/transfer/tx_broadcast/widgets/tx_broadcast_loading_body.dart';
import 'package:torii_client/presentation/transfer/tx_process_cubit/tx_process_cubit.dart';
import 'package:torii_client/presentation/widgets/kira_toast/kira_toast.dart';
import 'package:torii_client/presentation/widgets/kira_toast/toast_type.dart';
import 'package:torii_client/utils/exports.dart';

class TxBroadcastPage<T extends AMsgFormModel> extends StatefulWidget {
  final SignedTxModel? signedTxModel;
  final String? passphrase;

  const TxBroadcastPage({this.signedTxModel, this.passphrase, super.key})
    : assert(
        signedTxModel != null || passphrase != null,
        'Either signedTxModel or passphrase must be provided. Passphrase is required for Ethereum transactions, signedTxModel is required for Kira transactions.',
      );

  @override
  State<StatefulWidget> createState() => _TxBroadcastPage<T>();
}

class _TxBroadcastPage<T extends AMsgFormModel> extends State<TxBroadcastPage<T>> {
  final TxBroadcastCubit txBroadcastCubit = getIt<TxBroadcastCubit>();
  TxProcessCubit<MsgSendFormModel> get txProcessCubit => context.read<TxProcessCubit<MsgSendFormModel>>();

  @override
  void initState() {
    super.initState();
    if (widget.signedTxModel != null) {
      txBroadcastCubit.broadcastFromKira(signedTxModel: widget.signedTxModel!);
    } else if (widget.passphrase != null) {
      txBroadcastCubit.broadcastFromEth(
        passphrase: widget.passphrase!,
        kiraRecipient: txProcessCubit.msgFormModel.recipientWalletAddress!.address,
        ukexAmount: txProcessCubit.msgFormModel.tokenAmountModel!.getAmountInDefaultDenomination(),
      );
    }
  }

  @override
  void dispose() {
    txBroadcastCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TxBroadcastCubit>.value(
      value: txBroadcastCubit,
      child: BlocConsumer<TxBroadcastCubit, ATxBroadcastState>(
        listener: (BuildContext context, ATxBroadcastState txBroadcastState) {
          if (txBroadcastState is TxBroadcastCompletedState) {
            if (txBroadcastState.isEthRecipient) {
              KiraToast.of(context).show(message: 'Wait for transaction in Notifications', type: ToastType.success);
            } else {
              KiraToast.of(context).show(message: 'Transaction is accepted', type: ToastType.success);
            }
            // TODO: refactor routing, make .replace
            context.read<TransferInputCubit>().resetAmounts();
            context.read<TxProcessCubit<MsgSendFormModel>>().init(
              sendFromKira: txBroadcastState.isEthRecipient,
              resetModel: true,
            );
            context.read<ToriiLogsCubit>().reload();
          }
        },
        builder: (BuildContext context, ATxBroadcastState txBroadcastState) {
          return Padding(
            padding: const EdgeInsets.only(top: 48),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _buildTxStatusWidget(txBroadcastState),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTxStatusWidget(ATxBroadcastState txBroadcastState) {
    if (txBroadcastState is TxBroadcastErrorState) {
      return TxBroadcastErrorBody<T>(
        errorExplorerModel: txBroadcastState.errorExplorerModel,
        signedTxModel: widget.signedTxModel,
        passphrase: widget.passphrase,
        kiraRecipient: txProcessCubit.msgFormModel.recipientWalletAddress!.address,
        ukexAmount: txProcessCubit.msgFormModel.tokenAmountModel!.getAmountInDefaultDenomination(),
      );
    } else if (txBroadcastState is TxBroadcastLoadingState || txBroadcastState is TxBroadcastCompletedState) {
      return TxBroadcastLoadingBody();
    } else {
      getIt<Logger>().e('Unexpected ATxBroadcastState state $txBroadcastState');
      return const SizedBox();
    }
  }
}
