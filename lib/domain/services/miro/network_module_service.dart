import 'package:injectable/injectable.dart';
import 'package:torii_client/data/dto/api/query_interx_status/query_interx_status_resp.dart';
import 'package:torii_client/domain/models/tokens/token_default_denom_model.dart';
import 'package:torii_client/domain/services/miro/query_interx_status_service.dart';
import 'package:torii_client/domain/services/miro/query_kira_tokens_aliases_service.dart';
import 'package:torii_client/utils/exports.dart';
import 'package:torii_client/utils/network/app_config.dart';
import 'package:torii_client/utils/network/network_info_model.dart';
import 'package:torii_client/utils/network/status/a_network_status_model.dart';
import 'package:torii_client/utils/network/status/network_offline_model.dart';
import 'package:torii_client/utils/network/status/network_unknown_model.dart';
import 'package:torii_client/utils/network/status/online/a_network_online_model.dart';

@injectable
class NetworkModuleService {
  final QueryInterxStatusService _queryInterxStatusService;
  final QueryKiraTokensAliasesService _queryKiraTokensAliasesService;

  NetworkModuleService(this._queryInterxStatusService, this._queryKiraTokensAliasesService);

  Future<ANetworkStatusModel> getNetworkStatusModel(
    NetworkUnknownModel networkUnknownModel, {
    NetworkUnknownModel? previousNetworkUnknownModel,
  }) async {
    if (networkUnknownModel.uri == null) {
      throw Exception('Network URI is null');
    }
    DateTime lastRefreshDateTime = networkUnknownModel.lastRefreshDateTime ?? DateTime.now();
    try {
      NetworkInfoModel networkInfoModel = await _getNetworkInfoModel(networkUnknownModel);
      TokenDefaultDenomModel tokenDefaultDenomModel = await _queryKiraTokensAliasesService.getTokenDefaultDenomModel(
        networkUnknownModel.uri!,
        forceRequestBool: true,
      );
      return ANetworkOnlineModel.build(
        lastRefreshDateTime: lastRefreshDateTime,
        networkInfoModel: networkInfoModel,
        tokenDefaultDenomModel: tokenDefaultDenomModel,
        connectionStatusType: ConnectionStatusType.disconnected,
        uri: networkUnknownModel.uri!,
        name: networkUnknownModel.name,
      );
    } catch (e) {
      getIt<Logger>().e(
        'NetworkModuleService: Cannot fetch getNetworkStatusModel() for URI ${networkUnknownModel.uri} $e',
      );
      if (networkUnknownModel.isHttps()) {
        return getNetworkStatusModel(
          networkUnknownModel.copyWithHttp(),
          previousNetworkUnknownModel: previousNetworkUnknownModel ?? networkUnknownModel,
        );
      } else {
        return NetworkOfflineModel.fromNetworkStatusModel(
          networkStatusModel: previousNetworkUnknownModel ?? networkUnknownModel,
          connectionStatusType: ConnectionStatusType.disconnected,
          lastRefreshDateTime: lastRefreshDateTime,
        );
      }
    }
  }

  Future<NetworkInfoModel> _getNetworkInfoModel(NetworkUnknownModel networkUnknownModel) async {
    if (networkUnknownModel.uri == null) {
      throw Exception('Network URI is null');
    }
    QueryInterxStatusResp queryInterxStatusResp = await _queryInterxStatusService.getQueryInterxStatusResp(
      networkUnknownModel.uri!,
      forceRequestBool: true,
    );
    return NetworkInfoModel.fromDto(queryInterxStatusResp);
  }
}
