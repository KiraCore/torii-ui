import 'package:torii_client/domain/models/tokens/token_default_denom_model.dart';
import 'package:torii_client/utils/network/app_config.dart';
import 'package:torii_client/utils/network/interx_warning_model.dart';
import 'package:torii_client/utils/network/network_info_model.dart';
import 'package:torii_client/utils/network/status/a_network_status_model.dart';
import 'package:torii_client/utils/network/status/online/network_healthy_model.dart';
import 'package:torii_client/utils/network/status/online/network_unhealthy_model.dart';

abstract class ANetworkOnlineModel extends ANetworkStatusModel {
  final NetworkInfoModel networkInfoModel;
  final TokenDefaultDenomModel tokenDefaultDenomModel;

  const ANetworkOnlineModel({
    required this.networkInfoModel,
    required this.tokenDefaultDenomModel,
    required super.statusColor,
    required super.connectionStatusType,
    required DateTime super.lastRefreshDateTime,
    required super.uri,
    super.name,
  });

  static ANetworkOnlineModel build({
    required NetworkInfoModel networkInfoModel,
    required TokenDefaultDenomModel tokenDefaultDenomModel,
    required ConnectionStatusType connectionStatusType,
    required DateTime lastRefreshDateTime,
    required Uri uri,
    required String name,
  }) {
    InterxWarningModel interxWarningModel = InterxWarningModel.selectWarningType(
      networkInfoModel,
      tokenDefaultDenomModel,
    );

    if (interxWarningModel.hasErrors) {
      return NetworkUnhealthyModel(
        networkInfoModel: networkInfoModel,
        tokenDefaultDenomModel: tokenDefaultDenomModel,
        connectionStatusType: connectionStatusType,
        lastRefreshDateTime: lastRefreshDateTime,
        uri: uri,
        name: name,
        interxWarningModel: interxWarningModel,
      );
    } else {
      return NetworkHealthyModel(
        networkInfoModel: networkInfoModel,
        tokenDefaultDenomModel: tokenDefaultDenomModel,
        connectionStatusType: connectionStatusType,
        lastRefreshDateTime: lastRefreshDateTime,
        uri: uri,
        name: name,
      );
    }
  }

  @override
  ANetworkOnlineModel copyWith({required ConnectionStatusType connectionStatusType, DateTime? lastRefreshDateTime});
}
