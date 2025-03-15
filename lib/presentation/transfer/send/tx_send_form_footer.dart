import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:torii_client/domain/exports.dart';
import 'package:torii_client/domain/models/messages/msg_send_model.dart';
import 'package:torii_client/domain/models/transaction/signed_transaction_model.dart';
import 'package:torii_client/domain/models/transaction/unsigned_tx_model.dart';
import 'package:torii_client/presentation/metamask/cubit/metamask_cubit.dart';
import 'package:torii_client/presentation/session/cubit/session_cubit.dart';
import 'package:torii_client/presentation/transfer/send/tx_send_form_completing_indicator.dart';
import 'package:torii_client/presentation/transfer/send/tx_send_form_next_button.dart';
import 'package:torii_client/presentation/transfer/tx_form_builder_cubit/a_tx_form_builder_state.dart';
import 'package:torii_client/presentation/transfer/tx_form_builder_cubit/states/tx_form_builder_downloading_state.dart';
import 'package:torii_client/presentation/transfer/tx_form_builder_cubit/states/tx_form_builder_error_state.dart';
import 'package:torii_client/presentation/transfer/tx_form_builder_cubit/tx_form_builder_cubit.dart';
import 'package:torii_client/utils/exports.dart';
import 'package:torii_client/domain/models/tokens/a_msg_form_model.dart';

class TxSendFormFooter extends StatefulWidget {
  final TokenAmountModel feeTokenAmountModel;
  final GlobalKey<FormState> formKey;
  final AMsgFormModel msgFormModel;
  final ValueChanged<SignedTxModel> onSubmit;

  const TxSendFormFooter({
    required this.feeTokenAmountModel,
    required this.formKey,
    required this.msgFormModel,
    required this.onSubmit,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TxSendFormFooter();
}

class _TxSendFormFooter extends State<TxSendFormFooter> {
  final SessionCubit sessionCubit = getIt<SessionCubit>();
  final MetamaskCubit metamaskCubit = getIt<MetamaskCubit>();
  late final TxFormBuilderCubit txFormBuilderCubit = TxFormBuilderCubit(
    feeTokenAmountModel: widget.feeTokenAmountModel,
    msgFormModel: widget.msgFormModel,
  );

  @override
  void dispose() {
    txFormBuilderCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return BlocBuilder<TxFormBuilderCubit, ATxFormBuilderState>(
      bloc: txFormBuilderCubit,
      builder: (BuildContext context, ATxFormBuilderState txFormBuilderState) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (txFormBuilderState is TxFormBuilderDownloadingState)
              const TxSendFormCompletingIndicator()
            else
              AnimatedBuilder(
                animation: widget.msgFormModel,
                builder: (BuildContext context, Widget? _) {
                  bool formFilledBool = widget.msgFormModel.canBuildTxMsg();
                  return TxSendFormNextButton(
                    errorExistsBool: txFormBuilderState is TxFormBuilderErrorState,
                    disabledBool: formFilledBool == false,
                    onPressed: () => _handleNextButtonPressed(context),
                  );
                },
              ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  S.of(context).txNoticeFee(widget.feeTokenAmountModel.toString()),
                  style: textTheme.bodySmall!.copyWith(color: DesignColors.white1),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleNextButtonPressed(BuildContext context) async {
    if (widget.formKey.currentState!.validate() == false) {
      getIt<Logger>().e('Form is not valid');
      return;
    }
    try {
      UnsignedTxModel unsignedTxModel = await txFormBuilderCubit.buildUnsignedTx();
      if (metamaskCubit.isSupported && sessionCubit.state.kiraWallet!.ecPrivateKey == null) {
        // TODO(Mykyta): is there possibility that model can be not a MsgSendModel ? (`send-via-metamask` task)
        // ignore:unused_local_variable
        int amount =
            (unsignedTxModel.txLocalInfoModel.txMsgModel as MsgSendModel).tokenAmountModel
                .getAmountInDefaultDenomination()
                .toBigInt()
                .toInt();
        // TODO(Mykyta): add error handling at `send-via-metamask` task
        await metamaskCubit.pay(to: sessionCubit.state.kiraWallet!.address, amount: 0);
        return;
      }
      SignedTxModel signedTxModel = await _signTransaction(unsignedTxModel);
      widget.onSubmit(signedTxModel);
    } catch (e) {
      getIt<Logger>().e(e.toString());
      return;
    }
  }

  Future<SignedTxModel> _signTransaction(UnsignedTxModel unsignedTxModel) async {
    Wallet? wallet = sessionCubit.state.kiraWallet;
    if (wallet == null) {
      throw Exception('Wallet cannot be null when signing transaction');
    }
    SignedTxModel signedTxModel = unsignedTxModel.sign(wallet);
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return signedTxModel;
  }
}
