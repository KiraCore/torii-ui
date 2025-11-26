import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:torii_client/domain/exports.dart';
import 'package:torii_client/presentation/transfer/input/cubit/transfer_input_cubit.dart';
import 'package:torii_client/presentation/transfer/input/memo_text_field/memo_text_field.dart';
import 'package:torii_client/presentation/transfer/tx_process_cubit/tx_process_cubit.dart';
import 'package:torii_client/presentation/transfer/widgets/toggle_between_wallet_address_types.dart';
import 'package:torii_client/presentation/transfer/widgets/token_form/cubit/token_form_state.dart';
import 'package:torii_client/presentation/transfer/widgets/token_form/token_amount_text_field/token_amount_text_field_content.dart';
import 'package:torii_client/presentation/transfer/widgets/token_form/token_form.dart';
import 'package:torii_client/presentation/transfer/widgets/token_form/tx_input_static_label.dart';
import 'package:torii_client/presentation/transfer/widgets/tx_input_wrapper.dart';
import 'package:torii_client/presentation/transfer/widgets/wallet_address_text_field.dart';
import 'package:torii_client/utils/exports.dart';
import 'package:torii_client/utils/extensions/tx_utils.dart';

class MsgSendForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TokenAmountModel feeTokenAmountModel;

  const MsgSendForm({
    required this.formKey,
    required this.feeTokenAmountModel,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _MsgSendForm();
}

class _MsgSendForm extends State<MsgSendForm> {
  final TextEditingController memoTextEditingController =
      TextEditingController();
  final TextEditingController recipientAmountController =
      TextEditingController();
  final FocusNode recipientAmountFocusNode = FocusNode();
  TxProcessCubit<MsgSendFormModel> get txProcessCubit =>
      context.read<TxProcessCubit<MsgSendFormModel>>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _assignDefaultValues();
    });
  }

  @override
  void dispose() {
    memoTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recipientTokenAlias =
        txProcessCubit.msgFormModel.senderWalletAddress is EthereumWalletAddress
            ? TokenAliasModel.kex()
            : TokenAliasModel.wkex();

    return Column(
      children: [
        Form(
          key: widget.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              WalletAddressTextField(
                label: S.of(context).txHintSendFrom,
                disabledBool: true,
                onChanged: (_) {
                  // NOTE: it cannot be changed
                },
                defaultWalletAddress:
                    txProcessCubit.msgFormModel.senderWalletAddress,
                needKiraAddress:
                    txProcessCubit.msgFormModel.senderWalletAddress
                        is CosmosWalletAddress,
              ),
              const SizedBox(height: 14),
              BlocBuilder<TransferInputCubit, TransferInputState>(
                buildWhen: (previous, current) {
                  return previous.balance != current.balance ||
                      (previous.senderAmount != current.senderAmount &&
                          !current.changedBySender);
                },
                builder: (context, state) {
                  return TokenForm(
                    label: S.of(context).balancesAmount,
                    feeTokenAmountModel: widget.feeTokenAmountModel,
                    balance: state.balance,
                    defaultTokenAmountModel: state.senderAmount,
                    defaultTokenDenominationModel:
                        txProcessCubit.msgFormModel.tokenDenominationModel,
                    onChanged: _handleTokenAmountChanged,
                    walletAddress:
                        txProcessCubit.msgFormModel.senderWalletAddress,
                  );
                },
              ),
              const SizedBox(height: 16),
              Center(child: const ToggleBetweenWalletAddressTypes()),
              const SizedBox(height: 16),
              BlocBuilder<TransferInputCubit, TransferInputState>(
                buildWhen: (previous, current) {
                  return previous.recipientWalletAddress !=
                          current.recipientWalletAddress ||
                      previous.fromWallet != current.fromWallet;
                },
                builder: (context, state) {
                  return WalletAddressTextField(
                    label: S.of(context).txHintSendTo,
                    onChanged: _handleRecipientAddressChanged,
                    defaultWalletAddress: state.recipientWalletAddress,
                    needKiraAddress:
                        state.fromWallet.address is EthereumWalletAddress,
                  );
                },
              ),
              const SizedBox(height: 14),
              BlocConsumer<TransferInputCubit, TransferInputState>(
                listenWhen: (previous, current) {
                  return previous.recipientTokenDenomination !=
                      current.recipientTokenDenomination;
                },
                listener: (context, state) async {
                  txProcessCubit.msgFormModel.recipientTokenDenomination =
                      state.recipientTokenDenomination;
                },
                buildWhen: (previous, current) {
                  // TODO: refactor, it's here because it should be updated on INIT
                  txProcessCubit.msgFormModel.recipientWalletAddress =
                      current.recipientWalletAddress;

                  return (previous.recipientAmount != current.recipientAmount &&
                          current.changedBySender) ||
                      previous.recipientWalletAddress !=
                          current.recipientWalletAddress ||
                      previous.recipientTokenDenomination !=
                          current.recipientTokenDenomination;
                },
                builder: (context, state) {
                  if (recipientAmountController.text.isEmpty) {
                    // NOTE: initial value
                    recipientAmountController.text = TxUtils.buildAmountString(
                      // TODO: fix '0' initial value, refactor
                      state.recipientAmount
                              ?.getAmountInDenomination(
                                state.recipientTokenDenomination!,
                              )
                              .toString() ??
                          '0',
                      state.recipientTokenDenomination,
                    );
                  }
                  return TxInputWrapper(
                    disabled: state.recipientWalletAddress == null,
                    height: 80,
                    hasErrors: false,
                    builderWithFocus: (FocusNode focusNode) {
                      return SizedBox(
                        height: double.infinity,
                        child: Center(
                          child: TxInputStaticLabel(
                            label: 'Amount',
                            contentPadding: const EdgeInsets.only(
                              top: 8,
                              bottom: 4,
                            ),
                            child: TokenAmountTextFieldContent(
                              disabledBool:
                                  state.recipientWalletAddress == null,
                              label: 'Amount',
                              textEditingController: recipientAmountController,
                              selectedTokenDenomination:
                                  state.recipientTokenDenomination,
                              tokenDenominations:
                                  recipientTokenAlias.tokenDenominations,
                              errorExistsBool: false,
                              onChanged: _handleRecipientAmountChanged,
                              onChangedDenomination: (denomination) {
                                context
                                    .read<TransferInputCubit>()
                                    .updateRecipientTokenDenomination(
                                      denomination,
                                      recipientAmountController,
                                    );
                              },
                              focusNode: focusNode,
                            ),
                          ),
                        ),
                      );
                    },
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
        ),
      ],
    );
  }

  void _assignDefaultValues() {
    memoTextEditingController.text = txProcessCubit.msgFormModel.memo;
  }

  void _handleRecipientAddressChanged(AWalletAddress? walletAddress) {
    txProcessCubit.msgFormModel.recipientWalletAddress = walletAddress;
    context.read<TransferInputCubit>().updateRecipientWalletAddress(
      walletAddress,
    );
  }

  void _handleTokenAmountChanged(TokenFormState tokenFormState) {
    txProcessCubit.msgFormModel.balance = tokenFormState.balance;
    txProcessCubit.msgFormModel.tokenAmountModel =
        tokenFormState.tokenAmountModel;
    txProcessCubit.msgFormModel.tokenDenominationModel =
        tokenFormState.tokenDenominationModel;
    txProcessCubit.msgFormModel.recipientRelativeAmount =
        tokenFormState.tokenAmountModel == null
            ? null
            : TokenAmountModel(
              baseDenominationAmount:
                  tokenFormState.tokenAmountModel!
                      .getAmountInBaseDenomination(),
              tokenAliasModel:
                  txProcessCubit
                      .msgFormModel
                      .recipientRelativeAmount
                      ?.tokenAliasModel ??
                  txProcessCubit.msgFormModel.tokenAmountModel!.tokenAliasModel
                      .toOpposite(),
            );

    final recipientAmount =
        txProcessCubit.msgFormModel.recipientRelativeAmount
            ?.getAmountInBaseDenomination()
            .toString() ??
        '';
    if (recipientAmount == recipientAmountController.text) {
      // NOTE: do not rebuild if it was triggered by recipient
      return;
    }
    recipientAmountController.text = recipientAmount;

    if (txProcessCubit.msgFormModel.recipientRelativeAmount != null &&
        txProcessCubit.msgFormModel.tokenAmountModel != null) {
      context.read<TransferInputCubit>().updateAmount(
        senderAmount: txProcessCubit.msgFormModel.tokenAmountModel!,
        recipientAmount: txProcessCubit.msgFormModel.recipientRelativeAmount!,
        changedBySender: true,
      );
    }
  }

  void _handleRecipientAmountChanged(String text) {
    txProcessCubit.msgFormModel.tokenAmountModel = TokenAmountModel(
      baseDenominationAmount: Decimal.tryParse(text) ?? Decimal.zero,
      tokenAliasModel:
          txProcessCubit.msgFormModel.tokenAmountModel?.tokenAliasModel ??
          (txProcessCubit.msgFormModel.senderWalletAddress
                  is EthereumWalletAddress
              ? TokenAliasModel.wkex()
              : TokenAliasModel.kex()),
    );
    txProcessCubit.msgFormModel.recipientRelativeAmount = TokenAmountModel(
      baseDenominationAmount: Decimal.tryParse(text) ?? Decimal.zero,
      tokenAliasModel:
          txProcessCubit
              .msgFormModel
              .recipientRelativeAmount
              ?.tokenAliasModel ??
          txProcessCubit.msgFormModel.tokenAmountModel!.tokenAliasModel
              .toOpposite(),
    );

    context.read<TransferInputCubit>().updateAmount(
      senderAmount: txProcessCubit.msgFormModel.tokenAmountModel!,
      recipientAmount: txProcessCubit.msgFormModel.recipientRelativeAmount!,
      changedBySender: false,
    );
  }

  void _handleMemoChanged(String memo) {
    txProcessCubit.msgFormModel.memo = memo;
  }
}
