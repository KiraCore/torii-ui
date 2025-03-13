import 'package:torii_client/utils/exports.dart';
import 'package:torii_client/utils/network/app_config.dart';
import 'package:torii_client/utils/network/interx_warning_model.dart';
import 'package:torii_client/utils/network/status/online/a_network_online_model.dart';

class NetworkUnhealthyModel extends ANetworkOnlineModel {
  final InterxWarningModel interxWarningModel;

  const NetworkUnhealthyModel({
    required this.interxWarningModel,
    required super.connectionStatusType,
    required super.lastRefreshDateTime,
    required super.networkInfoModel,
    required super.tokenDefaultDenomModel,
    required super.uri,
    super.name,
  }) : super(statusColor: DesignColors.yellowStatus1);

  @override
  NetworkUnhealthyModel copyWith({required ConnectionStatusType connectionStatusType, DateTime? lastRefreshDateTime}) {
    return NetworkUnhealthyModel(
      interxWarningModel: interxWarningModel,
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
    interxWarningModel,
    connectionStatusType,
    networkInfoModel,
    tokenDefaultDenomModel,
    uri.hashCode,
    name,
  ];
}
