import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:torii_client/domain/exports.dart';
import 'package:torii_client/domain/models/page_data.dart';
import 'package:torii_client/domain/models/tokens/list/logs_txs.dart';
import 'package:torii_client/domain/models/tokens/list/tx_list_item_model.dart';
import 'package:torii_client/domain/services/js_interop_service.dart';
import 'package:torii_client/domain/services/torii_logs_service.dart';
import 'package:torii_client/main.dart';
import 'package:torii_client/presentation/global/session/cubit/session_cubit.dart';
import 'package:torii_client/utils/exports.dart';

part 'torii_logs_state.dart';

@singleton
class ToriiLogsCubit extends Cubit<ToriiLogsState> {
  ToriiLogsCubit(this._toriiLogsService, this._sessionCubit) : super(ToriiLogsState());

  final ToriiLogsService _toriiLogsService;
  final SessionCubit _sessionCubit;

  Timer? _timer;
  StreamSubscription<SessionState>? _sessionSubscription;
  bool _testMode = false;

  @PostConstruct()
  void reload() async {
    if (!kiraEthEnabled) {
      return;
    }
    // NOTE: it's waiting for rpc in url, but it's commented cause we don't use the RPC url for logs\
    // NOTE: uncommented to make Toast appear on init
    await Future.delayed(const Duration(seconds: 1));
    await _triggerPendingEthTransactions();

    _sessionSubscription = _sessionCubit.stream
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
    _reloadGlobalTimer();
  }

  Future<void> triggerLongPolling({bool testMode = false}) async {
    _testMode = testMode;
    getIt<Logger>().i('Logs: Long polling...');
    _timer?.cancel();
    // NOTE: give a chance for the transaction to appear in logs
    await Future.delayed(const Duration(seconds: 3));
    getIt<Logger>().i('Logs: Long polling...');
    await _fetchPendingEthTransactions();
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) async {
      getIt<Logger>().i('Logs: Long polling...');
      await _fetchPendingEthTransactions();
    });
  }

  void _reloadGlobalTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(minutes: 5), (timer) async {
      getIt<Logger>().i('Logs: Global timer, long polling...');
      await _fetchPendingEthTransactions();
    });
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
      emit(state.copyWith(isLoading: true, isError: false));
      LogTxs? ethereumTransactions;
      if (_sessionCubit.state.ethereumWallet != null) {
        ethereumTransactions = await _toriiLogsService.fetchPendingEthTransactions(
          _sessionCubit.state.ethereumWallet!.address as EthereumWalletAddress,
        );
      }
      final txsInMemory = state.pendingEthTxs?.listItems.length;
      final incomingTxs = ethereumTransactions?.fromKira.listItems.length ?? 0;
      if ((_testMode && incomingTxs > 0) || (txsInMemory != null && incomingTxs > 0 && txsInMemory < incomingTxs)) {
        // NOTE: reset long polling timer
        _reloadGlobalTimer();
        if (_testMode) {
          JsInteropService.showLocalNotification(
            '1 new transaction from Kira account',
            hash: ethereumTransactions!.fromKira.listItems.last.hash,
          );
        } else {
          JsInteropService.showLocalNotification(
            '${incomingTxs - txsInMemory!} new transaction${incomingTxs - txsInMemory == 1 ? '' : 's'} from Kira account',
            hash: ethereumTransactions!.fromKira.listItems.last.hash,
          );
        }
      }
      getIt<Logger>().i('ToriiLogsCubit: _fetchPendingEthTransactions() ${ethereumTransactions?.fromKira}');
      emit(state.copyWith(pendingEthTxs: () => ethereumTransactions?.fromKira, isLoading: false));
    } catch (e) {
      getIt<Logger>().e('ToriiLogsCubit: Cannot parse _fetchPendingEthTransactions() $e');
      emit(state.copyWith(isLoading: false, isError: true));
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    _sessionSubscription?.cancel();
    return super.close();
  }
}
