import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:torii_client/data/dto/coin.dart';
import 'package:torii_client/data/dto/messages/msg_send.dart';
import 'package:torii_client/domain/models/tokens/list/tx_direction_type.dart';
import 'package:torii_client/domain/models/tokens/list/tx_status_type.dart';

class Transaction extends Equatable {
  // TODO: ch_time, cr_time (change_time, create_time)
  // TODO: localize time ???
  final int time;
  final String hash;
  final String status;
  final String direction;
  final String memo;
  final List<Coin> fee;
  // TODO: make MsgSend
  final List<MsgSend> txs;

  // TODO: gas_used, gas_wanted
  const Transaction({
    required this.time,
    required this.hash,
    required this.status,
    required this.direction,
    required this.memo,
    required this.fee,
    required this.txs,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      time: json['time'] as int,
      hash: json['hash'] as String,
      status: json['status'] as String,
      direction: json['direction'] as String,
      memo: json['memo'] as String,
      fee: (json['fee'] as List<dynamic>).map((dynamic e) => Coin.fromJson(e as Map<String, dynamic>)).toList(),
      txs: (json['txs'] as List<dynamic>).map((dynamic e) => MsgSend.fromData(e as Map<String, dynamic>)).toList(),
    );
  }

  factory Transaction.fromKiraLogs(Map<String, dynamic> json, {required bool askingForKira}) {
    final List<MsgSend> txs =
        (json['messages'] as List<dynamic>).map((dynamic e) => MsgSend.fromData(e as Map<String, dynamic>)).toList();

    return Transaction(
      time: json['ch_time'] as int,
      hash: json['hash'] as String,
      // TODO: update status
      status: TxStatusType.confirmed.name,
      direction: askingForKira ? TxDirectionType.outbound.name : TxDirectionType.inbound.name,
      // TODO: memo
      memo: '',
      // TODO: update fee. For now it's always 100 as default
      fee: [Coin(amount: '100', denom: 'uKEX')],
      txs: txs,
    );
  }

  factory Transaction.fromEthLogs(Map<String, dynamic> json, {required bool askingForKira}) {
    return Transaction(
      time: json['ch_time'] as int,
      hash: json['Hash'] as String,
      // TODO: check for pending case
      status: json['Status'] == true ? TxStatusType.confirmed.name : TxStatusType.failed.name,
      direction: askingForKira ? TxDirectionType.inbound.name : TxDirectionType.outbound.name,
      // TODO: memo
      memo: '',
      // TODO: check fee if correct field. For now it's always 0
      fee: [Coin(amount: json['Amount'].toString(), denom: 'uKEX')],
      txs: [
        MsgSend(
          amount: [CosmosCoin(amount: BigInt.parse(json['Input']['amount'].toString()), denom: 'uKEX')],
          fromAddress: json['From'],
          toAddress: json['Input']['cyclAddress'],
          passphrase: '',
        ),
      ],
    );
  }

  @override
  List<Object?> get props => <Object?>[time, hash, status, direction, memo, fee, txs];
}
