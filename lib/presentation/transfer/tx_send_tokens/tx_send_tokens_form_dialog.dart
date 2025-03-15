import 'package:flutter/material.dart';
import 'package:torii_client/domain/models/tokens/msg_send_form_model.dart';
import 'package:torii_client/domain/models/tokens/token_amount_model.dart';
import 'package:torii_client/domain/models/transaction/signed_transaction_model.dart';
import 'package:torii_client/presentation/transfer/input/msg_send_form/msg_send_form.dart';
import 'package:torii_client/presentation/transfer/send/tx_dialog.dart';
import 'package:torii_client/presentation/transfer/send/tx_send_form_footer.dart';
import 'package:torii_client/presentation/widgets/toggle_between_wallet_address_types.dart';
import 'package:torii_client/utils/exports.dart';

class TxSendTokensFormDialog extends StatefulWidget {
  final MsgSendFormModel msgSendFormModel;
  final TokenAmountModel feeTokenAmountModel;
  final ValueChanged<SignedTxModel> onTxFormCompleted;

  const TxSendTokensFormDialog({
    required this.msgSendFormModel,
    required this.feeTokenAmountModel,
    required this.onTxFormCompleted,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TxSendTokensFormDialog();
}

class _TxSendTokensFormDialog extends State<TxSendTokensFormDialog> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TxDialog(
      title: S.of(context).txSendTokens,
      suffixWidget: const ToggleBetweenWalletAddressTypes(),
      child: Column(
        children: <Widget>[
          MsgSendForm(
            formKey: formKey,
            feeTokenAmountModel: widget.feeTokenAmountModel,
            msgSendFormModel: widget.msgSendFormModel,
          ),
          const SizedBox(height: 30),
          TxSendFormFooter(
            formKey: formKey,
            feeTokenAmountModel: widget.feeTokenAmountModel,
            msgFormModel: widget.msgSendFormModel,
            onSubmit: widget.onTxFormCompleted,
          ),
        ],
      ),
    );
  }
}
