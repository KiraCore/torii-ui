import 'package:dio/dio.dart';
import 'package:torii_client/data/api/http_client_manager.dart';
import 'package:torii_client/data/dto/api_kira/broadcast/request/broadcast_req.dart';
import 'package:torii_client/data/dto/api_kira/query_account/request/query_account_req.dart';
import 'package:torii_client/data/dto/api_kira/query_balance/request/query_balance_req.dart';
import 'package:torii_client/data/dto/api_kira/query_execution_fee/request/query_execution_fee_request.dart';
import 'package:torii_client/data/dto/api_kira/query_kira_tokens_aliases/request/query_kira_tokens_aliases_req.dart';
import 'package:torii_client/data/dto/api_request_model.dart';
import 'package:torii_client/utils/exports.dart';

abstract class IApiKiraRepository {
  Future<Response<T>> broadcast<T>(ApiRequestModel<BroadcastReq> apiRequestModel);

  Future<Response<T>> fetchQueryAccount<T>(ApiRequestModel<QueryAccountReq> apiRequestModel);

  Future<Response<T>> fetchQueryBalance<T>(ApiRequestModel<QueryBalanceReq> apiRequestModel);

  Future<Response<T>> fetchQueryExecutionFee<T>(ApiRequestModel<QueryExecutionFeeRequest> apiRequestModel);

  Future<Response<T>> fetchQueryKiraTokensAliases<T>(ApiRequestModel<QueryKiraTokensAliasesReq> apiRequestModel);

  Future<Response<T>> fetchQueryNetworkProperties<T>(ApiRequestModel<void> apiRequestModel);
}

class RemoteApiKiraRepository implements IApiKiraRepository {
  final HttpClientManager _httpClientManager = HttpClientManager();

  @override
  Future<Response<T>> broadcast<T>(ApiRequestModel<BroadcastReq> apiRequestModel) async {
    try {
      final Response<T> response = await _httpClientManager.post<T>(
        body: apiRequestModel.requestData.toJson(),
        networkUri: apiRequestModel.networkUri,
        path: '/api/kira/txs',
      );
      return response;
    } on DioException catch (dioException) {
      getIt<Logger>().e('Cannot fetch broadcast() for URI ${apiRequestModel.networkUri}: ${dioException.message}');
      rethrow;
    }
  }

  @override
  Future<Response<T>> fetchQueryAccount<T>(ApiRequestModel<QueryAccountReq> apiRequestModel) async {
    try {
      final Response<T> response = await _httpClientManager.get<T>(
        networkUri: apiRequestModel.networkUri,
        path: '/api/kira/accounts/${apiRequestModel.requestData.address}',
      );
      return response;
    } on DioException catch (dioException) {
      getIt<Logger>().e(
        'Cannot fetch fetchQueryAccount() for URI ${apiRequestModel.networkUri}: ${dioException.message}',
      );
      rethrow;
    }
  }

  @override
  Future<Response<T>> fetchQueryBalance<T>(ApiRequestModel<QueryBalanceReq> apiRequestModel) async {
    try {
      final Response<T> response = await _httpClientManager.get<T>(
        networkUri: apiRequestModel.networkUri,
        path: '/api/kira/balances/${apiRequestModel.requestData.address}',
        queryParameters: apiRequestModel.requestData.toJson(),
      );
      return response;
    } on DioException catch (dioException) {
      getIt<Logger>().e(
        'Cannot fetch fetchQueryBalance() for URI ${apiRequestModel.networkUri}: ${dioException.message}',
      );
      rethrow;
    }
  }

  @override
  Future<Response<T>> fetchQueryExecutionFee<T>(ApiRequestModel<QueryExecutionFeeRequest> apiRequestModel) async {
    try {
      final Response<T> response = await _httpClientManager.get<T>(
        networkUri: apiRequestModel.networkUri,
        path: '/api/kira/gov/execution_fee',
        queryParameters: apiRequestModel.requestData.toJson(),
      );
      return response;
    } on DioException catch (dioException) {
      getIt<Logger>().e(
        'Cannot fetch fetchQueryDelegations() for URI ${apiRequestModel.networkUri}: ${dioException.message}',
      );
      rethrow;
    }
  }

  @override
  Future<Response<T>> fetchQueryKiraTokensAliases<T>(ApiRequestModel<QueryKiraTokensAliasesReq> apiRequestModel) async {
    try {
      final Response<T> response = await _httpClientManager.get<T>(
        networkUri: apiRequestModel.networkUri,
        path: '/api/kira/tokens/aliases',
        queryParameters: apiRequestModel.requestData.queryParameters,
      );
      return response;
    } on DioException catch (dioException) {
      getIt<Logger>().e(
        'Cannot fetch fetchQueryKiraTokensAliases() for URI ${apiRequestModel.networkUri} ${dioException.message}',
      );
      rethrow;
    }
  }

  @override
  Future<Response<T>> fetchQueryNetworkProperties<T>(ApiRequestModel<void> apiRequestModel) async {
    try {
      final Response<T> response = await _httpClientManager.get<T>(
        networkUri: apiRequestModel.networkUri,
        path: '/api/kira/gov/network_properties',
      );
      return response;
    } on DioException catch (dioException) {
      getIt<Logger>().e(
        'Cannot fetch fetchQueryNetworkProperties() for URI ${apiRequestModel.networkUri} ${dioException.message}',
      );
      rethrow;
    }
  }
}
