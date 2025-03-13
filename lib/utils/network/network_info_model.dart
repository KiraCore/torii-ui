import 'package:equatable/equatable.dart';
import 'package:torii_client/data/dto/api/query_interx_status/query_interx_status_resp.dart';

class NetworkInfoModel extends Equatable {
  final String chainId;
  final String interxVersion;
  final int latestBlockHeight;
  final DateTime latestBlockTime;

  const NetworkInfoModel({
    required this.chainId,
    required this.interxVersion,
    required this.latestBlockHeight,
    required this.latestBlockTime,
  });

  factory NetworkInfoModel.fromDto(QueryInterxStatusResp queryInterxStatusResp) {
    return NetworkInfoModel(
      chainId: queryInterxStatusResp.interxInfo.chainId,
      interxVersion: queryInterxStatusResp.interxInfo.version,
      latestBlockHeight: int.parse(queryInterxStatusResp.syncInfo.latestBlockHeight),
      latestBlockTime: DateTime.parse(queryInterxStatusResp.syncInfo.latestBlockTime),
    );
  }

  @override
  List<Object?> get props => <Object?>[chainId, interxVersion, latestBlockHeight];
}
