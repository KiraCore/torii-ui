import 'package:flutter/cupertino.dart';
import 'package:torii_client/domain/models/tokens/msg_send_form_model.dart';
import 'package:torii_client/domain/models/transaction/tx_local_info_model.dart';
import 'package:torii_client/presentation/transfer/input/msg_send_form/msg_send_form_preview.dart';
import 'package:torii_client/presentation/transfer/send/tx_dialog_confirm_layout.dart';

class TxSendTokensConfirmDialog extends StatelessWidget {
  final MsgSendFormModel msgSendFormModel;
  final TxLocalInfoModel? txLocalInfoModel;

  const TxSendTokensConfirmDialog({required this.msgSendFormModel, required this.txLocalInfoModel, Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TxDialogConfirmLayout<MsgSendFormModel>(
      formPreviewWidget: MsgSendFormPreview(msgSendFormModel: msgSendFormModel, txLocalInfoModel: txLocalInfoModel),
    );
  }
}
