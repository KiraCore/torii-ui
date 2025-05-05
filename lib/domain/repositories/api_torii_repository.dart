import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:torii_client/data/api/http_client_manager.dart';
import 'package:torii_client/data/dto/api/query_transactions/request/query_transactions_req.dart';
import 'package:torii_client/data/dto/api_request_model.dart';
import 'package:torii_client/domain/exports.dart';
import 'package:torii_client/utils/exports.dart';
import 'package:torii_client/data/exports.dart';

@injectable
class ApiToriiRepository {
  const ApiToriiRepository(this._httpClientManager);

  final HttpClientManager _httpClientManager;

  Future<Response<T>> fetchPendingTransaction<T>(ApiRequestModel<void> apiRequestModel) async {
    try {
      throw UnimplementedError();
      // final Response<T> response = await _httpClientManager.get<T>(
      //   networkUri: apiRequestModel.networkUri,
      //   path: '/api/torii/transactions',
      // );
      // return response;
    } on DioException catch (dioException) {
      getIt<Logger>().e(
        'Cannot fetch fetchQueryTransactions() for URI ${apiRequestModel.networkUri}: ${dioException.message}',
      );
      rethrow;
    }
  }

  // TODO: test
  Future<Response<T>> fetchTransactionsPerAccount<T>(ApiRequestModel<QueryTransactionsReq> apiRequestModel) async {
    try {
      // TODO: pagination
      final Response<T> response = await _httpClientManager.post(
        networkUri: apiRequestModel.networkUri,
        path: '',
        options: Options(headers: {'Content-Type': 'application/json'}),
        body: {
          "method": "logs",
          "data": {"address": apiRequestModel.requestData.address},
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
