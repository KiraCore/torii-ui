import 'dart:math';

import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:torii_client/data/dto/messages/msg_send.dart';
import 'package:torii_client/domain/exports.dart';
import 'package:torii_client/domain/models/messages/a_tx_msg_model.dart';
import 'package:torii_client/domain/models/messages/tx_msg_type.dart';
import 'package:torii_client/domain/models/tokens/list/tx_direction_type.dart';
import 'package:torii_client/utils/exports.dart';

class MsgSendModel extends ATxMsgModel {
  final AWalletAddress fromWalletAddress;
  final AWalletAddress toWalletAddress;
  final TokenAmountModel tokenAmountModel;
  final String passphrase;

  const MsgSendModel({
    required this.fromWalletAddress,
    required this.toWalletAddress,
    required this.tokenAmountModel,
    required this.passphrase,
  }) : super(txMsgType: TxMsgType.msgSend);

  factory MsgSendModel.fromMsgDto(MsgSend msgSend) {
    return MsgSendModel(
      fromWalletAddress: AWalletAddress.fromAddress(msgSend.fromAddress),
      toWalletAddress: AWalletAddress.fromAddress(msgSend.toAddress),
      tokenAmountModel: TokenAmountModel(
        defaultDenominationAmount: Decimal.fromBigInt(msgSend.amount.first.amount),
        tokenAliasModel: TokenAliasModel.local(msgSend.amount.first.denom),
      ),
      passphrase: msgSend.passphrase,
    );
  }

  @override
  MsgSend toMsgDto() {
    return MsgSend(
      fromAddress: fromWalletAddress.address,
      toAddress: toWalletAddress.address,
      passphrase: passphrase,
      amount: <CosmosCoin>[
        CosmosCoin(
          denom: tokenAmountModel.tokenAliasModel.defaultTokenDenominationModel.name,
          amount: tokenAmountModel.getAmountInDefaultDenomination().toBigInt(),
        ),
      ],
    );
  }

  @override
  Widget getIcon(TxDirectionType txDirectionType) {
    if (txDirectionType == TxDirectionType.outbound) {
      return Transform.rotate(angle: -pi / 2, child: const Icon(AppIcons.arrow_up_right));
    } else {
      return Transform.rotate(angle: pi / 2, child: const Icon(AppIcons.arrow_up_right));
    }
  }

  @override
  List<PrefixedTokenAmountModel> getPrefixedTokenAmounts(TxDirectionType txDirectionType) {
    return <PrefixedTokenAmountModel>[
      PrefixedTokenAmountModel(
        tokenAmountModel: tokenAmountModel,
        tokenAmountPrefixType:
            txDirectionType == TxDirectionType.outbound ? TokenAmountPrefixType.subtract : TokenAmountPrefixType.add,
      ),
    ];
  }

  @override
  String getSubtitle(TxDirectionType txDirectionType) {
    if (txDirectionType == TxDirectionType.outbound) {
      return toWalletAddress.address;
    } else {
      return fromWalletAddress.address;
    }
  }

  @override
  String getTitle(BuildContext context, TxDirectionType txDirectionType) {
    if (txDirectionType == TxDirectionType.outbound) {
      return S.of(context).txMsgSendSendTokens;
    } else {
      return S.of(context).txMsgSendReceiveTokens;
    }
  }

  @override
  List<Object?> get props => <Object>[fromWalletAddress, toWalletAddress, tokenAmountModel, passphrase];
}
