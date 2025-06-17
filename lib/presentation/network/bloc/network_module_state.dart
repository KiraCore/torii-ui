import 'package:equatable/equatable.dart';
import 'package:torii_client/utils/network/app_config.dart';
import 'package:torii_client/utils/network/status/a_network_status_model.dart';
import 'package:torii_client/utils/network/status/network_empty_model.dart';

class NetworkModuleState extends Equatable {
  final ANetworkStatusModel networkStatusModel;

  NetworkModuleState.connecting(ANetworkStatusModel networkStatusModel)
    : networkStatusModel = networkStatusModel.copyWith(connectionStatusType: ConnectionStatusType.connecting);

  NetworkModuleState.connected(ANetworkStatusModel networkStatusModel)
    : networkStatusModel = networkStatusModel.copyWith(connectionStatusType: ConnectionStatusType.connected);

  NetworkModuleState.autoConnected(ANetworkStatusModel networkStatusModel)
    : networkStatusModel = networkStatusModel.copyWith(connectionStatusType: ConnectionStatusType.autoConnected);

  NetworkModuleState.disconnected()
    : networkStatusModel = NetworkEmptyModel(connectionStatusType: ConnectionStatusType.disconnected);

  NetworkModuleState.refreshing(ANetworkStatusModel networkStatusModel)
    : networkStatusModel = networkStatusModel.copyWith(
        connectionStatusType: ConnectionStatusType.refreshing,
        lastRefreshDateTime: DateTime.now(),
      );

  bool get isConnecting => networkStatusModel.connectionStatusType.isConnecting;

  bool get isConnected => networkStatusModel.connectionStatusType.isConnected;

  bool get isDisconnected => networkStatusModel.connectionStatusType.isDisconnected;

  bool get isRefreshing => networkStatusModel.connectionStatusType.isRefreshing;

  Uri? get networkUri => networkStatusModel.uri;

  @override
  List<Object?> get props => <Object?>[networkStatusModel];
}
