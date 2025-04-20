import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:torii_client/domain/exports.dart';
import 'package:torii_client/presentation/transfer/input/cubit/transfer_input_cubit.dart';
import 'package:torii_client/presentation/transfer/widgets/token_form/cubit/token_form_cubit.dart';
import 'package:torii_client/presentation/transfer/widgets/token_form/cubit/token_form_state.dart';
import 'package:torii_client/presentation/transfer/widgets/token_form/token_amount_text_field/token_amount_text_field.dart';
import 'package:torii_client/presentation/transfer/widgets/token_form/token_available_amount.dart';
import 'package:torii_client/presentation/transfer/widgets/token_form/token_denomination_list.dart';
import 'package:torii_client/presentation/widgets/exports.dart';
import 'package:torii_client/utils/exports.dart';

typedef ValidateCallback = String? Function(TokenAmountModel?);

class TokenForm extends StatefulWidget {
  final String label;
  final ValueChanged<TokenFormState> onChanged;
  final TokenAmountModel feeTokenAmountModel;
  final AWalletAddress? walletAddress;
  final bool selectableBool;
  final TokenAmountModel? balance;
  final TokenAmountModel? defaultTokenAmountModel;
  // final FilterOption<TokenAmountModel>? initialFilterOption;
  final TokenDenominationModel? defaultTokenDenominationModel;
  final ValidateCallback? validateCallback;

