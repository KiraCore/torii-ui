import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:torii_client/domain/exports.dart';
import 'package:torii_client/domain/models/page_data.dart';
import 'package:torii_client/domain/models/tokens/list/logs_txs.dart';
import 'package:torii_client/domain/models/tokens/list/tx_list_item_model.dart';
import 'package:torii_client/domain/services/torii_logs_service.dart';
import 'package:torii_client/presentation/global/session/cubit/session_cubit.dart';
import 'package:torii_client/utils/exports.dart';

part 'torii_logs_state.dart';

@singleton
class ToriiLogsCubit extends Cubit<ToriiLogsState> {
  ToriiLogsCubit(this._toriiLogsService, this._sessionCubit) : super(ToriiLogsState());

  final ToriiLogsService _toriiLogsService;
  final SessionCubit _sessionCubit;

  Timer? _timer;

  @PostConstruct()
  void reload() async {
    // TODO: it's waiting for rpc in url, but it's commented cause we don't use the RPC url for logs
    // await Future.delayed(const Duration(seconds: 1));
    await _triggerPendingEthTransactions();

    _sessionCubit.stream
        .where((sessionState) {
          final currentEthAddress =
              state.pendingEthTxs?.listItems.firstOrNull?.txMsgModels.firstOrNull?.toWalletAddress;
          final nextEthAddress = sessionState.ethereumWallet?.address;
          return currentEthAddress != nextEthAddress;
        })
        .listen((_) => _triggerPendingEthTransactions());
  }

  Future<void> _triggerPendingEthTransactions() async {
    _timer?.cancel();
    await _fetchPendingEthTransactions();
    // TODO: timer
    // _timer = Timer.periodic(const Duration(seconds: 1000), (timer) async {
    //   await _fetchPendingEthTransactions();
    // });
  }

  Future<void> updateTransactions({bool forMyEthereum = true, bool forMyKira = true}) async {
    try {
      LogTxs? ethereumTransactions = state.ethereumTxs;
      if (_sessionCubit.state.ethereumWallet != null && forMyEthereum) {
        ethereumTransactions = await _toriiLogsService.fetchTransactionsPerAccount(
          ethAddress: _sessionCubit.state.ethereumWallet!.address as EthereumWalletAddress,
        );
      }
      LogTxs? kiraTransactions = state.kiraTxs;
      if (_sessionCubit.state.kiraWallet != null && forMyKira) {
        kiraTransactions = await _toriiLogsService.fetchTransactionsPerAccount(
          kiraAddress: _sessionCubit.state.kiraWallet!.address as CosmosWalletAddress,
        );
      }
      emit(state.copyWith(ethereumTxs: () => ethereumTransactions, kiraTxs: () => kiraTransactions));
    } catch (e) {
      getIt<Logger>().e('ToriiLogsCubit: Cannot parse _fetchTransactionsPerAccount() $e');
    }
  }

  Future<void> _fetchPendingEthTransactions() async {
    try {
      emit(state.copyWith(isLoading: true));
      LogTxs? ethereumTransactions;
      if (_sessionCubit.state.ethereumWallet != null) {
        ethereumTransactions = await _toriiLogsService.fetchPendingEthTransactions(
          _sessionCubit.state.ethereumWallet!.address as EthereumWalletAddress,
        );
      }
      getIt<Logger>().i('ToriiLogsCubit: _fetchPendingEthTransactions() ${ethereumTransactions?.fromKira}');
      emit(state.copyWith(pendingEthTxs: () => ethereumTransactions?.fromKira, isLoading: false));
    } catch (e) {
      getIt<Logger>().e('ToriiLogsCubit: Cannot parse _fetchPendingEthTransactions() $e');
      emit(state.copyWith(isLoading: false));
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
