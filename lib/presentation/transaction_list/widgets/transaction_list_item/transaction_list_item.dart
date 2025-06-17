import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:torii_client/domain/models/messages/msg_send_model.dart';
import 'package:torii_client/domain/models/tokens/list/tx_direction_type.dart';
import 'package:torii_client/domain/models/tokens/list/tx_list_item_model.dart';
import 'package:torii_client/domain/models/tokens/token_amount_model.dart';
import 'package:torii_client/presentation/transaction_list/widgets/transaction_list_item/transaction_list_item_desktop_layout.dart';
import 'package:torii_client/presentation/widgets/buttons/ink_wrapper.dart';
import 'package:torii_client/presentation/widgets/kira_tooltip.dart';
import 'package:torii_client/utils/exports.dart';
import 'package:torii_client/utils/extensions/date_time_extension.dart';
import 'package:torii_client/utils/router/router.dart';

class TransactionListItem extends StatelessWidget {
  static const double height = 64;

  final TxListItemModel txListItemModel;
  final bool isAgeFormat;

  const TransactionListItem({required this.txListItemModel, required this.isAgeFormat, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    TokenAmountModel? totalAmount = txListItemModel.txMsgModels.firstOrNull?.tokenAmountModel;
    Set<String> fromAddresses =
        txListItemModel.txMsgModels.map((MsgSendModel e) => e.fromWalletAddress!.address).toSet();
    Set<String> toAddresses = txListItemModel.txMsgModels.map((MsgSendModel e) => e.toWalletAddress!.address).toSet();

    return InkWrapper(
      onTap: () => TransactionDetailsDrawerRoute(txListItemModel).push(context),
      child: TransactionListItemDesktopLayout(
        height: height,
        hashWidget: KiraToolTip(
          childMargin: EdgeInsets.zero,
          message: txListItemModel.hash,
          child: Text(
            CryptoAddressParser.stripHexPrefix(txListItemModel.hash),
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodyMedium?.copyWith(color: DesignColors.white2),
          ),
        ),
        dateWidget: Text(
          isAgeFormat
              ? txListItemModel.time.toShortAge(context)
              : DateFormat('d/M/y, HH:mm').format(txListItemModel.time.toLocal()),
          overflow: TextOverflow.ellipsis,
          style: textTheme.bodyMedium?.copyWith(color: DesignColors.white2),
        ),
        isDateInAgeFormatBool: isAgeFormat,
        fromWidget:
            fromAddresses.isEmpty
                ? const Text('---')
                : KiraToolTip(
                  childMargin: EdgeInsets.zero,
                  message: fromAddresses.join('\n\n'),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          fromAddresses.first,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodyMedium?.copyWith(color: DesignColors.white2),
                        ),
                      ),
                      if (fromAddresses.length > 1) _Count(count: fromAddresses.length - 1),
                    ],
                  ),
                ),
        toWidget:
            toAddresses.isEmpty
                ? const Text('---')
                : KiraToolTip(
                  childMargin: EdgeInsets.zero,
                  message: toAddresses.join('\n\n'),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          toAddresses.first,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodyMedium?.copyWith(color: DesignColors.white2),
                        ),
                      ),
                      if (toAddresses.length > 1) _Count(count: toAddresses.length - 1),
                    ],
                  ),
                ),
        amountWidget:
            txListItemModel.txMsgModels.isEmpty || totalAmount == null
                ? const Text('---')
                : Text(
                  totalAmount.toString(),
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyLarge?.copyWith(color: DesignColors.white2),
                ),
        feeWidget: Text(
          txListItemModel.fees.reduce((TokenAmountModel count, TokenAmountModel e) => count + e).toString(),
          overflow: TextOverflow.ellipsis,
          style: textTheme.bodyLarge?.copyWith(color: DesignColors.white2),
        ),
      ),
    );
  }
}

class _Count extends StatelessWidget {
  const _Count({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        '+$count',
        overflow: TextOverflow.ellipsis,
        style: textTheme.bodySmall?.copyWith(color: DesignColors.white2),
      ),
    );
  }
}
