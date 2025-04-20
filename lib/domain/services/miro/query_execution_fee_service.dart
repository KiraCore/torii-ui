import 'package:decimal/decimal.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:torii_client/data/dto/api_kira/query_execution_fee/request/query_execution_fee_request.dart';
import 'package:torii_client/data/dto/api_kira/query_execution_fee/response/query_execution_fee_response.dart';
import 'package:torii_client/data/dto/api_request_model.dart';
import 'package:torii_client/domain/exports.dart';
import 'package:torii_client/domain/repositories/api_kira_repository.dart';
import 'package:torii_client/domain/services/miro/query_network_properties_service.dart';
import 'package:torii_client/presentation/network/bloc/network_module_bloc.dart';
import 'package:torii_client/utils/exports.dart';

@injectable
class QueryExecutionFeeService {
  final IApiKiraRepository _apiKiraRepository;
  final QueryNetworkPropertiesService _queryNetworkPropertiesService;

  QueryExecutionFeeService(this._apiKiraRepository, this._queryNetworkPropertiesService);

  Future<TokenAmountModel> getExecutionFeeForMessage(String messageName) async {
    Uri? networkUri = getIt<NetworkModuleBloc>().state.networkUri;
    if (networkUri == null) {
      throw Exception('Network URI is null');
    }
    try {
      Response<dynamic> response = await _apiKiraRepository.fetchQueryExecutionFee<dynamic>(
        ApiRequestModel<QueryExecutionFeeRequest>(
          networkUri: networkUri,
          requestData: QueryExecutionFeeRequest(message: messageName),
        ),
      );

      QueryExecutionFeeResponse queryExecutionFeeResponse = QueryExecutionFeeResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
      TokenAmountModel feeTokenAmountModel = TokenAmountModel(
        defaultDenominationAmount: Decimal.parse(queryExecutionFeeResponse.fee.executionFee),
        tokenAliasModel: getIt<NetworkModuleBloc>().tokenDefaultDenomModel.defaultTokenAliasModel!,
      );
      return feeTokenAmountModel;
    } catch (_) {
      getIt<Logger>().e('Fee for $messageName transaction type is not set. Fetching default fee');
    }
    return _queryNetworkPropertiesService.getMinTxFee();
  }
}
