import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:torii_client/data/api/http_client_manager.dart';
import 'package:torii_client/data/dto/api/query_log_txs/query_log_txs_req.dart';
import 'package:torii_client/data/dto/api/query_log_txs/query_log_txs_resp.dart';
import 'package:torii_client/data/dto/api/query_transactions/request/query_transactions_req.dart';
import 'package:torii_client/data/dto/api_request_model.dart';
import 'package:torii_client/domain/exports.dart';
import 'package:torii_client/utils/exports.dart';
import 'package:torii_client/data/exports.dart';

@injectable
class ApiToriiRepository {
  const ApiToriiRepository(this._httpClientManager);

  final HttpClientManager _httpClientManager;

  Future<Response<T>> fetchCosmosTransactionsPerAccount<T>(ApiRequestModel<QueryLogTxsReq> apiRequestModel) async {
    try {
      // TODO: torii has no pagination here
      final Response<T> response = await _httpClientManager.post(
        networkUri: apiRequestModel.networkUri,
        path: '',
        options: Options(headers: {'Content-Type': 'application/json'}),
        body: {
          "method": "logs",
          "data": {
            "collection": "Cosmos",
            "select": {
              "\$or": [
                if (apiRequestModel.requestData.kiraAddress != null)
                  {"messages.from": apiRequestModel.requestData.kiraAddress},
                if (apiRequestModel.requestData.ethAddress != null)
                  {"messages.to": apiRequestModel.requestData.ethAddress},
              ],
            },
            // "options": {
            //   "skip": apiRequestModel.requestData.skip,
            //   "limit": apiRequestModel.requestData.limit,
            //   "count": apiRequestModel.requestData.count,
            //   // todo: fix this
            //   "sort": {"height": apiRequestModel.requestData.sortAsc ? 1 : -1},
            // },
          },
          "metadata": {"token": const String.fromEnvironment('TORII_LOG_ACCESS_TOKEN')},
        },
      );
      return response;
    } on DioException catch (dioException) {
      getIt<Logger>().e('cosmos error: ${apiRequestModel.networkUri}: ${dioException.message}');
      rethrow;
    }
  }

  Future<Response<T>> fetchEthTransactionsPerAccount<T>(ApiRequestModel<QueryLogTxsReq> apiRequestModel) async {
    try {
      // TODO: torii has no pagination here
      final Response<T> response = await _httpClientManager.post(
        networkUri: apiRequestModel.networkUri,
        path: '',
        options: Options(headers: {'Content-Type': 'application/json'}),
        body: {
          "method": "logs",
          "data": {
            "collection": "Ethereum",
            "select": {
              "\$or": [
                if (apiRequestModel.requestData.ethAddress != null)
                  {"From": apiRequestModel.requestData.ethAddress!.toLowerCase()},
                if (apiRequestModel.requestData.kiraAddress != null)
                  // NOTE: recipient
                  {"Input.cyclAddress": apiRequestModel.requestData.kiraAddress},
              ],
            },
            "options": {
              "skip": apiRequestModel.requestData.skip,
              "limit": apiRequestModel.requestData.limit,
              "count": apiRequestModel.requestData.count,
              // todo: fix this
              "sort": {"height": apiRequestModel.requestData.sortAsc ? 1 : -1},
            },
          },
          "metadata": {"token": const String.fromEnvironment('TORII_LOG_ACCESS_TOKEN')},
        },
      );
      return response;
    } on DioException catch (dioException) {
      getIt<Logger>().e('eth error: ${apiRequestModel.networkUri}: ${dioException.message}');
      rethrow;
    }
  }

  // TODO: cache those
  Future<Response<T>> fetchPendingEthTransactions<T>(ApiRequestModel<QueryLogTxsReq> apiRequestModel) async {
    try {
      // TODO: torii has no pagination here
      final Response<T> response = await _httpClientManager.post(
        networkUri: apiRequestModel.networkUri,
        path: '',
        options: Options(headers: {'Content-Type': 'application/json'}),
        body: {
          "method": "logs",
          "data": {
            "collection": "Cosmos",
            "select": {
              "\$or": [
                {"messages.to": apiRequestModel.requestData.ethAddress},
              ],
            },
            "options": {
              "skip": apiRequestModel.requestData.skip,
              "limit": apiRequestModel.requestData.limit,
              "count": apiRequestModel.requestData.count,
              // todo: fix this
              "sort": {"height": apiRequestModel.requestData.sortAsc ? 1 : -1},
            },
          },
          "metadata": {"token": const String.fromEnvironment('TORII_LOG_ACCESS_TOKEN')},
        },
      );
      return response;
    } on DioException catch (dioException) {
      getIt<Logger>().e('cosmos error: ${apiRequestModel.networkUri}: ${dioException.message}');
      rethrow;
    }
  }
}
