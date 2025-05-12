import 'package:decimal/decimal.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:torii_client/data/api/interx_headers.dart';
import 'package:torii_client/data/dto/api_kira/query_balance/request/query_balance_req.dart';
import 'package:torii_client/data/dto/api_kira/query_balance/response/balance.dart';
import 'package:torii_client/data/dto/api_kira/query_balance/response/query_balance_resp.dart';
import 'package:torii_client/data/dto/api_request_model.dart';
import 'package:torii_client/domain/exports.dart';
import 'package:torii_client/domain/models/page_data.dart';
import 'package:torii_client/domain/repositories/api_kira_repository.dart';
import 'package:torii_client/domain/services/miro/query_kira_tokens_aliases_service.dart';
import 'package:torii_client/presentation/network/bloc/network_module_bloc.dart';
import 'package:torii_client/utils/exports.dart';

@injectable
class QueryBalanceService {
  final IApiKiraRepository _apiKiraRepository;

  QueryBalanceService(this._apiKiraRepository);

  Future<TokenAmountModel> getBalanceByToken(AWalletAddress walletAddress, TokenAliasModel tokenAliasModel) async {
    // TODO(dominik): Temporary solution, should be replaced with a proper query to INTERX
    PageData<TokenAmountModel> allBalancesPageData = await getTokenAmountModelList(
      QueryBalanceReq(address: walletAddress.address, offset: 0, limit: 500),
    );
    return allBalancesPageData.listItems.firstWhere((TokenAmountModel balance) {
      return balance.tokenAliasModel == tokenAliasModel;
    }, orElse: () => TokenAmountModel.zero(tokenAliasModel: tokenAliasModel));
  }

  Future<PageData<TokenAmountModel>> getTokenAmountModelList(
    QueryBalanceReq queryBalanceReq, {
    bool forceRequestBool = false,
  }) async {
    Uri? networkUri = getIt<NetworkModuleBloc>().state.networkUri;
    if (networkUri == null) {
      throw Exception('Network URI is null');
    }

    Response<dynamic> response = await _apiKiraRepository.fetchQueryBalance<dynamic>(
      ApiRequestModel<QueryBalanceReq>(
        networkUri: networkUri,
        requestData: queryBalanceReq,
        forceRequestBool: forceRequestBool,
      ),
    );

    try {
      QueryBalanceResp queryBalanceResp = QueryBalanceResp.fromJson(response.data as List<dynamic>);
      List<TokenAmountModel> balanceList = await _buildTokenAmountModels(queryBalanceResp);

      // TODO: interx headers
      // InterxHeaders interxHeaders = InterxHeaders.fromHeaders(response.headers);

      return PageData<TokenAmountModel>(
        listItems: balanceList,
        isLastPage: balanceList.length < queryBalanceReq.limit!,
        blockDateTime: DateTime.now(), //interxHeaders.blockDateTime,
        cacheExpirationDateTime: DateTime.now(), //interxHeaders.cacheExpirationDateTime,
      );
    } catch (e) {
      getIt<Logger>().e('QueryBalanceService: Cannot parse getTokenAmountModelList() for URI $networkUri $e');
      rethrow;
    }
  }

  Future<List<TokenAmountModel>> _buildTokenAmountModels(QueryBalanceResp queryBalanceResp) async {
    QueryKiraTokensAliasesService queryKiraTokensAliasesService = getIt<QueryKiraTokensAliasesService>();
    List<TokenAliasModel> tokenAliasModels = await queryKiraTokensAliasesService.getTokenAliasModels();

    List<TokenAmountModel> balanceList = List<TokenAmountModel>.empty(growable: true);
    for (Balance balance in queryBalanceResp.balances) {
      TokenAliasModel tokenAliasModel = tokenAliasModels.firstWhere((TokenAliasModel e) {
        return e.defaultTokenDenominationModel.name == balance.denom;
      }, orElse: () => TokenAliasModel.local(balance.denom));

      TokenAmountModel tokenAmountModel = TokenAmountModel(
        defaultDenominationAmount: Decimal.parse(balance.amount),
        tokenAliasModel: tokenAliasModel,
      );
      balanceList.add(tokenAmountModel);
    }
    return balanceList;
  }
}
