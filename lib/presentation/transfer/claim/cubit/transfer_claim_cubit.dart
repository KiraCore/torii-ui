import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:torii_client/data/dto/api/query_transactions/request/query_transactions_req.dart';
import 'package:torii_client/data/dto/api_request_model.dart';
import 'package:torii_client/domain/exports.dart';
import 'package:torii_client/domain/models/messages/msg_send_model.dart';
import 'package:torii_client/domain/models/page_data.dart';
import 'package:torii_client/domain/models/tokens/list/tx_list_item_model.dart';
import 'package:torii_client/domain/models/transaction/signed_transaction_model.dart';
import 'package:torii_client/domain/models/transaction/tx_local_info_model.dart';
import 'package:torii_client/domain/repositories/api_torii_repository.dart';
import 'package:torii_client/domain/services/torii_logs_service.dart';
import 'package:torii_client/presentation/global/logs/torii_logs_cubit.dart';
import 'package:torii_client/presentation/global/session/cubit/session_cubit.dart';
import 'package:torii_client/utils/di/locator.dart';
import 'package:torii_client/utils/exports.dart';

part 'transfer_claim_state.dart';

@injectable
class TransferClaimCubit extends Cubit<TransferClaimState> {
  TransferClaimCubit(this._sessionCubit, this._ethereumService, this._toriiLogsCubit)
    : super(
        TransferClaimState(
          signedTx: null,
          msgSendFormModel: null,
          pendingSenderTransaction: null,
          pendingRecipientTransaction: null,
        ),
      );

  final SessionCubit _sessionCubit;
  final EthereumService _ethereumService;
  final ToriiLogsCubit _toriiLogsCubit;

  // TODO: temp way, add listener to the signedTx
  Timer? _timer;

  /// If [msgSendFormModel] is null, we need to check pending txs for the recipient
  void init({
    required TxListItemModel? signedTx,
    required MsgSendFormModel? msgSendFormModel,
    required TxListItemModel? pendingSenderTransaction,
    required TxListItemModel? pendingRecipientTransaction,
  }) async {
    emit(
      TransferClaimState(
        signedTx: signedTx,
        msgSendFormModel: msgSendFormModel,
        pendingSenderTransaction: pendingSenderTransaction,
        pendingRecipientTransaction: pendingRecipientTransaction,
        isLoading: true,
      ),
    );

    if (msgSendFormModel == null && pendingSenderTransaction == null && pendingRecipientTransaction == null) {
      emit(
        TransferClaimState(
          signedTx: signedTx,
          msgSendFormModel: msgSendFormModel,
          pendingSenderTransaction: pendingSenderTransaction,
          pendingRecipientTransaction: pendingRecipientTransaction,
          navigateToInput: true,
        ),
      );
      return;
    }
    try {
      final txToProcess = state.txToProcess;
      // TODO: listen for changes
      final loggedInEth = _sessionCubit.state.ethereumWallet;
      if ((loggedInEth != null && txToProcess?.txMsgModels.firstOrNull?.toWalletAddress == loggedInEth.address) ||
          (signedTx == null && msgSendFormModel != null)) {
        final passedSeconds = DateTime.now().toUtc().difference(txToProcess!.time.toUtc()).inSeconds;
        final isReadyToClaim = passedSeconds >= 60;
        emit(
          TransferClaimState(
            signedTx: state.signedTx,
            msgSendFormModel: state.msgSendFormModel,
            pendingSenderTransaction: state.pendingSenderTransaction,
            pendingRecipientTransaction: state.pendingRecipientTransaction,
            shouldBeManuallyClaimed: true,
            // TODO: temp remainingSeconds
            remainingSeconds: 60 - passedSeconds,
            isReadyToClaim: isReadyToClaim,
          ),
        );
        if (!isReadyToClaim) {
          _signUpToClaim();
        }
      } else if (txToProcess?.txMsgModels.firstOrNull?.toWalletAddress is CosmosWalletAddress) {
        emit(
          TransferClaimState(
            signedTx: state.signedTx,
            msgSendFormModel: state.msgSendFormModel,
            pendingSenderTransaction: state.pendingSenderTransaction,
            pendingRecipientTransaction: state.pendingRecipientTransaction,
            isClaiming: true,
          ),
        );
        _signUpToWait();
      } else if (txToProcess != null) {
        emit(
          TransferClaimState(
            signedTx: state.signedTx,
            msgSendFormModel: state.msgSendFormModel,
            pendingSenderTransaction: state.pendingSenderTransaction,
            pendingRecipientTransaction: state.pendingRecipientTransaction,
            waitForRecipientToClaim: true,
          ),
        );
        _signUpToWait();
      }
    } catch (e) {
      getIt<Logger>().e('TransferClaimCubit: Cannot parse init() $e');
      emit(
        TransferClaimState(
          signedTx: signedTx,
          msgSendFormModel: msgSendFormModel,
          pendingSenderTransaction: pendingSenderTransaction,
          pendingRecipientTransaction: pendingRecipientTransaction,
          isError: true,
        ),
      );
      return;
    }
  }

  void forceReloadTransactions() {
    _toriiLogsCubit.reload();
  }

  void reloadTransactions({
    required TxListItemModel? pendingSenderTransaction,
    required TxListItemModel? pendingRecipientTransaction,
  }) {
    // TODO: reload only transactions
    init(
      signedTx: state.signedTx,
      msgSendFormModel: state.msgSendFormModel,
      pendingSenderTransaction: pendingSenderTransaction,
      pendingRecipientTransaction: pendingRecipientTransaction,
    );
  }

