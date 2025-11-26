import 'package:flutter/cupertino.dart';
import 'package:torii_client/domain/models/exports.dart';
import 'package:torii_client/domain/models/messages/tx_msg_type.dart';
import 'package:torii_client/presentation/transfer/send/tx_process_wrapper.dart';
import 'package:torii_client/presentation/transfer/tx_process_cubit/states/tx_process_confirm_state.dart';
import 'package:torii_client/presentation/transfer/tx_process_cubit/states/tx_process_loaded_state.dart';
import 'package:torii_client/presentation/transfer/tx_process_cubit/tx_process_cubit.dart';
import 'package:torii_client/presentation/transfer/tx_send_tokens/tx_send_tokens_confirm_dialog.dart';
import 'package:torii_client/presentation/transfer/tx_send_tokens/tx_send_tokens_form_dialog.dart';

class TxSendTokensPage extends StatefulWidget {
  final TokenAmountModel? balance;
  final Wallet fromWallet;

  TxSendTokensPage({this.balance, required this.fromWallet})
    : super(key: ValueKey(fromWallet.address.address + balance.toString()));

  @override
  State<TxSendTokensPage> createState() => _TxSendTokensPageState();
}

class _TxSendTokensPageState extends State<TxSendTokensPage> {
  late final TxProcessCubit<MsgSendFormModel> txProcessCubit;

  @override
  void initState() {
    super.initState();
    txProcessCubit = TxProcessCubit<MsgSendFormModel>(
      txMsgType: TxMsgType.msgSend,
      msgFormModel: MsgSendFormModel(balance: widget.balance, senderWalletAddress: widget.fromWallet.address),
    )..init(formEnabledBool: true, sendFromKira: widget.fromWallet.isKira);
  }

  @override
  Widget build(BuildContext context) {
    return TxProcessWrapper<MsgSendFormModel>(
      txProcessCubit: txProcessCubit,
      txFormWidgetBuilder: (TxProcessLoadedState txProcessLoadedState) {
        return TxSendTokensFormDialog(
          feeTokenAmountModel: txProcessLoadedState.feeTokenAmountModel,
          sendFromKira: widget.fromWallet.isKira,
        );
      },
      txFormPreviewWidgetBuilder: (TxProcessConfirmState txProcessConfirmState) {
        if (txProcessConfirmState is TxProcessConfirmFromKiraState) {
          return TxSendTokensConfirmDialog(
            txLocalInfoModel: txProcessConfirmState.signedTxModel.txLocalInfoModel,
          );
        } else {
          return TxSendTokensConfirmDialog(txLocalInfoModel: null);
        }
      },
    );
  }
}
