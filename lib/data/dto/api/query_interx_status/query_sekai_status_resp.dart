import 'package:equatable/equatable.dart';
import 'package:torii_client/data/dto/api/query_interx_status/node_info.dart';
import 'package:torii_client/data/dto/api/query_interx_status/sync_info.dart';
import 'package:torii_client/data/dto/api/query_interx_status/validator_info.dart';

class QuerySekaiStatusResp extends Equatable {
  final ValidatorInfo validatorInfo;
  final NodeInfo nodeInfo;
  final SyncInfo syncInfo;

  const QuerySekaiStatusResp({required this.validatorInfo, required this.nodeInfo, required this.syncInfo});

  factory QuerySekaiStatusResp.fromJson(Map<String, dynamic> json) => QuerySekaiStatusResp(
    validatorInfo: ValidatorInfo.fromJson(json['validator_info'] as Map<String, dynamic>),
    nodeInfo: NodeInfo.fromJson(json['node_info'] as Map<String, dynamic>),
    syncInfo: SyncInfo.fromJson(json['sync_info'] as Map<String, dynamic>),
  );

  @override
  List<Object?> get props => <Object?>[validatorInfo, nodeInfo, syncInfo];
}
