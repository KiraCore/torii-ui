import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:torii_client/data/api/interx_headers.dart';
import 'package:torii_client/data/dto/api/query_transactions/request/query_transactions_req.dart';
import 'package:torii_client/data/dto/api/query_transactions/response/query_transactions_resp.dart';
import 'package:torii_client/data/dto/api_request_model.dart';
import 'package:torii_client/domain/models/page_data.dart';
import 'package:torii_client/domain/models/tokens/list/tx_list_item_model.dart';
import 'package:torii_client/domain/repositories/api_repository.dart';
import 'package:torii_client/presentation/network/bloc/network_module_bloc.dart';
import 'package:torii_client/utils/exports.dart';

@injectable
class QueryTransactionsService {
  final IApiRepository _apiRepository;

  QueryTransactionsService(this._apiRepository);

  Future<PageData<TxListItemModel>> getTransactionList(
    QueryTransactionsReq queryTransactionsReq, {
    bool forceRequestBool = false,
  }) async {
    Uri? networkUri = getIt<NetworkModuleBloc>().state.networkUri;
    if (networkUri == null) {
      throw Exception('Network URI is null');
    }
    Response<dynamic> response = await _apiRepository.fetchQueryTransactions<dynamic>(
      ApiRequestModel<QueryTransactionsReq>(
        networkUri: networkUri,
        requestData: queryTransactionsReq,
        forceRequestBool: forceRequestBool,
      ),
    );

    try {
      QueryTransactionsResp queryTransactionsResp = QueryTransactionsResp.fromJson(
        response.data as Map<String, dynamic>,
      );
      List<TxListItemModel> txListItemModelList =
          queryTransactionsResp.transactions.map(TxListItemModel.fromDto).toList();

      InterxHeaders interxHeaders = InterxHeaders.fromHeaders(response.headers);

      return PageData<TxListItemModel>(
        listItems: txListItemModelList,
        isLastPage: txListItemModelList.length < queryTransactionsReq.limit!,
        blockDateTime: interxHeaders.blockDateTime,
        cacheExpirationDateTime: interxHeaders.cacheExpirationDateTime,
      );
    } catch (e) {
      getIt<Logger>().e('QueryTransactionsService: Cannot parse getTransactionList() for URI $networkUri $e');
      rethrow;
    }
  }
}
