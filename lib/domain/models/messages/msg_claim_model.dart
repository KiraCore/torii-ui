import 'package:flutter/material.dart';
import 'package:torii_client/data/dto/messages/a_tx_msg.dart';
import 'package:torii_client/data/dto/messages/msg_claim.dart';
import 'package:torii_client/domain/models/exports.dart';
import 'package:torii_client/domain/models/messages/a_tx_msg_model.dart';
import 'package:torii_client/domain/models/messages/tx_msg_type.dart';
import 'package:torii_client/domain/models/tokens/list/tx_direction_type.dart';
import 'package:torii_client/utils/exports.dart';

class MsgClaimModel extends ATxMsgModel {
  final AWalletAddress senderWalletAddress;

  const MsgClaimModel({required this.senderWalletAddress}) : super(txMsgType: TxMsgType.msgClaim);

  factory MsgClaimModel.fromMsgDto(MsgClaim msgClaim) {
    return MsgClaimModel(senderWalletAddress: AWalletAddress.fromAddress(msgClaim.sender));
  }

  @override
  ATxMsg toMsgDto() {
    return MsgClaim(sender: senderWalletAddress.address);
  }

  @override
  Widget getIcon(TxDirectionType txDirectionType) {
    return const Icon(Icons.star_border);
  }

  @override
  List<PrefixedTokenAmountModel> getPrefixedTokenAmounts(TxDirectionType txDirectionType) {
    return <PrefixedTokenAmountModel>[];
  }

  @override
  String? getSubtitle(TxDirectionType txDirectionType) {
    return senderWalletAddress.address;
  }

  @override
  String getTitle(BuildContext context, TxDirectionType txDirectionType) {
    return S.of(context).txMsgClaimTokens;
  }

  @override
  List<Object?> get props => <Object>[senderWalletAddress];
}
