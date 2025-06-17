import 'package:decimal/decimal.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:torii_client/data/dto/api/query_transactions/response/transaction.dart';
import 'package:torii_client/data/dto/coin.dart';
import 'package:torii_client/domain/exports.dart';
import 'package:torii_client/domain/models/messages/a_tx_msg_model.dart';
import 'package:torii_client/domain/models/messages/msg_send_model.dart';
import 'package:torii_client/domain/models/messages/tx_msg_type.dart';
import 'package:torii_client/domain/models/tokens/list/tx_direction_type.dart';
import 'package:torii_client/domain/models/tokens/list/tx_status_type.dart';
import 'package:torii_client/utils/extensions/custom_date_utils.dart';
import 'package:torii_client/utils/extensions/enum_utils.dart';

class TxListItemModel extends Equatable {
  final String hash;
  final DateTime time;
  final TxDirectionType txDirectionType;
  final TxStatusType txStatusType;
  final List<MsgSendModel> txMsgModels;
  final List<TokenAmountModel> fees;
  final List<PrefixedTokenAmountModel> prefixedTokenAmounts;
  final String memo;

  const TxListItemModel({
    required this.hash,
    required this.time,
    required this.txDirectionType,
    required this.txStatusType,
    required this.fees,
    required this.prefixedTokenAmounts,
    required this.txMsgModels,
    required this.memo,
  });

  factory TxListItemModel.fromDto(Transaction transaction) {
    final fees =
        transaction.fee
            .map(
              (Coin fee) => TokenAmountModel(
                defaultDenominationAmount: Decimal.parse(fee.amount),
                tokenAliasModel: TokenAliasModel.local(fee.denom),
              ),
            )
            .toList();
    TxDirectionType txDirectionType = EnumUtils.parseFromString(TxDirectionType.values, transaction.direction);
    List<MsgSendModel> txMsgModels = transaction.txs.map((tx) => MsgSendModel.fromMsgDto(tx)).toList();

    return TxListItemModel(
      hash: transaction.hash,
      time: CustomDateUtils.buildDateFromSecondsSinceEpoch(transaction.time),
      txDirectionType: txDirectionType,
      txStatusType: EnumUtils.parseFromString(TxStatusType.values, transaction.status),
      txMsgModels: txMsgModels,
      prefixedTokenAmounts:
          txMsgModels.expand((ATxMsgModel txMsgModel) => txMsgModel.getPrefixedTokenAmounts(txDirectionType)).toList(),
      fees: fees,
      memo: transaction.memo,
    );
  }

  TokenAmountModel get totalFees {
    return fees.reduce((a, b) => a + b);
  }

  bool get isOutbound {
    return txDirectionType == TxDirectionType.outbound;
  }

  Widget get icon {
    if (txMsgModels.isEmpty) {
      return const Icon(Icons.error);
    } else if (isMultiTransaction) {
      return const Icon(Icons.more_horiz);
    } else {
      return txMsgModels.first.getIcon(txDirectionType);
    }
  }

  TxMsgType get txMsgType {
    if (txMsgModels.isEmpty) {
      return TxMsgType.undefined;
    } else {
      return txMsgModels.first.txMsgType;
    }
  }

  String getTitle(BuildContext context) {
    if (txMsgModels.isEmpty) {
      // TODO(Mykyta): make something better as Error result. (Added to the `global-cleanup` task)
      return '';
    }
    return txMsgModels.first.getTitle(context, txDirectionType);
  }

  String? getSubtitle(BuildContext context) {
    if (txMsgModels.isEmpty || isMultiTransaction) {
      return null;
    }
    return txMsgModels.first.getSubtitle(txDirectionType);
  }

  bool get isMultiTransaction {
    return txMsgModels.length > 1;
  }

  @override
  List<Object?> get props => <Object>[
    hash,
    time,
    txDirectionType,
    txStatusType,
    txMsgModels,
    fees,
    prefixedTokenAmounts,
    memo,
  ];
}
