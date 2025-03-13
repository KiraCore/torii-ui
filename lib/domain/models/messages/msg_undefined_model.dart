import 'package:flutter/material.dart';
import 'package:torii_client/data/dto/messages/msg_undefined.dart';
import 'package:torii_client/domain/exports.dart';
import 'package:torii_client/domain/models/messages/a_tx_msg_model.dart';
import 'package:torii_client/domain/models/messages/tx_msg_type.dart';
import 'package:torii_client/domain/models/tokens/list/tx_direction_type.dart';
import 'package:torii_client/utils/exports.dart';

class MsgUndefinedModel extends ATxMsgModel {
  const MsgUndefinedModel() : super(txMsgType: TxMsgType.undefined);

  @override
  MsgUndefined toMsgDto() {
    return const MsgUndefined();
  }

  @override
  Widget getIcon(TxDirectionType txDirectionType) {
    return const Icon(Icons.error);
  }

  @override
  List<PrefixedTokenAmountModel> getPrefixedTokenAmounts(TxDirectionType txDirectionType) {
    return <PrefixedTokenAmountModel>[];
  }

  @override
  String? getSubtitle(TxDirectionType txDirectionType) {
    return null;
  }

  @override
  String getTitle(BuildContext context, TxDirectionType txDirectionType) {
    return S.of(context).txMsgUndefined;
  }

  @override
  List<Object?> get props => <Object>[];
}