  void refresh() {
    // TODO: loading state
    _toriiLogsCubit.reload();
  }

  // todo delete?
  void refreshIsReadyToClaim() {
    if (state.passedSeconds > 10) {
      emit(
        TransferClaimState(
          signedTx: state.signedTx,
          msgSendFormModel: state.msgSendFormModel,
          isReadyToClaim: true,
          shouldBeManuallyClaimed: true,
          passedSeconds: state.passedSeconds,
          pendingSenderTransaction: state.pendingSenderTransaction,
          pendingRecipientTransaction: state.pendingRecipientTransaction,
        ),
      );
    }
  }

  void _signUpToClaim() {
    emit(
      TransferClaimState(
        signedTx: state.signedTx,
        msgSendFormModel: state.msgSendFormModel,
        pendingSenderTransaction: state.pendingSenderTransaction,
        pendingRecipientTransaction: state.pendingRecipientTransaction,
        shouldBeManuallyClaimed: true,
        remainingSeconds: state.remainingSeconds,
        isReadyToClaim: state.isReadyToClaim,
      ),
    );
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
          remainingSeconds: state.remainingSeconds - 1,
          pendingSenderTransaction: state.pendingSenderTransaction,
          pendingRecipientTransaction: state.pendingRecipientTransaction,
          shouldBeManuallyClaimed: true,
          // TODO: temp way, fix this
          isReadyToClaim: state.remainingSeconds <= 1,
        ),
      );
    });
  }

  void _signUpToWait() {
    emit(
      TransferClaimState(
        signedTx: state.signedTx,
        msgSendFormModel: state.msgSendFormModel,
        pendingSenderTransaction: state.pendingSenderTransaction,
        pendingRecipientTransaction: state.pendingRecipientTransaction,
        waitForRecipientToClaim: state.waitForRecipientToClaim,
        isClaiming: state.isClaiming,
      ),
    );
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // TODO: check status from ToriiLogs
      // if (state.passedSeconds > 10) {
      //   emit(
      //     TransferClaimState(
      //       signedTx: state.signedTx,
      //       msgSendFormModel: state.msgSendFormModel,
      //       passedSeconds: state.passedSeconds + 1,
      //       pendingSenderTransaction: state.pendingSenderTransaction,
      //       pendingRecipientTransaction: state.pendingRecipientTransaction,
      //       waitForRecipientToClaim: state.waitForRecipientToClaim,
      //       isClaiming: state.isClaiming,
      //     ),
      //   );
      //   return;
      // }
      emit(
        TransferClaimState(
          signedTx: state.signedTx,
          msgSendFormModel: state.msgSendFormModel,
          passedSeconds: state.passedSeconds + 1,
          pendingSenderTransaction: state.pendingSenderTransaction,
          pendingRecipientTransaction: state.pendingRecipientTransaction,
          waitForRecipientToClaim: state.waitForRecipientToClaim,
          isClaiming: state.isClaiming,
        ),
      );
    });
  }

  Future<void> claim({required String passphrase}) async {
    if (!state.isReadyToClaim || state.isClaiming || _sessionCubit.state.ethereumWallet == null) {
      return;
    }
    final recipient = _sessionCubit.state.ethereumWallet!.address;
    emit(
      TransferClaimState(
        signedTx: state.signedTx,
        msgSendFormModel: state.msgSendFormModel,
        pendingSenderTransaction: state.pendingSenderTransaction,
        pendingRecipientTransaction: state.pendingRecipientTransaction,
        passedSeconds: state.passedSeconds,
        shouldBeManuallyClaimed: state.shouldBeManuallyClaimed,
        isClaiming: true,
      ),
    );
    try {
      if (recipient is EthereumWalletAddress) {
        await _ethereumService.importContractTokens(passphrase: passphrase);
      } else {
        // dead code in this case
        getIt<Logger>().e('TransferClaimCubit: claim() recipient is not EthereumWalletAddress');
      }
      emit(
        TransferClaimState(
          signedTx: state.signedTx,
          msgSendFormModel: state.msgSendFormModel,
          pendingSenderTransaction: state.pendingSenderTransaction,
          pendingRecipientTransaction: state.pendingRecipientTransaction,
          passedSeconds: state.passedSeconds,
          shouldBeManuallyClaimed: state.shouldBeManuallyClaimed,
          navigateToInput: true,
        ),
      );
    } catch (e) {
      getIt<Logger>().e('TransferClaimCubit: claim() $e');
      emit(
        TransferClaimState(
          signedTx: state.signedTx,
          msgSendFormModel: state.msgSendFormModel,
          pendingSenderTransaction: state.pendingSenderTransaction,
          pendingRecipientTransaction: state.pendingRecipientTransaction,
          passedSeconds: state.passedSeconds,
          shouldBeManuallyClaimed: state.shouldBeManuallyClaimed,
          isError: true,
          isReadyToClaim: true,
        ),
      );
    }
  }

  void claimErrorHandled() {
    emit(
      TransferClaimState(
        signedTx: state.signedTx,
        msgSendFormModel: state.msgSendFormModel,
        pendingSenderTransaction: state.pendingSenderTransaction,
        pendingRecipientTransaction: state.pendingRecipientTransaction,
        passedSeconds: state.passedSeconds,
        isReadyToClaim: true,
        shouldBeManuallyClaimed: true,
      ),
    );
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}
