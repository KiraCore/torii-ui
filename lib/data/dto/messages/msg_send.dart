import 'dart:typed_data';

import 'package:codec_utils/codec_utils.dart';
import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:torii_client/data/dto/messages/a_tx_msg.dart';
import 'package:torii_client/utils/exports.dart';

class MsgSend extends ATxMsg {
  final String fromAddress;
  final String toAddress;
  final String passphrase;
  final List<CosmosCoin> amount;

  MsgSend({required this.fromAddress, required this.toAddress, required this.passphrase, required this.amount})
    : super(typeUrl: '/kira.bridge.MsgChangeCosmosEthereum');

  factory MsgSend.fromData(Map<String, dynamic> data) {
    return MsgSend(
      fromAddress: data['from'] as String,
      toAddress: data['to'] as String,
      // TODO: make passphrase nullable for transactionList
      passphrase: data['passphrase'] as String? ?? '',
      amount:
          (data['amount'] as List<dynamic>)
              .map((dynamic e) => CosmosCoin.fromProtoJson(e as Map<String, dynamic>))
              .toList(),
    );
  }

  @override
  Uint8List toProtoBytes() {
    return ProtobufEncoder.encode(<int, AProtobufField>{
      1: ProtobufBytes(Bech32.decode(fromAddress).data),
      2: ProtobufString(toAddress),
      3: ProtobufString(Sha256.encryptToString(passphrase)),
      4: ProtobufList(amount),
    });
  }

  @override
  Map<String, dynamic> toProtoJson() {
    return <String, dynamic>{
      '@type': typeUrl,
      'from_address': fromAddress,
      'to_address': toAddress,
      'passphrase': Sha256.encryptToString(passphrase),
      'amount': amount.map((CosmosCoin coin) => coin.toProtoJson()).toList(),
    };
  }

  @override
  List<Object?> get props => <Object>[fromAddress, toAddress, amount, passphrase];
}
