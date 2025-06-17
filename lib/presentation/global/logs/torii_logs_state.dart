part of 'torii_logs_cubit.dart';

class ToriiLogsState extends Equatable {
  const ToriiLogsState({this.ethereumTransactions, this.kiraTransactions, this.isLoading = false});

  final bool isLoading;
  final LogTxs? ethereumTransactions;
  final LogTxs? kiraTransactions;

  // TODO: optimize, put in state
  // TODO: check for a pending transaction
  TxListItemModel? get pendingSenderTransaction =>
      ethereumTransactions?.fromKira.listItems.lastOrNull ?? kiraTransactions?.fromEth.listItems.lastOrNull;

  TxListItemModel? get pendingRecipientTransaction =>
      ethereumTransactions?.fromEth.listItems.lastOrNull ?? kiraTransactions?.fromKira.listItems.lastOrNull;

  ToriiLogsState copyWith({
    LogTxs? Function()? ethereumTransactions,
    LogTxs? Function()? kiraTransactions,
    bool? isLoading,
  }) {
    return ToriiLogsState(
      ethereumTransactions: ethereumTransactions != null ? ethereumTransactions() : this.ethereumTransactions,
      kiraTransactions: kiraTransactions != null ? kiraTransactions() : this.kiraTransactions,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [ethereumTransactions, kiraTransactions, isLoading];
}
