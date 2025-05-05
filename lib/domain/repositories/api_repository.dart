import 'dart:convert';

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

  // TODO: its SEKAI status, not interx right now
  @override
  Future<Response<T>> fetchQueryInterxStatus<T>(ApiRequestModel<void> apiRequestModel) async {
    // try {
    //   print('apiRequestModel.networkUri: ${apiRequestModel.networkUri}');
    //   print('dio: ${Dio().options.headers}');
    //   final Response<T> response = await Dio().post(
    //     apiRequestModel.networkUri,
    //     options: Options(headers: {'Content-Type': 'application/json'}),
    //     data: jsonEncode({
    //       "method": "cosmos",
    //       "data": {"method": "GET", "path": "/cosmos/bank/v1beta1/supply", "payload": {}},
    //     }),
    //   );
    //   print('responseee: $response');
    // } on DioException catch (dioException) {
    //   getIt<Logger>().e('cosmos error: ${apiRequestModel.networkUri}: ${dioException.message}');
    // }
  
    
    try {
      final Response<T> response = await _httpClientManager.post<T>(
        networkUri: apiRequestModel.networkUri,
        path: '', // TODO: remove this, refactor the manager for proxy
        options: Options(headers: {'Content-Type': 'application/json'}),
        body: {
          "method": "cosmos",
          "data": {"method": "POST", "path": "/kira/status", "payload": {}},
        },
      );
      // final Response<T> response = await _httpClientManager.get<T>(
      //   networkUri: apiRequestModel.networkUri,
      //   path: '/api/status',
      // );
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
