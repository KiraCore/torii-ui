import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:torii_client/data/api/http_client_manager.dart';
import 'package:torii_client/data/dto/api/query_transactions/request/query_transactions_req.dart';
import 'package:torii_client/data/dto/api_request_model.dart';
import 'package:torii_client/utils/exports.dart';

abstract class IApiRepository {
  Future<Response<T>> fetchDashboard<T>(ApiRequestModel<void> apiRequestModel);

  Future<Response<T>> fetchQueryInterxStatus<T>(ApiRequestModel<void> apiRequestModel);

  Future<Response<T>> fetchQueryTransactions<T>(ApiRequestModel<QueryTransactionsReq> apiRequestModel);
}

@Injectable(as: IApiRepository)
class RemoteApiRepository implements IApiRepository {
  final HttpClientManager _httpClientManager;

  RemoteApiRepository(this._httpClientManager);

  @override
  Future<Response<T>> fetchDashboard<T>(ApiRequestModel<void> apiRequestModel) async {
    try {
      final Response<T> response = await _httpClientManager.get<T>(
        networkUri: apiRequestModel.networkUri,
        path: '/api/dashboard',
      );
      return response;
    } on DioException catch (dioException) {
      getIt<Logger>().e('Cannot fetch fetchDashboard() for URI ${apiRequestModel.networkUri}: ${dioException.message}');
      rethrow;
    }
  }

  @override
  Future<Response<T>> fetchQueryInterxStatus<T>(ApiRequestModel<void> apiRequestModel) async {
    try {
      final Response<T> response = await _httpClientManager.get<T>(
        networkUri: apiRequestModel.networkUri,
        path: '/api/status',
      );
      return response;
    } on DioException catch (dioException) {
      getIt<Logger>().e(
        'Cannot fetch fetchQueryInterxStatus() for URI ${apiRequestModel.networkUri}: ${dioException.message}',
      );
      rethrow;
    }
  }

  @override
  Future<Response<T>> fetchQueryTransactions<T>(ApiRequestModel<QueryTransactionsReq> apiRequestModel) async {
    try {
      final Response<T> response = await _httpClientManager.get<T>(
        networkUri: apiRequestModel.networkUri,
        path: '/api/transactions',
        queryParameters: apiRequestModel.requestData.toJson(),
      );
      return response;
    } on DioException catch (dioException) {
      getIt<Logger>().e(
        'Cannot fetch fetchQueryTransactions() for URI ${apiRequestModel.networkUri}: ${dioException.message}',
      );
      rethrow;
    }
  }
}
