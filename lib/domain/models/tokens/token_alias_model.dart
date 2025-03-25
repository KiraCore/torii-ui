import 'package:equatable/equatable.dart';
import 'package:torii_client/data/dto/api_kira/query_kira_tokens_aliases/response/token_alias.dart';
import 'package:torii_client/domain/exports.dart';

class TokenAliasModel extends Equatable {
  final String name;
  final TokenDenominationModel defaultTokenDenominationModel;
  final TokenDenominationModel baseTokenDenominationModel;
  final String? icon;

  const TokenAliasModel({
    required this.name,
    required this.defaultTokenDenominationModel,
    required this.baseTokenDenominationModel,
    this.icon,
  });

  factory TokenAliasModel.eth() {
    return TokenAliasModel(
      name: 'wei',
      defaultTokenDenominationModel: TokenDenominationModel(name: 'wei', decimals: 0),
      baseTokenDenominationModel: TokenDenominationModel(name: 'ETH', decimals: 18),
    );
  }

  factory TokenAliasModel.kex() {
    return TokenAliasModel(
      name: 'ukex',
      defaultTokenDenominationModel: TokenDenominationModel(name: 'ukex', decimals: 0),
      baseTokenDenominationModel: TokenDenominationModel(name: 'KEX', decimals: 8),
    );
  }

  factory TokenAliasModel.local(String name) {
    if (name.toLowerCase() == 'wei') {
      return TokenAliasModel.eth();
    } else if (name.toLowerCase() == 'ukex') {
      return TokenAliasModel.kex();
    } else {
      return TokenAliasModel(
        name: name,
        defaultTokenDenominationModel: TokenDenominationModel(name: name, decimals: 0),
        baseTokenDenominationModel: TokenDenominationModel(name: name, decimals: 0),
      );
    }
  }

  factory TokenAliasModel.fromDto(TokenAlias tokenAlias) {
    TokenDenominationModel networkTokenDenominationModel = TokenDenominationModel(
      name: tokenAlias.symbol,
      decimals: tokenAlias.decimals,
    );
    TokenDenominationModel defaultTokenDenominationModel =
        tokenAlias.denoms.isNotEmpty
            ? TokenDenominationModel(name: tokenAlias.denoms.first, decimals: 0)
            : networkTokenDenominationModel;
    TokenDenominationModel baseTokenDenominationModel = networkTokenDenominationModel;
    if (tokenAlias.name.toLowerCase() == 'wei') {
      baseTokenDenominationModel = TokenDenominationModel(name: 'ETH', decimals: 18);
    } else if (tokenAlias.name.toLowerCase() == 'ukex') {
      baseTokenDenominationModel = TokenDenominationModel(name: 'KEX', decimals: 8);
    }

    return TokenAliasModel(
      name: tokenAlias.name,
      icon: tokenAlias.icon,
      baseTokenDenominationModel: baseTokenDenominationModel,
      defaultTokenDenominationModel: defaultTokenDenominationModel,
    );
  }

  List<TokenDenominationModel> get tokenDenominations {
    Set<TokenDenominationModel> availableTokenDenominationModelSet = <TokenDenominationModel>{
      baseTokenDenominationModel,
      defaultTokenDenominationModel,
    };
    return availableTokenDenominationModelSet.toList();
  }

  @override
  List<Object?> get props => <Object>[defaultTokenDenominationModel, baseTokenDenominationModel];
}
