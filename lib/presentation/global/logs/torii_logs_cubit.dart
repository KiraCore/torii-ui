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

// TODO: rewrite to service's stream ??
@singleton
class ToriiLogsCubit extends Cubit<ToriiLogsState> {
  ToriiLogsCubit(this._toriiLogsService, this._sessionCubit) : super(ToriiLogsState());

  final ToriiLogsService _toriiLogsService;
  final SessionCubit _sessionCubit;

  Timer? _timer;

  // todo remove params ??
  @PostConstruct()
  void reload({bool forMyKira = true, bool forMyEthereum = true}) async {
    emit(state.copyWith(isLoading: true));
    _timer?.cancel();
    // TODO: refactor !!! it's waiting for rpc in url
    await Future.delayed(const Duration(seconds: 1));
    await _fetchTransactionsPerAccount(forKira: forMyKira, forEthereum: forMyEthereum);
    emit(state.copyWith(isLoading: false));
    // TODO: timer
    // _timer = Timer.periodic(const Duration(seconds: 1000), (timer) async {
    //   await _fetchTransactionsPerAccount();
    // });
  }

  Future<void> _fetchTransactionsPerAccount({bool forKira = true, bool forEthereum = true}) async {
    try {
      LogTxs? ethereumTransactions = state.ethereumTransactions;
      if (_sessionCubit.state.ethereumWallet != null && forEthereum) {
        ethereumTransactions = await _toriiLogsService.fetchTransactionsPerAccount(
          _sessionCubit.state.ethereumWallet!.address,
        );
      }
      LogTxs? kiraTransactions = state.kiraTransactions;
      if (_sessionCubit.state.kiraWallet != null && forKira) {
        kiraTransactions = await _toriiLogsService.fetchTransactionsPerAccount(_sessionCubit.state.kiraWallet!.address);
      }
      print('ToriiLogsCubit: _fetchTransactionsPerAccount() $ethereumTransactions $kiraTransactions');
      emit(state.copyWith(ethereumTransactions: () => ethereumTransactions, kiraTransactions: () => kiraTransactions));
    } catch (e) {
      getIt<Logger>().e('ToriiLogsCubit: Cannot parse _fetchTransactionsPerAccount() $e');
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
