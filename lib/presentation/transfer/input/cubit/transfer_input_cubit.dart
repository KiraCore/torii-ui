import 'package:decimal/decimal.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:torii_client/domain/exports.dart';
import 'package:torii_client/presentation/global/session/cubit/session_cubit.dart';
import 'package:torii_client/utils/extensions/tx_utils.dart';

part 'transfer_input_state.dart';

@injectable
class TransferInputCubit extends Cubit<TransferInputState> {
  final SessionCubit _sessionCubit;
  final EthereumService _ethereumService;

  TransferInputCubit(this._sessionCubit, this._ethereumService)
    : super(TransferInputState(fromWallet: _sessionCubit.state.kiraWallet ?? _sessionCubit.state.ethereumWallet!)) {
    init();
  }

  Future<void> init() async {
    _initEthBalanceEmitWallet(state.fromWallet);
  }

  Future<void> _initEthBalanceEmitWallet(Wallet fromWallet) async {
    if (fromWallet == _sessionCubit.state.ethereumWallet) {
      final Decimal? balance = await _ethereumService.getBalance(_sessionCubit.state.ethereumWallet!.address.address);
      if (balance != null) {
        emit(
          TransferInputState(
            fromWallet: fromWallet,
            recipientWalletAddress: _sessionCubit.state.kiraWallet?.address,
            balance: TokenAmountModel(
              defaultDenominationAmount: balance, tokenAliasModel: TokenAliasModel.wkex(),
            ),
            recipientTokenDenomination: TokenAliasModel.kex().baseTokenDenominationModel,
          ),
        );
      } else {
        emit(
          TransferInputState(
            fromWallet: fromWallet,
            recipientWalletAddress: _sessionCubit.state.kiraWallet?.address,
            recipientTokenDenomination: TokenAliasModel.kex().baseTokenDenominationModel,
          ),
        );
      }
    } else {
      emit(
        TransferInputState(
          fromWallet: fromWallet,
          recipientWalletAddress: _sessionCubit.state.ethereumWallet?.address,
          recipientTokenDenomination: TokenAliasModel.wkex().baseTokenDenominationModel,
        ),
      );
    }
  }

  Future<void> toggleFromWallet() async {
    if (state.fromWallet == _sessionCubit.state.kiraWallet && _sessionCubit.state.ethereumWallet != null) {
      _initEthBalanceEmitWallet(_sessionCubit.state.ethereumWallet!);
    } else if (state.fromWallet == _sessionCubit.state.ethereumWallet && _sessionCubit.state.kiraWallet != null) {
      emit(
        TransferInputState(
          fromWallet: _sessionCubit.state.kiraWallet!,
          recipientWalletAddress: state.fromWallet.address,
          recipientTokenDenomination: TokenAliasModel.wkex().baseTokenDenominationModel,
        ),
      );
    }
  }

  void updateRecipientWalletAddress(AWalletAddress? walletAddress) {
    emit(
      TransferInputState(
        fromWallet: state.fromWallet,
        balance: state.balance,
        senderAmount: state.senderAmount,
        recipientAmount: state.recipientAmount,
        recipientWalletAddress: walletAddress,
        recipientTokenDenomination: state.recipientTokenDenomination,
      ),
    );
  }

  // TODO: remove text controller
  void updateRecipientTokenDenomination(
    TokenDenominationModel tokenDenomination,
    TextEditingController recipientAmountController,
  ) {
    if (state.recipientAmount != null) {
      recipientAmountController.text = TxUtils.buildAmountString(
        state.recipientAmount!.getAmountInDenomination(tokenDenomination).toString(),
        tokenDenomination,
      );
    }
    emit(
      TransferInputState(
        fromWallet: state.fromWallet,
        balance: state.balance,
        senderAmount: state.senderAmount,
        recipientAmount: state.recipientAmount,
        recipientAmountText:
            state.recipientAmount != null
                ? TxUtils.buildAmountString(
                  state.recipientAmount!.getAmountInDenomination(tokenDenomination).toString(),
                  tokenDenomination,
                )
                : null,
        recipientWalletAddress: state.recipientWalletAddress,
        recipientTokenDenomination: tokenDenomination,
      ),
    );
  }

  void updateAmount({
    required TokenAmountModel senderAmount,
    required TokenAmountModel recipientAmount,
    required bool changedBySender,
  }) {
    emit(
      TransferInputState(
        fromWallet: state.fromWallet,
        balance: state.balance,
        senderAmount: senderAmount,
        recipientAmount: recipientAmount,
        recipientWalletAddress: state.recipientWalletAddress,
        recipientTokenDenomination: state.recipientTokenDenomination,
        changedBySender: changedBySender,
      ),
    );
  }

  Future<void> onAuthChanged() async {
    if (state.fromWallet == _sessionCubit.state.kiraWallet || state.fromWallet == _sessionCubit.state.ethereumWallet) {
      return;
    }
    if (_sessionCubit.state.isKiraLoggedIn) {
      _initEthBalanceEmitWallet(_sessionCubit.state.kiraWallet!);
    } else if (_sessionCubit.state.isEthereumLoggedIn) {
      _initEthBalanceEmitWallet(_sessionCubit.state.ethereumWallet!);
    }
  }
}
