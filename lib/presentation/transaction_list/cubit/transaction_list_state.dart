part of 'transaction_list_cubit.dart';

class TransactionListState extends Equatable {
  const TransactionListState({
    this.txs,
    this.isLoading = false,
    this.isAgeFormat = false,
  });

  final PageData<TxListItemModel>? txs;
  final bool isLoading;
  final bool isAgeFormat;

  TransactionListState copyWith({
    PageData<TxListItemModel>? txs,
    bool? isLoading,
    bool? isAgeFormat,
  }) {
    return TransactionListState(
      txs: txs ?? this.txs,
      isLoading: isLoading ?? this.isLoading,
      isAgeFormat: isAgeFormat ?? this.isAgeFormat,
    );
  }

  @override
  List<Object?> get props => [txs, isLoading, isAgeFormat];
}
