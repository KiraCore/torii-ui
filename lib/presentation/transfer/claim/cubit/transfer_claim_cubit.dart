import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:torii_client/domain/exports.dart';
import 'package:torii_client/domain/models/transaction/signed_transaction_model.dart';

part 'transfer_claim_state.dart';

@injectable
class TransferClaimCubit extends Cubit<TransferClaimState> {
  TransferClaimCubit(this._ethereumService) : super(TransferClaimState(signedTx: null, msgSendFormModel: null));

  final EthereumService _ethereumService;

  // TODO: temp way, add listener to the signedTx
  Timer? _timer;

  void init({required SignedTxModel? signedTx, required MsgSendFormModel msgSendFormModel}) {
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
    emit(TransferClaimState(signedTx: state.signedTx, msgSendFormModel: state.msgSendFormModel, isClaiming: true));
    print('claiming amount:');
    print(state.msgSendFormModel!.tokenAmountModel!.getAmountInBaseDenomination());
    if (state.signedTx == null) {
      // TODO: call interx for status, but it'll be claimed automatically
    } else {
      await _ethereumService.importContractTokens(passphrase: passphrase);
    }
    emit(TransferClaimState(signedTx: state.signedTx, msgSendFormModel: state.msgSendFormModel, isClaimed: true));
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}
