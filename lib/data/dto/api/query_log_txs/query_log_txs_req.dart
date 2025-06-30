import 'package:equatable/equatable.dart';

class QueryLogTxsReq extends Equatable {
  final String? kiraAddress;
  final String? ethAddress;
  final int? skip;
  final int? limit;
  final int? count;
  final bool sortAsc;

  const QueryLogTxsReq({this.kiraAddress, this.ethAddress, this.skip, this.limit, this.count, this.sortAsc = true});

  @override
  List<Object?> get props => <Object?>[kiraAddress, ethAddress, skip, limit, count, sortAsc];
}
