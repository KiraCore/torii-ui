import 'dart:typed_data';

import 'package:codec_utils/codec_utils.dart';
import 'package:torii_client/data/dto/messages/a_tx_msg.dart';

class MsgClaim extends ATxMsg {
  final String sender;

  MsgClaim({required this.sender}) : super(typeUrl: '/kira.multistaking.MsgClaim');

  factory MsgClaim.fromData(Map<String, dynamic> data) {
    return MsgClaim(sender: data['sender'] as String);
  }

  @override
  Uint8List toProtoBytes() {
    return ProtobufEncoder.encode(<int, AProtobufField>{1: ProtobufString(sender)});
  }

  @override
  Map<String, dynamic> toProtoJson() {
    return <String, dynamic>{'@type': typeUrl, 'sender': sender};
  }

  @override
  List<Object?> get props => <Object>[sender];
}
