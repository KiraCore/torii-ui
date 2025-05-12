import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:torii_client/data/dto/api/query_transactions/request/query_transactions_req.dart';
import 'package:torii_client/data/dto/api_request_model.dart';
import 'package:torii_client/domain/exports.dart';
import 'package:torii_client/domain/models/page_data.dart';
import 'package:torii_client/domain/models/tokens/list/tx_list_item_model.dart';
import 'package:torii_client/domain/models/transaction/signed_transaction_model.dart';
import 'package:torii_client/domain/repositories/api_torii_repository.dart';
import 'package:torii_client/domain/services/torii_log_service.dart';
import 'package:torii_client/presentation/session/cubit/session_cubit.dart';
import 'package:torii_client/utils/di/locator.dart';
import 'package:torii_client/utils/exports.dart';

part 'transfer_claim_state.dart';

@injectable
class TransferClaimCubit extends Cubit<TransferClaimState> {
  TransferClaimCubit(this._ethereumService, this._sessionCubit, this._toriiLogService)
    : super(TransferClaimState(signedTx: null, msgSendFormModel: null));

  final EthereumService _ethereumService;
  final SessionCubit _sessionCubit;
  final ToriiLogService _toriiLogService;

  // TODO: temp way, add listener to the signedTx
  Timer? _timer;

  /// If [msgSendFormModel] is null, we need to check pending txs for the recipient
  void init({required SignedTxModel? signedTx, required MsgSendFormModel? msgSendFormModel}) async {
    emit(TransferClaimState(signedTx: signedTx, msgSendFormModel: msgSendFormModel, isLoading: true));
    return;
    await Future.delayed(const Duration(seconds: 1));
    if (msgSendFormModel == null) {
      // TODO: check pending txs from torii tag
      emit(TransferClaimState(signedTx: signedTx, msgSendFormModel: msgSendFormModel, navigateToInput: true));
      return;
    }
    try {
      // TODO: check pending txs from torii tag
      final pageData = await _toriiLogService.fetchTransactionsPerAccount(
        msgSendFormModel.recipientWalletAddress!.address,
      );
    } catch (e) {
      getIt<Logger>().e('TransferClaimCubit: Cannot parse init() $e');
      emit(TransferClaimState(signedTx: signedTx, msgSendFormModel: msgSendFormModel, isError: true));
      return;
    }

    final recipient = msgSendFormModel.recipientWalletAddress!.address;
    if (_sessionCubit.state.kiraWallet?.address.address != recipient &&
        (_sessionCubit.state.ethereumWallet?.address.address != recipient)) {
      // TODO: show message
      emit(TransferClaimState(signedTx: signedTx, msgSendFormModel: msgSendFormModel, isError: true));
      return;
    }

    emit(TransferClaimState(signedTx: signedTx, msgSendFormModel: msgSendFormModel));
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.isReadyToClaim || state.isClaiming) {
        _timer?.cancel();
        _timer = null;
        return;
      }
      emit(
        TransferClaimState(
          signedTx: state.signedTx,
          msgSendFormModel: state.msgSendFormModel,
          passedSeconds: state.passedSeconds + 1,
        ),
      );
    });
  }

  void refreshIsReadyToClaim() {
    if (state.passedSeconds > 10) {
      emit(
        TransferClaimState(
          signedTx: state.signedTx,
          msgSendFormModel: state.msgSendFormModel,
          isReadyToClaim: true,
          passedSeconds: state.passedSeconds,
        ),
      );
    }
  }

  Future<void> claim({required String passphrase}) async {
    if (!state.isReadyToClaim || state.isClaiming) {
      return;
    }
    final recipient = state.msgSendFormModel!.recipientWalletAddress!;
    emit(TransferClaimState(signedTx: state.signedTx, msgSendFormModel: state.msgSendFormModel, isClaiming: true));
    if (recipient is EthereumWalletAddress) {
      await _ethereumService.importContractTokens(passphrase: passphrase);
    } else {
      // TODO: call interx for status, but it'll be claimed automatically
    }
    emit(TransferClaimState(signedTx: state.signedTx, msgSendFormModel: state.msgSendFormModel, navigateToInput: true));
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}
