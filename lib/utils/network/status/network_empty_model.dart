import 'package:torii_client/utils/exports.dart';
import 'package:torii_client/utils/network/app_config.dart';
import 'package:torii_client/utils/network/status/a_network_status_model.dart';

class NetworkEmptyModel extends ANetworkStatusModel {
  NetworkEmptyModel({required super.connectionStatusType}) : super(uri: null, statusColor: DesignColors.redStatus1);

  @override
  NetworkEmptyModel copyWith({required ConnectionStatusType connectionStatusType, DateTime? lastRefreshDateTime}) {
    return NetworkEmptyModel(connectionStatusType: connectionStatusType);
  }

  @override
  List<Object?> get props => <Object?>[runtimeType, connectionStatusType, uri.hashCode, name];
}
