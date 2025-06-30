import 'package:equatable/equatable.dart';
import 'package:torii_client/data/dto/api/query_transactions/response/transaction.dart';

class QueryLogTxsResp extends Equatable {
  final List<Transaction> fromKira;
  final List<Transaction> fromEth;

  const QueryLogTxsResp({required this.fromKira, required this.fromEth});

  factory QueryLogTxsResp.fromJson({
    required List<dynamic> kiraJson,
    required List<dynamic> ethJson,
    required bool askingForKira,
  }) {
    final kiraTxs = kiraJson.map((e) => Transaction.fromKiraLogs(e, askingForKira: askingForKira)).toList();
    final ethTxs = ethJson.map((e) => Transaction.fromEthLogs(e, askingForKira: askingForKira)).toList();
    return QueryLogTxsResp(fromKira: kiraTxs, fromEth: ethTxs);
  }

  @override
  List<Object?> get props => <Object?>[fromKira, fromEth];
}
