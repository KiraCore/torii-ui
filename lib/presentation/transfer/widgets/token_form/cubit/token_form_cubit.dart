import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:torii_client/data/dto/api_kira/query_balance/request/query_balance_req.dart';
import 'package:torii_client/domain/exports.dart';
import 'package:torii_client/domain/models/page_data.dart';
import 'package:torii_client/domain/services/miro/query_balance_service.dart';
import 'package:torii_client/utils/exports.dart';
import 'package:torii_client/utils/extensions/tx_utils.dart';

import 'token_form_state.dart';

class TokenFormCubit extends Cubit<TokenFormState> {
  final GlobalKey<FormFieldState<TokenAmountModel>> formFieldKey = GlobalKey<FormFieldState<TokenAmountModel>>();
  final QueryBalanceService queryBalanceService = getIt<QueryBalanceService>();
  final TextEditingController amountTextEditingController = TextEditingController(text: '0');

  TokenFormCubit.fromBalance({
    required TokenAmountModel feeTokenAmountModel,
    required TokenAmountModel balance,
    required AWalletAddress? walletAddress,
    TokenAmountModel? tokenAmountModel,
    TokenDenominationModel? tokenDenominationModel,
  }) : super(
         TokenFormState.fromBalance(
           balance: balance,
           feeTokenAmountModel: feeTokenAmountModel,
           walletAddress: walletAddress,
           tokenAmountModel: tokenAmountModel,
           tokenDenominationModel: tokenDenominationModel,
         ),
       ) {
    init();
  }

  TokenFormCubit.fromFirstBalance({
    required TokenAmountModel feeTokenAmountModel,
    required AWalletAddress? walletAddress,
  }) : super(
         TokenFormState.fromFirstBalance(
           feeTokenAmountModel: feeTokenAmountModel,
           walletAddress: walletAddress,
           loadingBool: true,
         ),
       ) {
    init();
  }

  void init() {
    bool balanceExistsBool = state.balance != null;
    if (balanceExistsBool) {
      _updateTextFieldValue();
    } else {
      _initWithFirstBalance();
    }
  }

  @override
  Future<void> close() {
    formFieldKey.currentState?.dispose();
    amountTextEditingController.dispose();
    return super.close();
  }

  void clearTokenAmount() {
    emit(
      state.copyWith(tokenAmountModel: TokenAmountModel.zero(tokenAliasModel: state.tokenAmountModel!.tokenAliasModel)),
    );
    _updateTextFieldValue();
  }

  void notifyTokenAmountTextChanged(String text) {
    TokenAmountModel tokenAmountModel = state.tokenAmountModel!.copy();
    Decimal parsedAmount = Decimal.tryParse(text) ?? Decimal.zero;
    tokenAmountModel.setAmount(parsedAmount, tokenDenominationModel: state.tokenDenominationModel);

    emit(state.copyWith(tokenAmountModel: tokenAmountModel));
    _validateTokenForm();
  }

  void setAllAvailableAmount() {
    emit(state.copyWith(tokenAmountModel: state.availableTokenAmountModel));
    _updateTextFieldValue();
  }

  void updateBalance(TokenAmountModel balance) {
    TokenAliasModel tokenAliasModel = balance.tokenAliasModel;

    emit(
      state.copyWith(
        loadingBool: false,
        errorBool: false,
        balance: balance,
        tokenDenominationModel: tokenAliasModel.baseTokenDenominationModel,
        tokenAmountModel: TokenAmountModel.zero(tokenAliasModel: tokenAliasModel),
      ),
    );
    _updateTextFieldValue();
  }

  void updateTokenDenomination(TokenDenominationModel tokenDenominationModel) {
    emit(state.copyWith(loadingBool: false, tokenDenominationModel: tokenDenominationModel));
    _updateTextFieldValue();
  }

  void updateTokenAmount(TokenAmountModel tokenAmountModel) {
    emit(state.copyWith(loadingBool: false, tokenAmountModel: tokenAmountModel));
    _updateTextFieldValue();
  }

  Future<void> _initWithFirstBalance() async {
    try {
      PageData<TokenAmountModel> balanceData = await queryBalanceService.getTokenAmountModelList(
        QueryBalanceReq(address: state.walletAddress!.address, offset: 0, limit: 500),
      );
      List<TokenAmountModel> balanceList = balanceData.listItems;

      // if (filterOption != null) {
      //   balanceList = balanceList.where(filterOption.filterComparator).toList();
      // }

      TokenAmountModel initialtokenAmountModel = balanceList.first;
      updateBalance(initialtokenAmountModel);
    } catch (_) {
      emit(state.copyWith(errorBool: true));
    }
  }

  void _updateTextFieldValue() {
    bool amountFieldEnabledBool = state.tokenAmountModel != null && state.tokenDenominationModel != null;
    if (amountFieldEnabledBool) {
      Decimal availableAmount = state.tokenAmountModel!.getAmountInDenomination(state.tokenDenominationModel!);
      String displayedAmount = TxUtils.buildAmountString(availableAmount.toString(), state.tokenDenominationModel);
      amountTextEditingController.text = displayedAmount;
      _validateTokenForm();
    }
  }

  void _validateTokenForm() {
    Future<void>.delayed(const Duration(milliseconds: 50), () => formFieldKey.currentState?.validate());
  }
}
