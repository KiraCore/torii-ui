import 'package:equatable/equatable.dart';
import 'package:torii_client/domain/exports.dart';

class PrefixedTokenAmountModel extends Equatable {
  final TokenAmountModel tokenAmountModel;
  final TokenAmountPrefixType tokenAmountPrefixType;

  const PrefixedTokenAmountModel({required this.tokenAmountModel, required this.tokenAmountPrefixType});

  String getAmountAsString() {
    return '${getPrefix()}${tokenAmountModel.getAmountInDefaultDenomination()}';
  }

  String getDenominationName() {
    return tokenAmountModel.tokenAliasModel.defaultTokenDenominationModel.name;
  }

  String getPrefix() {
    if (tokenAmountPrefixType == TokenAmountPrefixType.add) {
      return '+';
    } else {
      return '-';
    }
  }

  @override
  List<Object?> get props => <Object>[tokenAmountModel, tokenAmountPrefixType];

  @override
  String toString() {
    return '${getAmountAsString()} ${getDenominationName()}';
  }
}
