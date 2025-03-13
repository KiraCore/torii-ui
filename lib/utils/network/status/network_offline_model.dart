import 'package:torii_client/utils/exports.dart';
import 'package:torii_client/utils/network/app_config.dart';
import 'package:torii_client/utils/network/status/a_network_status_model.dart';

class NetworkOfflineModel extends ANetworkStatusModel {
  const NetworkOfflineModel({
    required super.connectionStatusType,
    required DateTime super.lastRefreshDateTime,
    required super.uri,
    super.name,
  }) : super(statusColor: DesignColors.redStatus1);

  factory NetworkOfflineModel.fromNetworkStatusModel({
    required ANetworkStatusModel networkStatusModel,
    required ConnectionStatusType connectionStatusType,
    required DateTime lastRefreshDateTime,
  }) {
    return NetworkOfflineModel(
      connectionStatusType: connectionStatusType,
      lastRefreshDateTime: lastRefreshDateTime,
      uri: networkStatusModel.uri,
      name: networkStatusModel.name,
    );
  }

  @override
  NetworkOfflineModel copyWith({
    required ConnectionStatusType connectionStatusType,
    DateTime? lastRefreshDateTime,
    Uri? uri,
  }) {
    return NetworkOfflineModel(
      connectionStatusType: connectionStatusType,
      lastRefreshDateTime: lastRefreshDateTime ?? DateTime.now(),
      uri: uri ?? this.uri,
      name: name,
    );
  }

  @override
  List<Object?> get props => <Object?>[runtimeType, connectionStatusType, uri.hashCode, name];
}
