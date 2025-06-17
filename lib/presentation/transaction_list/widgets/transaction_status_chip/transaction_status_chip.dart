import 'package:flutter/material.dart';
import 'package:torii_client/presentation/transaction_list/widgets/transaction_status_chip/transaction_status_chip_model.dart';
import 'package:torii_client/presentation/widgets/status_chip.dart';
import 'package:torii_client/utils/theme/design_colors.dart';
import 'package:torii_client/domain/models/tokens/list/tx_status_type.dart';

class TransactionStatusChip extends StatelessWidget {
  final TxStatusType txStatusType;

  const TransactionStatusChip({required this.txStatusType, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TransactionStatusChipModel transactionStatusChipModel = _getTransactionStatusChipModel(context);

    return Align(
      alignment: Alignment.centerLeft,
      child: StatusChip(text: transactionStatusChipModel.title, color: transactionStatusChipModel.color),
    );
  }

  TransactionStatusChipModel _getTransactionStatusChipModel(BuildContext context) {
    switch (txStatusType) {
      case TxStatusType.confirmed:
        return TransactionStatusChipModel(color: DesignColors.greenStatus1, title: 'Confirmed');
      case TxStatusType.pending:
        return TransactionStatusChipModel(color: DesignColors.yellowStatus1, title: 'Pending');
      case TxStatusType.failed:
        return TransactionStatusChipModel(color: DesignColors.redStatus1, title: 'Failed');
    }
  }
}
