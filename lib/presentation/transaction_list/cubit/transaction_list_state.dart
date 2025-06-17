part of 'transaction_list_cubit.dart';

class TransactionListState extends Equatable {
  const TransactionListState({
    this.kiraTxs,
    this.ethTxs,
    this.isLoading = false,
    this.currentFromKira = true,
    this.isAgeFormat = false,
  });

  final PageData<TxListItemModel>? kiraTxs;
  final PageData<TxListItemModel>? ethTxs;
  final bool currentFromKira;
  final bool isLoading;
  final bool isAgeFormat;

  PageData<TxListItemModel> get txs => (currentFromKira ? kiraTxs : ethTxs) ?? PageData<TxListItemModel>(listItems: []);

  TransactionListState copyWith({
    PageData<TxListItemModel>? kiraTxs,
    PageData<TxListItemModel>? ethTxs,
    bool? currentFromKira,
    bool? isLoading,
    bool? isAgeFormat,
  }) {
    return TransactionListState(
      kiraTxs: kiraTxs ?? this.kiraTxs,
      ethTxs: ethTxs ?? this.ethTxs,
      currentFromKira: currentFromKira ?? this.currentFromKira,
      isLoading: isLoading ?? this.isLoading,
      isAgeFormat: isAgeFormat ?? this.isAgeFormat,
    );
  }

  @override
  List<Object?> get props => [kiraTxs, ethTxs, isLoading, currentFromKira, isAgeFormat];
}
