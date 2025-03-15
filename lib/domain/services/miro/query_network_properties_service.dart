import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:torii_client/data/dto/api_kira/query_network_properties/response/query_network_properties_resp.dart';
import 'package:torii_client/data/dto/api_request_model.dart';
import 'package:torii_client/domain/exports.dart';
import 'package:torii_client/domain/models/network/network_properties_model.dart';
import 'package:torii_client/domain/repositories/api_kira_repository.dart';
import 'package:torii_client/presentation/network/bloc/network_module_bloc.dart';
import 'package:torii_client/utils/exports.dart';

@injectable
class QueryNetworkPropertiesService {
  final IApiKiraRepository _apiKiraRepository;

  QueryNetworkPropertiesService(this._apiKiraRepository);

  Future<TokenAmountModel> getMinTxFee() async {
    NetworkPropertiesModel networkPropertiesModel = await getNetworkProperties();
    return networkPropertiesModel.minTxFee;
  }

  Future<NetworkPropertiesModel> getNetworkProperties() async {
    Uri networkUri = getIt<NetworkModuleBloc>().state.networkUri;
    Response<dynamic> response = await _apiKiraRepository.fetchQueryNetworkProperties<dynamic>(
      ApiRequestModel<void>(networkUri: networkUri, requestData: null),
    );

    try {
      QueryNetworkPropertiesResp queryNetworkPropertiesResp = QueryNetworkPropertiesResp.fromJson(
        response.data as Map<String, dynamic>,
      );
      return NetworkPropertiesModel.fromDto(queryNetworkPropertiesResp.properties);
    } catch (e) {
      getIt<Logger>().e('QueryNetworkPropertiesService: Cannot parse getNetworkProperties() for URI $networkUri $e');
      rethrow;
    }
  }
}
