import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:torii_client/data/dto/api/query_interx_status/query_interx_status_resp.dart';
import 'package:torii_client/data/dto/api_request_model.dart';
import 'package:torii_client/domain/repositories/api_repository.dart';
import 'package:torii_client/utils/exports.dart';

@injectable
class QueryInterxStatusService {
  final IApiRepository _apiRepository;

  QueryInterxStatusService(this._apiRepository);

  Future<QueryInterxStatusResp> getQueryInterxStatusResp(Uri networkUri, {bool forceRequestBool = false}) async {
    Response<dynamic> response = await _apiRepository.fetchQueryInterxStatus<dynamic>(
      ApiRequestModel<void>(networkUri: networkUri, requestData: null, forceRequestBool: forceRequestBool),
    );

    try {
      QueryInterxStatusResp queryInterxStatusResp = QueryInterxStatusResp.fromJson(
        response.data as Map<String, dynamic>,
      );
      return queryInterxStatusResp;
    } catch (e) {
      getIt<Logger>().e('QueryInterxStatusService: Cannot parse getQueryInterxStatusResp() for URI $networkUri $e');
      rethrow;
    }
  }
}
