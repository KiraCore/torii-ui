import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:torii_client/data/api/interx_headers.dart';
import 'package:torii_client/data/dto/api/query_transactions/request/query_transactions_req.dart';
import 'package:torii_client/data/dto/api/query_transactions/response/query_transactions_resp.dart';
import 'package:torii_client/data/dto/api_kira/query_account/request/query_account_req.dart';
import 'package:torii_client/data/dto/api_kira/query_account/response/query_account_resp.dart';
import 'package:torii_client/data/dto/api_request_model.dart';
import 'package:torii_client/domain/models/page_data.dart';
import 'package:torii_client/domain/models/tokens/list/tx_list_item_model.dart';
import 'package:torii_client/domain/models/transaction/tx_remote_info_model.dart';
import 'package:torii_client/domain/repositories/api_kira_repository.dart';
import 'package:torii_client/domain/repositories/api_torii_repository.dart';
import 'package:torii_client/presentation/network/bloc/network_module_bloc.dart';
import 'package:torii_client/utils/exports.dart';

@injectable
class ToriiLogService {
  final ApiToriiRepository _repository;
  final NetworkModuleBloc _networkModuleBloc;

  ToriiLogService(this._repository, this._networkModuleBloc);

  Future<PageData<TxListItemModel>> fetchTransactionsPerAccount(String accountAddress) async {
    Uri? networkUri = _networkModuleBloc.state.networkUri;
    if (networkUri == null) {
      throw Exception('Network URI is null');
    }
    final queryTransactionsReq = QueryTransactionsReq(address: accountAddress, limit: 20, offset: 0, pageSize: 20);
    try {
      Response<dynamic> response = await _repository.fetchTransactionsPerAccount<dynamic>(
        ApiRequestModel<QueryTransactionsReq>(
          networkUri: networkUri,
          requestData: queryTransactionsReq,
          forceRequestBool: true,
        ),
      );

      QueryTransactionsResp queryTransactionsResp = QueryTransactionsResp.fromJson(
        response.data as Map<String, dynamic>,
      );
      List<TxListItemModel> txListItemModelList =
          queryTransactionsResp.transactions.map(TxListItemModel.fromDto).toList();

      // TODO: interxHeaders
      // InterxHeaders interxHeaders = InterxHeaders.fromHeaders(response.headers);

      return PageData<TxListItemModel>(
        listItems: txListItemModelList,
        isLastPage: txListItemModelList.length < queryTransactionsReq.limit!,
        // TODO: interxHeaders
        blockDateTime: DateTime.now(),
        cacheExpirationDateTime: DateTime.now(),
      );
    } catch (e) {
      getIt<Logger>().e('ToriiLogService: Cannot parse fetchTransactionsPerAccount() for URI $networkUri $e');
      rethrow;
    }
  }
}
