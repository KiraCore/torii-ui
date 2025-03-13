import 'package:torii_client/utils/exports.dart';
import 'package:torii_client/utils/network/app_config.dart';
import 'package:torii_client/utils/network/status/online/a_network_online_model.dart';

class NetworkHealthyModel extends ANetworkOnlineModel {
  const NetworkHealthyModel({
    required super.connectionStatusType,
    required super.lastRefreshDateTime,
    required super.networkInfoModel,
    required super.tokenDefaultDenomModel,
    required super.uri,
    super.name,
  }) : super(statusColor: DesignColors.greenStatus1);

  @override
  NetworkHealthyModel copyWith({required ConnectionStatusType connectionStatusType, DateTime? lastRefreshDateTime}) {
    return NetworkHealthyModel(
      connectionStatusType: connectionStatusType,
      lastRefreshDateTime: lastRefreshDateTime ?? this.lastRefreshDateTime!,
      networkInfoModel: networkInfoModel,
      tokenDefaultDenomModel: tokenDefaultDenomModel,
      uri: uri,
      name: name,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    runtimeType,
    connectionStatusType,
    networkInfoModel,
    tokenDefaultDenomModel,
    uri.hashCode,
    name,
  ];
}
