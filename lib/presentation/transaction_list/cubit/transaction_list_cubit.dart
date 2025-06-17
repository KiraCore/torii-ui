import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:torii_client/domain/models/page_data.dart';
import 'package:torii_client/domain/models/tokens/list/tx_list_item_model.dart';
import 'package:torii_client/presentation/global/logs/torii_logs_cubit.dart';
import 'package:torii_client/utils/extensions/page_data_extension.dart';

part 'transaction_list_state.dart';

@injectable
class TransactionListCubit extends Cubit<TransactionListState> {
  TransactionListCubit(this.toriiLogsCubit) : super(TransactionListState(isLoading: true));

  final ToriiLogsCubit toriiLogsCubit;
  late bool forKira;

  void init({bool forKira = true}) {
    this.forKira = forKira;
    // TODO: listen
    // toriiLogsCubit.stream.listen((ToriiLogsState state) {
    emit(
      TransactionListState(
        kiraTxs:
            forKira
                // TODO: sorting here is temp. Fetch from server in correct order
                ? toriiLogsCubit.state.kiraTransactions?.fromKira.sortDescByDate()
                : toriiLogsCubit.state.ethereumTransactions?.fromKira.sortDescByDate(),
        ethTxs:
            forKira
                ? toriiLogsCubit.state.kiraTransactions?.fromEth.sortDescByDate()
                : toriiLogsCubit.state.ethereumTransactions?.fromEth.sortDescByDate(),
        isLoading: false,
      ),
    );
    // });
  }

  void search(String query) {
    if (query.isEmpty) {
      emit(state.copyWith(isLoading: true));
      // TODO: optimize, cache prev values
      init(forKira: forKira);
      return;
    }

    emit(state.copyWith(isLoading: true));

    String pattern = query.toLowerCase();
    List<TxListItemModel> filteredItems = [];

    if (state.currentFromKira) {
      filteredItems =
          state.kiraTxs?.listItems.where((TxListItemModel item) {
            bool hashMatch = item.hash.toLowerCase().contains(pattern);
            bool fromMatch =
                item.txMsgModels.isNotEmpty &&
                (item.txMsgModels.first.fromWalletAddress?.address.toLowerCase().contains(pattern) ?? false);
            bool toMatch =
                item.txMsgModels.isNotEmpty &&
                (item.txMsgModels.first.toWalletAddress?.address.toLowerCase().contains(pattern) ?? false);
            return hashMatch || fromMatch || toMatch;
          }).toList() ??
          [];

      emit(state.copyWith(kiraTxs: PageData<TxListItemModel>(listItems: filteredItems), isLoading: false));
    } else {
      filteredItems =
          state.ethTxs?.listItems.where((TxListItemModel item) {
            bool hashMatch = item.hash.toLowerCase().contains(pattern);
            bool fromMatch =
                item.txMsgModels.isNotEmpty &&
                (item.txMsgModels.first.fromWalletAddress?.address.toLowerCase().contains(pattern) ?? false);
            bool toMatch =
                item.txMsgModels.isNotEmpty &&
                (item.txMsgModels.first.toWalletAddress?.address.toLowerCase().contains(pattern) ?? false);
            return hashMatch || fromMatch || toMatch;
          }).toList() ??
          [];

      emit(state.copyWith(ethTxs: PageData<TxListItemModel>(listItems: filteredItems), isLoading: false));
    }
  }

  void switchDateFormat() {
    emit(state.copyWith(isAgeFormat: !state.isAgeFormat));
  }
}
