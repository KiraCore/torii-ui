import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:torii_client/domain/models/messages/msg_send_model.dart';
import 'package:torii_client/domain/models/tokens/list/tx_direction_type.dart';
import 'package:torii_client/domain/models/tokens/list/tx_list_item_model.dart';
import 'package:torii_client/domain/models/tokens/token_amount_model.dart';
import 'package:torii_client/presentation/transaction_list/widgets/transaction_status_chip/transaction_status_chip.dart';
import 'package:torii_client/presentation/widgets/drawer/drawer_subtitle.dart';
import 'package:torii_client/presentation/widgets/key_value/copy_hover_title_value.dart';
import 'package:torii_client/presentation/widgets/key_value/detail_title.dart';
import 'package:torii_client/presentation/widgets/key_value/detail_value.dart';
import 'package:torii_client/utils/l10n/generated/l10n.dart';
import 'package:torii_client/utils/theme/design_colors.dart';

class TransactionDetailsDrawerPage extends StatefulWidget {
  final TxListItemModel txListItemModel;

  const TransactionDetailsDrawerPage({required this.txListItemModel, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TransactionDetailsDrawerPage();
}

class _TransactionDetailsDrawerPage extends State<TransactionDetailsDrawerPage> {
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        DrawerTitle(title: 'Transaction details'),
        const SizedBox(height: 32),
        _CommonDetails(txListItemModel: widget.txListItemModel),
        const SizedBox(height: 48),
        if (widget.txListItemModel.txMsgModels.isNotEmpty)
          Text('Messages:', style: textTheme.titleLarge!.copyWith(color: DesignColors.white1)),
        for (final MsgSendModel model in widget.txListItemModel.txMsgModels) ...<Widget>[
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),
          _Details(txMsgModel: model),
        ],
        const SizedBox(height: 48),
      ],
    );
  }
}

class _CommonDetails extends StatelessWidget {
  const _CommonDetails({required this.txListItemModel});

  final TxListItemModel txListItemModel;

  @override
  Widget build(BuildContext context) {
    Widget divider = const SizedBox(height: 12);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CopyHoverTitleValue(title: 'Hash', value: txListItemModel.hash),
        divider,
        TransactionStatusChip(txStatusType: txListItemModel.txStatusType),
        divider,
        DetailTitle('Date'),
        const SizedBox(height: 4),
        DetailValue(DateFormat('d MMM y, HH:mm:ss').format(txListItemModel.time.toLocal())),
        divider,
        DetailTitle('Fee'),
        const SizedBox(height: 4),
        DetailValue(txListItemModel.fees.reduce((TokenAmountModel count, TokenAmountModel e) => count + e).toString()),
      ],
    );
  }
}

class _Details extends StatelessWidget {
  const _Details({required this.txMsgModel});

  final MsgSendModel txMsgModel;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    Widget content;
    Widget divider = const SizedBox(height: 12);

    content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CopyHoverTitleValue(title: 'From', value: txMsgModel.fromWalletAddress.address),
        divider,
        CopyHoverTitleValue(title: 'To', value: txMsgModel.toWalletAddress.address),
        divider,
        DetailTitle('Amount'),
        const SizedBox(height: 4),
        DetailValue(txMsgModel.tokenAmountModel.toString()),
      ],
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          // TODO(Mykyta): avoid direction type after INTERX updated to getAllTransactions
          txMsgModel.getTitle(context, TxDirectionType.outbound),
          maxLines: 3,
          style: textTheme.titleMedium!.copyWith(color: DesignColors.white2),
        ),
        const SizedBox(height: 12),
        content,
      ],
    );
  }
}
