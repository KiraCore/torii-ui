import 'dart:typed_data';

import 'package:torii_client/data/dto/messages/a_tx_msg.dart';

class MsgUndefined extends ATxMsg {
  const MsgUndefined() : super(typeUrl: '');

  @override
  Map<String, dynamic> toProtoJson() => <String, dynamic>{};

  @override
  Uint8List toProtoBytes() => Uint8List(0);

  @override
  List<Object?> get props => <Object?>[];
}
