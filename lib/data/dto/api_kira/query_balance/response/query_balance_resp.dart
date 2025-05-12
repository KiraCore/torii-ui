import 'package:equatable/equatable.dart';
import 'package:torii_client/data/dto/api_kira/query_balance/response/balance.dart';

class QueryBalanceResp extends Equatable {
  final List<Balance> balances;

  const QueryBalanceResp({required this.balances});

  factory QueryBalanceResp.fromJson(List<dynamic> balances) {
    return QueryBalanceResp(
      balances: balances.map((dynamic e) => Balance.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  @override
  List<Object?> get props => <Object?>[balances];
}
