import 'package:equatable/equatable.dart';
import 'package:torii_client/data/dto/api_kira/broadcast/response/broadcast_tx.dart';

class BroadcastResp extends Equatable {
  final int code;
  final String codespace;
  final String hash;
  final dynamic data;
  final String log;

  const BroadcastResp({
    required this.hash,
    required this.code,
    required this.codespace,
    required this.data,
    required this.log,
  });

  factory BroadcastResp.fromJson(Map<String, dynamic> json) {
    return BroadcastResp(
      hash: json['hash'] as String,
      code: json['code'] as int,
      codespace: json['codespace'] as String,
      data: json['data'] as dynamic,
      log: json['log'] as String,
    );
  }

  @override
  List<Object?> get props => <Object?>[hash, code, codespace, data, log];
}
