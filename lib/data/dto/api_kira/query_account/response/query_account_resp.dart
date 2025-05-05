import 'package:equatable/equatable.dart';
import 'package:torii_client/data/dto/api/query_interx_status/pub_key.dart';

class QueryAccountResp extends Equatable {
  final String type;
  final String accountNumber;
  final String address;
  final PubKey? pubKey;
  final String? sequence;

  const QueryAccountResp({
    required this.type,
    required this.accountNumber,
    required this.address,
    this.pubKey,
    this.sequence,
  });

  factory QueryAccountResp.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> accountJson = json['account'] as Map<String, dynamic>;

    dynamic pubKeyValue = accountJson['pub_key'];
    Map<String, dynamic>? pubKeyJson = pubKeyValue is Map<String, dynamic> ? pubKeyValue : null;

    return QueryAccountResp(
      type: accountJson['@type'] as String,
      accountNumber: accountJson['accountNumber'] as String,
      address: accountJson['address'] as String,
      pubKey: pubKeyJson != null ? PubKey.fromJson(pubKeyJson) : null,
      sequence: accountJson['sequence'] as String?,
    );
  }

  @override
  List<Object?> get props => <Object?>[type, accountNumber, address, pubKey, sequence];
}
