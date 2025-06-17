import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:torii_client/domain/models/tokens/list/tx_direction_type.dart';
import 'package:torii_client/domain/models/tokens/list/tx_list_item_model.dart';
import 'package:torii_client/domain/models/tokens/list/tx_status_type.dart';
import 'package:torii_client/presentation/transaction_list/cubit/transaction_list_cubit.dart';
import 'package:torii_client/presentation/transaction_list/widgets/transaction_list_item/transaction_list_item.dart';
import 'package:torii_client/presentation/transaction_list/widgets/transaction_list_item/transaction_list_item_desktop_layout.dart';
import 'package:torii_client/presentation/transaction_list/widgets/transaction_list_title/transaction_list_title.dart';
import 'package:torii_client/presentation/widgets/torii_scaffold.dart';
import 'package:torii_client/utils/di/locator.dart';
import 'package:torii_client/utils/l10n/generated/l10n.dart';
import 'package:torii_client/utils/theme/design_colors.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({required this.forKira, Key? key}) : super(key: key);

  final bool forKira;

  @override
  State<StatefulWidget> createState() => _TransactionsPage();
}

class _TransactionsPage extends State<TransactionsPage> {
  final TextEditingController searchBarTextEditingController = TextEditingController();
  int pageSize = 15;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    searchBarTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    TextStyle? headerStyle = textTheme.bodySmall?.copyWith(color: DesignColors.white1);

    return ToriiScaffold(
      hasAppBar: true,
      child: SizedBox(
        // TODO: why maxWidth not applied from ToriiScaffold ???
        width: 1280,
        child: BlocProvider<TransactionListCubit>(
          create: (BuildContext context) => getIt<TransactionListCubit>()..init(forKira: widget.forKira),
          child: BlocBuilder<TransactionListCubit, TransactionListState>(
            builder: (BuildContext context, TransactionListState state) {
              // TODO: shimmer on loading
              Widget listHeaderWidget = TransactionListItemDesktopLayout(
                height: 64,
                hashWidget: Text('Hash', style: headerStyle),
                dateWidget: InkWell(
                  onTap: () => context.read<TransactionListCubit>().switchDateFormat(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text(
                      state.isAgeFormat ? S.of(context).txListAge : 'Date',
                      style: headerStyle?.copyWith(color: DesignColors.hyperlink),
                    ),
                  ),
                ),
                isDateInAgeFormatBool: state.isAgeFormat,
                fromWidget: Text('From', style: headerStyle),
                toWidget: Text('To', style: headerStyle),
                amountWidget: Text('Amount', style: headerStyle),
                feeWidget: Text('Fee', style: headerStyle),
              );

              return Padding(
                padding: const EdgeInsets.all(40.0),
                child: ListView.builder(
                  itemCount: state.txs.listItems.length + 2,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return TransactionListTitle(
                        searchBarTextEditingController: searchBarTextEditingController,
                        forKira: widget.forKira,
                      );
                    } else if (index == 1) {
                      return listHeaderWidget;
                    }
                    return SizedBox(
                      height: 80,
                      child: TransactionListItem(
                        key: Key(state.txs.listItems[index - 2].toString()),
                        txListItemModel: state.txs.listItems[index - 2],
                        isAgeFormat: state.isAgeFormat,
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
