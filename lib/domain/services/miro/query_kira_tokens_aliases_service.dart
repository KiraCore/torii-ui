import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:torii_client/data/dto/api_kira/query_kira_tokens_aliases/request/query_kira_tokens_aliases_req.dart';
import 'package:torii_client/data/dto/api_kira/query_kira_tokens_aliases/response/query_kira_tokens_aliases_resp.dart';
import 'package:torii_client/data/dto/api_kira/query_kira_tokens_aliases/response/token_alias.dart';
import 'package:torii_client/data/dto/api_request_model.dart';
import 'package:torii_client/domain/models/tokens/token_alias_model.dart';
import 'package:torii_client/domain/models/tokens/token_default_denom_model.dart';
import 'package:torii_client/domain/repositories/api_kira_repository.dart';
import 'package:torii_client/presentation/network/bloc/network_module_bloc.dart';
import 'package:torii_client/utils/exports.dart';

@injectable
class QueryKiraTokensAliasesService {
  final IApiKiraRepository _apiKiraRepository;

  QueryKiraTokensAliasesService(this._apiKiraRepository);

  // Also, dynamic denomination is postponed for an unknown period of time.
  static const QueryKiraTokensAliasesResp _defaultAliases = QueryKiraTokensAliasesResp(
    tokenAliases: <TokenAlias>[
      TokenAlias(
        decimals: 0,
        denoms: <String>['KEX'],
        name: 'KEX',
        symbol: 'KEX',
        // TODO(Mykyta): make nullable
        icon: '',
        // TODO(Mykyta): make int, and get from api, but in another model
        amount: '0',
      ),
      TokenAlias(
        decimals: 6,
        denoms: <String>['ukex'],
        name: 'ukex',
        symbol: 'ukex',
        // TODO(Mykyta): make nullable
        icon: '',
        // TODO(Mykyta): make int, and get from api, but in another model
        amount: '0',
      ),
      TokenAlias(
        decimals: 6,
        denoms: <String>['v1/ukex'],
        name: 'v1/ukex',
        symbol: 'v1/ukex',
        // TODO(Mykyta): make nullable
        icon: '',
        // TODO(Mykyta): make int, and get from api, but in another model
        amount: '0',
      ),
    ],
    defaultDenom: 'KEX',
    bech32Prefix: 'kira',
  );

  Future<List<TokenAliasModel>> getTokenAliasModels() async {
    QueryKiraTokensAliasesResp queryKiraTokensAliasesResp = _defaultAliases;
    // Uri networkUri = getIt<NetworkModuleBloc>().state.networkUri;
    // Response<dynamic> response = await _apiKiraRepository.fetchQueryKiraTokensAliases<dynamic>(
    //   ApiRequestModel<QueryKiraTokensAliasesReq>(
    //     networkUri: networkUri,
    //     requestData: const QueryKiraTokensAliasesReq(),
    //   ),
    // );

    // try {
    //   QueryKiraTokensAliasesResp queryKiraTokensAliasesResp = QueryKiraTokensAliasesResp.fromJson(
    //     response.data as Map<String, dynamic>,
    //   );
      return queryKiraTokensAliasesResp.tokenAliases.map(TokenAliasModel.fromDto).toList();
    // } catch (e) {
    //   getIt<Logger>().e('QueryKiraTokensAliasesService: Cannot parse getTokenAliasModels() for URI $networkUri $e');
    //   rethrow;
    // }
  }

  Future<TokenDefaultDenomModel> getTokenDefaultDenomModel(Uri networkUri, {bool forceRequestBool = false}) async {
    QueryKiraTokensAliasesResp queryKiraTokensAliasesResp = _defaultAliases;
    return TokenDefaultDenomModel(
      // TODO(Mykyta): useless var ?? valuesFromNetworkExistBool
      valuesFromNetworkExistBool: true,
      bech32AddressPrefix: queryKiraTokensAliasesResp.bech32Prefix,
      defaultTokenAliasModel: await _getAliasByTokenName(queryKiraTokensAliasesResp.defaultDenom),
    );
    // TODO: refactor
    // TokenDefaultDenomModel initialTokenDefaultDenomModel = await _getTokenDefaultDenom(
    //   networkUri,
    //   forceRequestBool: forceRequestBool,
    // );
    // try {
    //   TokenAliasModel defaultTokenAliasModel = await _getAliasByTokenName(
    //     initialTokenDefaultDenomModel.defaultTokenAliasModel!.name,
    //     networkUri: networkUri,
    //     forceRequestBool: forceRequestBool,
    //   );
    // return TokenDefaultDenomModel(
    //   valuesFromNetworkExistBool: true,
    //   bech32AddressPrefix: initialTokenDefaultDenomModel.bech32AddressPrefix,
    //   defaultTokenAliasModel: defaultTokenAliasModel,
    // );
    // } catch (e) {
    //   return initialTokenDefaultDenomModel;
    // }
  }

  Future<TokenDefaultDenomModel> _getTokenDefaultDenom(Uri networkUri, {bool forceRequestBool = false}) async {
    Response<dynamic> response = await _apiKiraRepository.fetchQueryKiraTokensAliases<dynamic>(
      ApiRequestModel<QueryKiraTokensAliasesReq>(
        networkUri: networkUri,
        // get only "default_denom" and "bech32_prefix", 0 records in "token_aliases_data" for quicker response
        requestData: const QueryKiraTokensAliasesReq(offset: 0, limit: 0),
        forceRequestBool: forceRequestBool,
      ),
    );

    try {
      QueryKiraTokensAliasesResp queryKiraTokensAliasesResp = QueryKiraTokensAliasesResp.fromJson(
        response.data as Map<String, dynamic>,
      );
      return TokenDefaultDenomModel.fromDto(queryKiraTokensAliasesResp);
    } catch (e) {
      return TokenDefaultDenomModel.empty();
    }
  }

  Future<TokenAliasModel> _getAliasByTokenName(
    String tokenName, {
    Uri? networkUri,
    bool forceRequestBool = false,
  }) async {
    QueryKiraTokensAliasesResp queryKiraTokensAliasesResp = _defaultAliases;
    return TokenAliasModel.fromDto(
      queryKiraTokensAliasesResp.tokenAliases.firstWhere(
        (TokenAlias alias) => alias.name == tokenName,
        orElse: () => queryKiraTokensAliasesResp.tokenAliases.first,
      ),
    );
    // networkUri ??= getIt<NetworkModuleBloc>().state.networkUri;
    // Response<dynamic> response = await _apiKiraRepository.fetchQueryKiraTokensAliases<dynamic>(
    //   ApiRequestModel<QueryKiraTokensAliasesReq>(
    //     networkUri: networkUri,
    //     requestData: QueryKiraTokensAliasesReq(tokens: <String>[tokenName]),
    //     forceRequestBool: forceRequestBool,
    //   ),
    // );

    // try {
    //   QueryKiraTokensAliasesResp queryKiraTokensAliasesResp = QueryKiraTokensAliasesResp.fromJson(
    //     response.data as Map<String, dynamic>,
    //   );
    //   return TokenAliasModel.fromDto(queryKiraTokensAliasesResp.tokenAliases.first);
    // } catch (e) {
    //   getIt<Logger>().e('QueryKiraTokensAliasesService: Cannot parse getAliasByTokenName() for URI $networkUri $e');
    //   rethrow;
    // }
  }
}
