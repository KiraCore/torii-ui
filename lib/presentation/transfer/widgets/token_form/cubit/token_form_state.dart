import 'package:equatable/equatable.dart';
import 'package:torii_client/domain/exports.dart';

class TokenFormState extends Equatable {
  final TokenAmountModel feeTokenAmountModel;
  final bool errorBool;
  final bool loadingBool;
  final TokenAmountModel? balance;
  final TokenAmountModel? tokenAmountModel;
  final TokenDenominationModel? tokenDenominationModel;
  final AWalletAddress? walletAddress;

  const TokenFormState._({
    required this.feeTokenAmountModel,
    this.errorBool = false,
    this.loadingBool = false,
    this.balance,
    this.tokenAmountModel,
    this.tokenDenominationModel,
    this.walletAddress,
  });

  factory TokenFormState.fromBalance({
    required TokenAmountModel balance,
    required TokenAmountModel feeTokenAmountModel,
    required AWalletAddress? walletAddress,
    bool loadingBool = false,
    TokenAmountModel? tokenAmountModel,
    TokenDenominationModel? tokenDenominationModel,
  }) {
    TokenAliasModel tokenAliasModel = balance.tokenAliasModel;

    return TokenFormState._(
      balance: balance,
      feeTokenAmountModel: feeTokenAmountModel,
      walletAddress: walletAddress,
      loadingBool: loadingBool,
      tokenAmountModel: tokenAmountModel ?? TokenAmountModel.zero(tokenAliasModel: tokenAliasModel),
      tokenDenominationModel: tokenDenominationModel ?? tokenAliasModel.defaultTokenDenominationModel,
    );
  }

  factory TokenFormState.fromFirstBalance({
    required TokenAmountModel feeTokenAmountModel,
    required AWalletAddress? walletAddress,
    bool loadingBool = false,
  }) {
    return TokenFormState._(
      feeTokenAmountModel: feeTokenAmountModel,
      loadingBool: loadingBool,
      walletAddress: walletAddress,
    );
  }

  TokenFormState copyWith({
    TokenAmountModel? feeTokenAmountModel,
    bool? errorBool,
    bool? loadingBool,
    TokenAmountModel? balance,
    TokenDenominationModel? tokenDenominationModel,
    TokenAliasModel? tokenAliasModel,
    TokenAmountModel? tokenAmountModel,
    AWalletAddress? walletAddress,
  }) {
    return TokenFormState._(
      feeTokenAmountModel: feeTokenAmountModel ?? this.feeTokenAmountModel,
      errorBool: errorBool ?? this.errorBool,
      loadingBool: loadingBool ?? this.loadingBool,
      tokenDenominationModel: tokenDenominationModel ?? this.tokenDenominationModel,
      balance: balance ?? this.balance,
      tokenAmountModel: tokenAmountModel ?? this.tokenAmountModel,
      walletAddress: walletAddress ?? this.walletAddress,
    );
  }

  TokenAmountModel? get availableTokenAmountModel {
    if (balance == null) {
      return null;
    } else {
      return balance! - feeTokenAmountModel;
    }
  }

  @override
  List<Object?> get props => <Object?>[tokenDenominationModel, balance, tokenAmountModel, walletAddress];
}
