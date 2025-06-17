import 'package:equatable/equatable.dart';
import 'package:torii_client/data/dto/api/query_transactions/response/transaction.dart';

class QueryLogTxsResp extends Equatable {
  final List<Transaction> fromKira;
  final List<Transaction> fromEth;

  const QueryLogTxsResp({required this.fromKira, required this.fromEth});

  factory QueryLogTxsResp.fromJson(Map<String, dynamic> json, {required bool askingForKira}) {
    final kiraTxs = json['cosmos']['result'] as List<dynamic>? ?? [];
    final ethTxs = json['ethereum']['result'] as List<dynamic>? ?? [];
    return QueryLogTxsResp(
      fromKira: kiraTxs.map((e) => Transaction.fromKiraLogs(e, askingForKira: askingForKira)).toList(),
      fromEth: ethTxs.map((e) => Transaction.fromEthLogs(e, askingForKira: askingForKira)).toList(),
    );
  }

  @override
  List<Object?> get props => <Object?>[fromKira, fromEth];
}
