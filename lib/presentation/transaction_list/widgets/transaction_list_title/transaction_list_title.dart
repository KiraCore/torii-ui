import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:torii_client/presentation/transaction_list/cubit/transaction_list_cubit.dart';
import 'package:torii_client/presentation/widgets/search/list_search_widget.dart';
import 'package:torii_client/utils/theme/design_colors.dart';

class TransactionListTitle extends StatelessWidget {
  const TransactionListTitle({required this.searchBarTextEditingController, super.key, required this.forKira});

  final TextEditingController searchBarTextEditingController;
  final bool forKira;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          forKira ? 'Kira Transactions' : 'Ethereum Transactions',
          style: textTheme.displayMedium!.copyWith(color: DesignColors.white1),
        ),
        const SizedBox(height: 16),
        Row(
          children: <Widget>[
            // todo
            // DateRangeDropdown(
            //   initialStartDateTime: transactionsListController.startDateTime,
            //   initialEndDateTime: transactionsListController.endDateTime,
            //   onDateTimeChanged: (DateTime? startDateTime, DateTime? endDateTime) {
            //     transactionsListController
            //       ..startDateTime = startDateTime
            //       ..endDateTime = endDateTime;
            //     BlocProvider.of<PaginatedListBloc<TxListItemModel>>(context).add(const ListReloadEvent());
            //   },
            // ),
            const SizedBox(width: 24),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      // todo
                      // SizedBox(
                      //   width: 340,
                      //   child: TransactionsFilterDropdown(
                      //     activeFilters: activeFilters,
                      //     onFiltersChanged: updateFilters,
                      //   ),
                      // ),
                      const SizedBox(width: 24),
                      // Expanded(
                      //   child:
                      ListSearchWidget(
                        textEditingController: searchBarTextEditingController,
                        hint: 'Search by hash or address',
                        onSubmit: (String value) {
                          context.read<TransactionListCubit>().search(value);
                        },
                        onClear: () {
                          context.read<TransactionListCubit>().search('');
                        },
                      ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
