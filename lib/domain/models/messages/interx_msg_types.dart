import 'package:torii_client/domain/models/messages/tx_msg_type.dart';

class InterxMsgTypes {
  static final Map<TxMsgType, String> _types = <TxMsgType, String>{
    TxMsgType.msgClaim: 'claim',
    TxMsgType.msgSend: 'send',
  };

  static String getName(TxMsgType type) => _types[type] ?? '';

  static TxMsgType getType(String name) {
    return _types.keys.firstWhere(
      (TxMsgType type) {
        return _types[type] == name;
      },
      orElse: () {
        return TxMsgType.undefined;
      },
    );
  }
}
