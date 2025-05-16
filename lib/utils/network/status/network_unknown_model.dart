import 'package:torii_client/utils/exports.dart';
import 'package:torii_client/utils/network/app_config.dart';
import 'package:torii_client/utils/network/network_utils.dart';
import 'package:torii_client/utils/network/status/a_network_status_model.dart';

class NetworkUnknownModel extends ANetworkStatusModel {
  const NetworkUnknownModel({
    required super.connectionStatusType,
    required super.lastRefreshDateTime,
    required super.uri,
    super.name,
  }) : super(statusColor: DesignColors.grey1);

  factory NetworkUnknownModel.fromJson(Map<String, dynamic> json) {
    return NetworkUnknownModel(
      connectionStatusType: ConnectionStatusType.disconnected,
      lastRefreshDateTime: DateTime.now(),
      uri: NetworkUtils.parseUrlToInterxUri(json['address'] as String),
      name: json['name'] as String?,
    );
  }

  factory NetworkUnknownModel.fromUri(Uri uri) {
    return NetworkUnknownModel(
      connectionStatusType: ConnectionStatusType.disconnected,
      lastRefreshDateTime: DateTime.now(),
      uri: uri,
    );
  }

  factory NetworkUnknownModel.fromNetworkStatusModel(ANetworkStatusModel networkStatusModel) {
    return NetworkUnknownModel(
      connectionStatusType: networkStatusModel.connectionStatusType,
      lastRefreshDateTime: DateTime.now(),
      uri: networkStatusModel.uri,
      name: networkStatusModel.name,
    );
  }

  @override
  NetworkUnknownModel copyWith({ConnectionStatusType? connectionStatusType, DateTime? lastRefreshDateTime, Uri? uri}) {
    return NetworkUnknownModel(
      connectionStatusType: connectionStatusType ?? this.connectionStatusType,
      lastRefreshDateTime: lastRefreshDateTime,
      uri: uri ?? this.uri,
      name: name,
    );
  }

  NetworkUnknownModel copyWithHttp() {
    return NetworkUnknownModel(
      connectionStatusType: connectionStatusType,
      lastRefreshDateTime: lastRefreshDateTime,
      uri: uri?.replace(scheme: 'http'),
      name: name,
    );
  }

  bool isHttps() {
    return uri?.isScheme('https') ?? false;
  }

  @override
  List<Object?> get props => <Object?>[runtimeType, connectionStatusType, uri, name];
}
