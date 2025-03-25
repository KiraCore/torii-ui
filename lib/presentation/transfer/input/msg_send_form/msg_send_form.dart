import 'package:flutter/material.dart';
import 'package:torii_client/domain/exports.dart';
import 'package:torii_client/presentation/transfer/input/memo_text_field/memo_text_field.dart';
import 'package:torii_client/presentation/transfer/widgets/token_form/cubit/token_form_state.dart';
import 'package:torii_client/presentation/transfer/widgets/token_form/token_form.dart';
import 'package:torii_client/presentation/transfer/widgets/wallet_address_text_field.dart';
import 'package:torii_client/utils/exports.dart';

class MsgSendForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final MsgSendFormModel msgSendFormModel;
  final TokenAmountModel feeTokenAmountModel;

  const MsgSendForm({
    required this.formKey,
    required this.msgSendFormModel,
    required this.feeTokenAmountModel,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _MsgSendForm();
}

class _MsgSendForm extends State<MsgSendForm> {
  final TextEditingController memoTextEditingController = TextEditingController();
  final ValueNotifier<AWalletAddress?> walletAddressNotifier = ValueNotifier<AWalletAddress?>(null);

  @override
  void initState() {
    super.initState();
    _assignDefaultValues();
  }

  @override
  void dispose() {
    memoTextEditingController.dispose();
    walletAddressNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          WalletAddressTextField(
            label: S.of(context).txHintSendFrom,
            disabledBool: true,
            onChanged: _handleSenderAddressChanged,
            defaultWalletAddress: widget.msgSendFormModel.senderWalletAddress,
          ),
          const SizedBox(height: 14),
          WalletAddressTextField(
            label: S.of(context).txHintSendTo,
            onChanged: _handleRecipientAddressChanged,
            defaultWalletAddress: widget.msgSendFormModel.recipientWalletAddress,
          ),
          const SizedBox(height: 14),
          ValueListenableBuilder<AWalletAddress?>(
            valueListenable: walletAddressNotifier,
            builder: (_, AWalletAddress? walletAddress, __) {
              getIt<Logger>().i('updated balance: ${widget.msgSendFormModel.balance}');
              return TokenForm(
                label: S.of(context).balancesAmount,
                feeTokenAmountModel: widget.feeTokenAmountModel,
                balance: widget.msgSendFormModel.balance,
                defaultTokenAmountModel: widget.msgSendFormModel.tokenAmountModel,
                defaultTokenDenominationModel: widget.msgSendFormModel.tokenDenominationModel,
                onChanged: _handleTokenAmountChanged,
                walletAddress: walletAddress,
              );
            },
          ),
          const SizedBox(height: 19),
          MemoTextField(
            label: S.of(context).txHintMemo,
            onChanged: _handleMemoChanged,
            memoTextEditingController: memoTextEditingController,
          ),
        ],
      ),
    );
  }

  void _assignDefaultValues() {
    memoTextEditingController.text = widget.msgSendFormModel.memo;
    walletAddressNotifier.value = widget.msgSendFormModel.senderWalletAddress;
  }

  void _handleSenderAddressChanged(AWalletAddress? walletAddress) {
    walletAddressNotifier.value = walletAddress;
    widget.msgSendFormModel.senderWalletAddress = walletAddress;
  }

  void _handleRecipientAddressChanged(AWalletAddress? walletAddress) {
    widget.msgSendFormModel.recipientWalletAddress = walletAddress;
  }

  void _handleTokenAmountChanged(TokenFormState tokenFormState) {
    widget.msgSendFormModel.balance = tokenFormState.balance;
    widget.msgSendFormModel.tokenAmountModel = tokenFormState.tokenAmountModel;
    widget.msgSendFormModel.tokenDenominationModel = tokenFormState.tokenDenominationModel;
  }

  void _handleMemoChanged(String memo) {
    widget.msgSendFormModel.memo = memo;
  }
}
