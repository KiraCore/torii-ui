part of 'torii_logs_cubit.dart';

class ToriiLogsState extends Equatable {
  const ToriiLogsState({this.pendingEthTxs, this.ethereumTxs, this.kiraTxs, this.isLoading = false});

  final bool isLoading;
  final PageData<TxListItemModel>? pendingEthTxs;
  final LogTxs? ethereumTxs;
  final LogTxs? kiraTxs;

  ToriiLogsState copyWith({
    PageData<TxListItemModel>? Function()? pendingEthTxs,
    LogTxs? Function()? ethereumTxs,
    LogTxs? Function()? kiraTxs,
    bool? isLoading,
  }) {
    return ToriiLogsState(
      pendingEthTxs: pendingEthTxs != null ? pendingEthTxs() : this.pendingEthTxs,
      ethereumTxs: ethereumTxs != null ? ethereumTxs() : this.ethereumTxs,
      kiraTxs: kiraTxs != null ? kiraTxs() : this.kiraTxs,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [pendingEthTxs, ethereumTxs, kiraTxs, isLoading];
}
