import 'package:flutter/cupertino.dart';
import 'package:torii_client/domain/models/exports.dart';
import 'package:torii_client/domain/models/messages/tx_msg_type.dart';
import 'package:torii_client/presentation/session/cubit/session_cubit.dart';
import 'package:torii_client/presentation/transfer/send/tx_process_wrapper.dart';
import 'package:torii_client/presentation/transfer/tx_process_cubit/states/tx_process_confirm_state.dart';
import 'package:torii_client/presentation/transfer/tx_process_cubit/states/tx_process_loaded_state.dart';
import 'package:torii_client/presentation/transfer/tx_process_cubit/tx_process_cubit.dart';
import 'package:torii_client/presentation/transfer/tx_send_tokens/tx_send_tokens_confirm_dialog.dart';
import 'package:torii_client/presentation/transfer/tx_send_tokens/tx_send_tokens_form_dialog.dart';
import 'package:torii_client/utils/exports.dart';

class TxSendTokensPage extends StatefulWidget {
  final TokenAmountModel? balance;

  const TxSendTokensPage({this.balance, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TxSendTokensPage();
}

class _TxSendTokensPage extends State<TxSendTokensPage> {
  final SessionCubit sessionCubit = getIt<SessionCubit>();
  late final TxProcessCubit<MsgSendFormModel> txProcessCubit = TxProcessCubit<MsgSendFormModel>(
    txMsgType: TxMsgType.msgSend,
    msgFormModel: MsgSendFormModel(
      balance: widget.balance,
      senderWalletAddress: sessionCubit.state.kiraWallet!.address,
    ),
  );

  @override
  void dispose() {
    txProcessCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TxProcessWrapper<MsgSendFormModel>(
      txProcessCubit: txProcessCubit,
      txFormWidgetBuilder: (TxProcessLoadedState txProcessLoadedState) {
        return TxSendTokensFormDialog(
          feeTokenAmountModel: txProcessLoadedState.feeTokenAmountModel,
          onTxFormCompleted: txProcessCubit.submitTransactionForm,
          msgSendFormModel: txProcessCubit.msgFormModel,
        );
      },
      txFormPreviewWidgetBuilder: (TxProcessConfirmState txProcessConfirmState) {
        return TxSendTokensConfirmDialog(
          msgSendFormModel: txProcessCubit.msgFormModel,
          txLocalInfoModel: txProcessConfirmState.signedTxModel.txLocalInfoModel,
        );
      },
    );
  }
}
