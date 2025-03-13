import 'package:codec_utils/codec_utils.dart';
import 'package:torii_client/data/dto/messages/msg_claim.dart';
import 'package:torii_client/data/dto/messages/msg_send.dart';
import 'package:torii_client/data/dto/messages/msg_undefined.dart';
import 'package:torii_client/domain/models/messages/interx_msg_types.dart';
import 'package:torii_client/domain/models/messages/tx_msg_type.dart';

/// Transaction message objects are shared between endpoints:
/// - QueryTransactions (as single list element in response)
/// - Broadcast (as a transaction message used in request)
/// Represents Msg interface from Kira SDK
/// https://github.com/KiraCore/sekai/blob/master/types/Msg.go
abstract class ATxMsg extends ProtobufAny {
  const ATxMsg({required super.typeUrl});

  static ATxMsg buildFromJson(Map<String, dynamic> json) {
    TxMsgType txMsgType = InterxMsgTypes.getType(json['type'] as String);

    switch (txMsgType) {
      case TxMsgType.msgClaim:
        return MsgClaim.fromData(json);
      case TxMsgType.msgSend:
        return MsgSend.fromData(json);
      default:
        return const MsgUndefined();
    }
  }
}
