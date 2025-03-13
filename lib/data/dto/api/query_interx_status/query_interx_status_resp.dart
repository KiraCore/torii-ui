import 'package:equatable/equatable.dart';
import 'package:torii_client/data/dto/api/query_interx_status/interx_info.dart';
import 'package:torii_client/data/dto/api/query_interx_status/node_info.dart';
import 'package:torii_client/data/dto/api/query_interx_status/sync_info.dart';

class QueryInterxStatusResp extends Equatable {
  final String id;
  final InterxInfo interxInfo;
  final NodeInfo nodeInfo;
  final SyncInfo syncInfo;

  const QueryInterxStatusResp({
    required this.id,
    required this.interxInfo,
    required this.nodeInfo,
    required this.syncInfo,
  });

  factory QueryInterxStatusResp.fromJson(Map<String, dynamic> json) => QueryInterxStatusResp(
    id: json['id'] as String,
    interxInfo: InterxInfo.fromJson(json['interx_info'] as Map<String, dynamic>),
    nodeInfo: NodeInfo.fromJson(json['node_info'] as Map<String, dynamic>),
    syncInfo: SyncInfo.fromJson(json['sync_info'] as Map<String, dynamic>),
  );

  @override
  List<Object?> get props => <Object?>[id, interxInfo, nodeInfo, syncInfo];
}
