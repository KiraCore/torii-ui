import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:torii_client/domain/models/exports.dart';
import 'package:torii_client/domain/models/messages/tx_msg_type.dart';
import 'package:torii_client/domain/models/transaction/signed_transaction_model.dart';
import 'package:torii_client/presentation/transfer/send/tx_process_wrapper.dart';
import 'package:torii_client/presentation/transfer/tx_process_cubit/states/tx_process_confirm_state.dart';
import 'package:torii_client/presentation/transfer/tx_process_cubit/states/tx_process_loaded_state.dart';
import 'package:torii_client/presentation/transfer/tx_process_cubit/tx_process_cubit.dart';
import 'package:torii_client/presentation/transfer/tx_send_tokens/tx_send_tokens_confirm_dialog.dart';
import 'package:torii_client/presentation/transfer/tx_send_tokens/tx_send_tokens_form_dialog.dart';
import 'package:torii_client/presentation/transfer/widgets/request_passphrase_dialog.dart';

class TxSendTokensPage extends StatelessWidget {
  final TokenAmountModel? balance;
  final Wallet fromWallet;

  TxSendTokensPage({this.balance, required this.fromWallet})
    : super(key: ValueKey(fromWallet.address.address + balance.toString()));
    
  @override
  Widget build(BuildContext context) {
    final TxProcessCubit<MsgSendFormModel> txProcessCubit = TxProcessCubit<MsgSendFormModel>(
      txMsgType: TxMsgType.msgSend,
      msgFormModel: MsgSendFormModel(balance: balance, senderWalletAddress: fromWallet.address),
    )..init(formEnabledBool: true, sendFromKira: fromWallet.isKira);

    return TxProcessWrapper<MsgSendFormModel>(
      txProcessCubit: txProcessCubit,
      txFormWidgetBuilder: (TxProcessLoadedState txProcessLoadedState) {
        return TxSendTokensFormDialog(
          feeTokenAmountModel: txProcessLoadedState.feeTokenAmountModel,
          sendFromKira: fromWallet.isKira,
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
