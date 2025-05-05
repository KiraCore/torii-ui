import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:torii_client/domain/models/tokens/msg_send_form_model.dart';
import 'package:torii_client/domain/models/tokens/token_amount_model.dart';
import 'package:torii_client/domain/models/transaction/signed_transaction_model.dart';
import 'package:torii_client/presentation/transfer/input/msg_send_form/msg_send_form.dart';
import 'package:torii_client/presentation/transfer/send/tx_dialog.dart';
import 'package:torii_client/presentation/transfer/send/tx_send_form_footer.dart';
import 'package:torii_client/presentation/transfer/tx_form_builder_cubit/tx_form_builder_cubit.dart';
import 'package:torii_client/presentation/transfer/tx_process_cubit/tx_process_cubit.dart';
import 'package:torii_client/presentation/transfer/widgets/toggle_between_wallet_address_types.dart';

class TxSendTokensFormDialog extends StatefulWidget {
  final TokenAmountModel feeTokenAmountModel;
  final bool sendFromKira;

  const TxSendTokensFormDialog({
    required this.feeTokenAmountModel,
    required this.sendFromKira,
    super.key,
  });

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
      title: 'Cross-chain Transfer',
      child: Column(
        children: <Widget>[
          MsgSendForm(
            formKey: formKey,
            feeTokenAmountModel: widget.feeTokenAmountModel,
          ),
          const SizedBox(height: 30),
          BlocProvider<TxFormBuilderCubit>(
            create:
                (BuildContext context) => TxFormBuilderCubit(
                  feeTokenAmountModel: widget.feeTokenAmountModel,
                  msgFormModel: context.read<TxProcessCubit<MsgSendFormModel>>().msgFormModel,
                ),
            child: TxSendFormFooter(
              formKey: formKey,
              feeTokenAmountModel: widget.feeTokenAmountModel,
            ),
          ),
        ],
      ),
    );
  }
}