  const TokenForm({
    required this.label,
    required this.onChanged,
    required this.feeTokenAmountModel,
    required this.walletAddress,
    this.selectableBool = true,
    // this.initialFilterOption,
    this.balance,
    this.defaultTokenAmountModel,
    this.defaultTokenDenominationModel,
    this.validateCallback,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _TokenForm();
}

class _TokenForm extends State<TokenForm> {
  late final TokenFormCubit tokenFormCubit;

  @override
  void initState() {
    super.initState();
    if (widget.balance != null) {
      tokenFormCubit = TokenFormCubit.fromBalance(
        balance: widget.balance!,
        feeTokenAmountModel: widget.feeTokenAmountModel,
        walletAddress: widget.walletAddress,
        tokenAmountModel: widget.defaultTokenAmountModel,
        tokenDenominationModel: widget.defaultTokenDenominationModel,
      );
    } else {
      tokenFormCubit = TokenFormCubit.fromFirstBalance(
        feeTokenAmountModel: widget.feeTokenAmountModel,
        walletAddress: widget.walletAddress,
      );
    }
  }

  @override
  void didUpdateWidget(covariant TokenForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.defaultTokenDenominationModel != widget.defaultTokenDenominationModel &&
        widget.defaultTokenDenominationModel != null) {
      tokenFormCubit.updateTokenDenomination(widget.defaultTokenDenominationModel!);
    }
    if (oldWidget.defaultTokenAmountModel != widget.defaultTokenAmountModel && widget.defaultTokenAmountModel != null) {
      tokenFormCubit.updateTokenAmount(widget.defaultTokenAmountModel!);
    }
  }

  @override
  void dispose() {
    tokenFormCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    Widget shimmerWidget = const LoadingContainer(
      height: 60,
      circularBorderRadius: 8,
      boxConstraints: BoxConstraints(minWidth: 100),
    );

    return BlocProvider<TokenFormCubit>.value(
      value: tokenFormCubit,
      child: BlocConsumer<TokenFormCubit, TokenFormState>(
        listener: (_, TokenFormState tokenFormState) => _notifyTokenAmountChanged(tokenFormState),
        builder: (BuildContext context, TokenFormState tokenFormState) {
          return FormField<TokenAmountModel>(
            key: tokenFormCubit.formFieldKey,
            validator: (_) => _buildErrorMessage(tokenFormState),
            builder: (FormFieldState<TokenAmountModel> formFieldState) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      if (tokenFormState.loadingBool) ...<Widget>[
                        Expanded(child: shimmerWidget),
                        // TODO: dropdown
                        // const SizedBox(width: 16),
                        // Expanded(child: shimmerWidget),
                      ] else ...<Widget>[
                        Expanded(
                          child: TokenAmountTextField(
                            label: widget.label,
                            errorExistsBool: formFieldState.hasError,
                            disabledBool: widget.walletAddress == null,
                            textEditingController: tokenFormCubit.amountTextEditingController,
                            selectedTokenDenomination: tokenFormState.tokenDenominationModel,
                            tokenDenominations:
                                tokenFormState.tokenAmountModel?.tokenAliasModel.tokenDenominations ??
                                <TokenDenominationModel>[],
                            tokenFormState: tokenFormState,
                          ),
                        ),
                        // TODO: dropdown
                        // TokenDropdown(
                        //   disabledBool: widget.selectableBool == false,
                        //   defaultTokenAmountModel: tokenFormState.balance,
                        //   // initialFilterOption: widget.initialFilterOption,
                        //   walletAddress: widget.walletAddress,
                        // ),
                      ],
                    ],
                  ),
                  if (tokenFormState.errorBool) ...<Widget>[
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: tokenFormCubit.init,
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      icon: const Icon(Icons.refresh, color: DesignColors.redStatus1, size: 16),
                      label: Text(
                        S.of(context).txErrorCannotLoadBalances,
                        style: textTheme.bodySmall!.copyWith(color: DesignColors.redStatus1),
                      ),
                    ),
                  ],
                  // TokenAvailableAmount(
                  //   formFieldState: formFieldState,
                  //   balance: tokenFormState.balance,
                  //   feeTokenAmountModel: tokenFormState.feeTokenAmountModel,
                  //   tokenDenominationModel: tokenFormState.tokenDenominationModel,
                  // ),
                  // TokenDenominationList(
                  //   tokenAliasModel: tokenFormState.balance?.tokenAliasModel,
                  //   defaultTokenDenominationModel: tokenFormState.tokenDenominationModel,
                  //   onChanged: tokenFormCubit.updateTokenDenomination,
                  // ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  void _notifyTokenAmountChanged(TokenFormState tokenFormState) {
    bool formValidBool = _isFormValid(tokenFormState);
    if (formValidBool) {
      widget.onChanged(tokenFormState);
    } else if (tokenFormState.tokenAmountModel != null) {
      TokenFormState errorTokenFormState = tokenFormState.copyWith(
        tokenAmountModel: TokenAmountModel(
          defaultDenominationAmount: Decimal.zero,
          tokenAliasModel: tokenFormState.tokenAmountModel!.tokenAliasModel,
        ),
        tokenDenominationModel: tokenFormState.tokenDenominationModel,
      );
      widget.onChanged(errorTokenFormState);
    }
  }

  bool _isFormValid(TokenFormState tokenFormState) {
    String? errorMessage = _buildErrorMessage(tokenFormState);
    return errorMessage == null;
  }

  String? _buildErrorMessage(TokenFormState tokenFormState) {
    TokenAmountModel? selectedTokenAmountModel = tokenFormState.tokenAmountModel;
    TokenAmountModel? availableTokenAmountModel = tokenFormState.availableTokenAmountModel;

    Decimal selectedTokenAmount = selectedTokenAmountModel?.getAmountInBaseDenomination() ?? Decimal.zero;
    Decimal availableTokenAmount = availableTokenAmountModel?.getAmountInBaseDenomination() ?? Decimal.zero;
    if (selectedTokenAmount == Decimal.zero) {
      return null;
    } else if (availableTokenAmount < selectedTokenAmount) {
      return S.of(context).txErrorNotEnoughTokens;
    } else if (availableTokenAmountModel == null) {
      return S.of(context).txPleaseSelectToken;
    } else if (widget.validateCallback != null) {
      return widget.validateCallback!(selectedTokenAmountModel);
    } else {
      return null;
    }
  }
}
