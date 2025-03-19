import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:torii_client/data/dto/messages/a_tx_msg.dart';
import 'package:torii_client/data/dto/messages/msg_claim.dart';
import 'package:torii_client/data/dto/messages/msg_send.dart';
import 'package:torii_client/domain/exports.dart';
import 'package:torii_client/domain/models/messages/msg_claim_model.dart';
import 'package:torii_client/domain/models/messages/msg_send_model.dart';
import 'package:torii_client/domain/models/messages/msg_undefined_model.dart';
import 'package:torii_client/domain/models/messages/tx_msg_type.dart';
import 'package:torii_client/domain/models/tokens/list/tx_direction_type.dart';

abstract class ATxMsgModel extends Equatable {
  final TxMsgType txMsgType;

  const ATxMsgModel({required this.txMsgType});

  static ATxMsgModel buildFromDto(ATxMsg msgDto) {
    switch (msgDto) {
      case MsgClaim dto:
        return MsgClaimModel.fromMsgDto(dto);
      case MsgSend dto:
        return MsgSendModel.fromMsgDto(dto);
      default:
        return const MsgUndefinedModel();
    }
  }

  ATxMsg toMsgDto();

  Widget getIcon(TxDirectionType txDirectionType);

  List<PrefixedTokenAmountModel> getPrefixedTokenAmounts(TxDirectionType txDirectionType);

  String? getSubtitle(TxDirectionType txDirectionType);

  String getTitle(BuildContext context, TxDirectionType txDirectionType);
}
