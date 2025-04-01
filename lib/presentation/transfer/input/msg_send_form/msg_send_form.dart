import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:torii_client/domain/exports.dart';
import 'package:torii_client/presentation/transfer/input/cubit/transfer_input_cubit.dart';
import 'package:torii_client/presentation/transfer/input/memo_text_field/memo_text_field.dart';
import 'package:torii_client/presentation/transfer/widgets/toggle_between_wallet_address_types.dart';
import 'package:torii_client/presentation/transfer/widgets/token_form/cubit/token_form_state.dart';
import 'package:torii_client/presentation/transfer/widgets/token_form/token_amount_text_field/token_amount_text_field.dart';
import 'package:torii_client/presentation/transfer/widgets/token_form/token_amount_text_field/token_amount_text_field_content.dart';
import 'package:torii_client/presentation/transfer/widgets/token_form/token_denomination_list.dart';
import 'package:torii_client/presentation/transfer/widgets/token_form/token_form.dart';
import 'package:torii_client/presentation/transfer/widgets/token_form/tx_input_static_label.dart';
import 'package:torii_client/presentation/transfer/widgets/tx_input_wrapper.dart';
import 'package:torii_client/presentation/transfer/widgets/wallet_address_text_field.dart';
import 'package:torii_client/presentation/widgets/buttons/kira_chip_button.dart';
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
  final TextEditingController recipientAmountController = TextEditingController();
  final FocusNode recipientAmountFocusNode = FocusNode();
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
    final recipientTokenDenomination =
        widget.msgSendFormModel.recipientTokenDenomination ??
        (widget.msgSendFormModel.recipientWalletAddress is EthereumWalletAddress
            ? TokenAliasModel.eth().baseTokenDenominationModel
            : TokenAliasModel.kex().baseTokenDenominationModel);
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
            needKiraAddress: widget.msgSendFormModel.senderWalletAddress is CosmosWalletAddress,
          ),
          const SizedBox(height: 14),
          ValueListenableBuilder<AWalletAddress?>(
            valueListenable: walletAddressNotifier,
            builder: (_, AWalletAddress? walletAddress, __) {
              getIt<Logger>().i('updated balance: ${widget.msgSendFormModel.balance}');
              return BlocBuilder<TransferInputCubit, TransferInputState>(
                buildWhen: (previous, current) {
                  return previous.balance != current.balance ||
                      (previous.senderAmount != current.senderAmount && !current.changedBySender);
                },
                builder: (context, state) {
                  return TokenForm(
                    label: S.of(context).balancesAmount,
                    feeTokenAmountModel: widget.feeTokenAmountModel,
                    balance: state.balance,
                    defaultTokenAmountModel: state.senderAmount,
                    defaultTokenDenominationModel: widget.msgSendFormModel.tokenDenominationModel,
                    onChanged: _handleTokenAmountChanged,
                    walletAddress: walletAddress,
                  );
                },
              );
            },
          ),
          const SizedBox(height: 16),
          Center(child: const ToggleBetweenWalletAddressTypes()),
          const SizedBox(height: 16),
          WalletAddressTextField(
            label: S.of(context).txHintSendTo,
            onChanged: _handleRecipientAddressChanged,
            defaultWalletAddress: widget.msgSendFormModel.recipientWalletAddress,
            needKiraAddress: widget.msgSendFormModel.senderWalletAddress is EthereumWalletAddress,
          ),
          const SizedBox(height: 14),
          BlocBuilder<TransferInputCubit, TransferInputState>(
            buildWhen: (previous, current) {
              return (previous.recipientAmount != current.recipientAmount && current.changedBySender) ||
                  previous.recipientWalletAddress != current.recipientWalletAddress;
            },
            builder: (context, state) {
              return TxInputWrapper(
                disabled: state.recipientWalletAddress == null,
                height: 80,
                hasErrors: false,
                builderWithFocus:
                    (FocusNode focusNode) => SizedBox(
                      height: double.infinity,
                      child: Center(
                        child: TxInputStaticLabel(
                          label: 'Relative amount',
                          contentPadding: const EdgeInsets.only(top: 8, bottom: 4),
                          child: TokenAmountTextFieldContent(
                            disabledBool: state.recipientWalletAddress == null,
                            label: 'Relative amount',
                            textEditingController: recipientAmountController,
                            selectedTokenDenomination:
                                // TODO: pass baseTokenDenominationModel before
                                recipientTokenDenomination,
                            tokenDenominations: [recipientTokenDenomination],
                            errorExistsBool: false,
                            onChanged: _handleRecipientAmountChanged,
                            onChangedDenomination: (_) {},
                            focusNode: focusNode,
                          ),
                        ),
                      ),
                    ),
              );
            },
          ),
          const SizedBox(height: 24),
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
    context.read<TransferInputCubit>().updateRecipientWalletAddress(walletAddress);
  }

  void _handleTokenAmountChanged(TokenFormState tokenFormState) {
    widget.msgSendFormModel.balance = tokenFormState.balance;
    widget.msgSendFormModel.tokenAmountModel = tokenFormState.tokenAmountModel;
    widget.msgSendFormModel.tokenDenominationModel = tokenFormState.tokenDenominationModel;
    widget.msgSendFormModel.recipientRelativeAmount =
        tokenFormState.tokenAmountModel == null
            ? null
            : TokenAmountModel(
              baseDenominationAmount:
                  (tokenFormState.tokenAmountModel!.getAmountInBaseDenomination() * Decimal.fromInt(2)),
              tokenAliasModel:
                  widget.msgSendFormModel.recipientRelativeAmount?.tokenAliasModel ??
                  widget.msgSendFormModel.tokenAmountModel!.tokenAliasModel.toOpposite(),
            );
    recipientAmountController.text =
        widget.msgSendFormModel.recipientRelativeAmount?.getAmountInBaseDenomination().toString() ?? '';
    context.read<TransferInputCubit>().updateAmount(
      senderAmount: widget.msgSendFormModel.tokenAmountModel!,
      recipientAmount: widget.msgSendFormModel.recipientRelativeAmount!,
      changedBySender: true,
    );
  }

  void _handleRecipientAmountChanged(String text) {
    widget.msgSendFormModel.tokenAmountModel = TokenAmountModel(
      baseDenominationAmount: ((Decimal.tryParse(text) ?? Decimal.zero) / Decimal.fromInt(2)).toDecimal(),
      tokenAliasModel:
          widget.msgSendFormModel.tokenAmountModel?.tokenAliasModel ??
          (widget.msgSendFormModel.senderWalletAddress is EthereumWalletAddress
              ? TokenAliasModel.eth()
              : TokenAliasModel.kex()),
    );
    widget.msgSendFormModel.recipientRelativeAmount = TokenAmountModel(
      baseDenominationAmount: Decimal.tryParse(text) ?? Decimal.zero,
      tokenAliasModel:
          widget.msgSendFormModel.recipientRelativeAmount?.tokenAliasModel ??
          widget.msgSendFormModel.tokenAmountModel!.tokenAliasModel.toOpposite(),
    );
    widget.msgSendFormModel.recipientTokenDenomination = widget.msgSendFormModel.tokenDenominationModel;
    context.read<TransferInputCubit>().updateAmount(
      senderAmount: widget.msgSendFormModel.tokenAmountModel!,
      recipientAmount: widget.msgSendFormModel.recipientRelativeAmount!,
      changedBySender: false,
    );
  }

  // void _handleRecipientAmountChanged(TokenFormState tokenFormState) {
  //   widget.msgSendFormModel.tokenAmountModel =
  //       tokenFormState.tokenAmountModel == null
  //           ? null
  //           : TokenAmountModel(
  //             baseDenominationAmount:
  //                 (tokenFormState.tokenAmountModel!.getAmountInBaseDenomination() / Decimal.fromInt(2)).toDecimal(),
  //             tokenAliasModel: widget.msgSendFormModel.tokenAmountModel!.tokenAliasModel,
  //           );
  //   widget.msgSendFormModel.recipientRelativeAmount = tokenFormState.tokenAmountModel;
  //   widget.msgSendFormModel.recipientTokenDenomination = tokenFormState.tokenDenominationModel;
  // }

  void _handleMemoChanged(String memo) {
    widget.msgSendFormModel.memo = memo;
  }
}
