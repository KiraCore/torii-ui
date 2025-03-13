import 'package:equatable/equatable.dart';
import 'package:torii_client/data/dto/api_kira/query_balance/response/balance.dart';

class QueryBalanceResp extends Equatable {
  final List<Balance> balances;

  const QueryBalanceResp({required this.balances});

  factory QueryBalanceResp.fromJson(Map<String, dynamic> json) {
    List<dynamic> balancesList = json['balances'] != null ? json['balances'] as List<dynamic> : List<dynamic>.empty();

    return QueryBalanceResp(
      balances: balancesList.map((dynamic e) => Balance.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  @override
  List<Object?> get props => <Object?>[balances];
}
