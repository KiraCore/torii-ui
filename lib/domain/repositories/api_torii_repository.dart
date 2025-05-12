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

  Future<Response<T>> fetchTransactionsPerAccount<T>(ApiRequestModel<QueryTransactionsReq> apiRequestModel) async {
    // TODO: connect to TORII with url given from user
    final uri = Uri.parse(const String.fromEnvironment('TORII_LOG_URL')); //apiRequestModel.networkUri;
    try {
      // TODO: torii has no pagination here
      final Response<T> response = await _httpClientManager.post(
        networkUri: uri,
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
      getIt<Logger>().e('cosmos error: $uri: ${dioException.message}');
      rethrow;
    }
  }
}
