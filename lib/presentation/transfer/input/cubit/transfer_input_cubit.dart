import 'package:decimal/decimal.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:torii_client/domain/models/tokens/token_alias_model.dart';
import 'package:torii_client/domain/models/tokens/token_amount_model.dart';
import 'package:torii_client/domain/models/wallet/wallet.dart';
import 'package:torii_client/domain/services/ethereum_service.dart';
import 'package:torii_client/presentation/session/cubit/session_cubit.dart';

part 'transfer_input_state.dart';

@injectable
class TransferInputCubit extends Cubit<TransferInputState> {
  final SessionCubit _sessionCubit;
  final EthereumService _ethereumService;

  TransferInputCubit(this._sessionCubit, this._ethereumService)
    : super(TransferInputState(fromWallet: _sessionCubit.state.kiraWallet ?? _sessionCubit.state.ethereumWallet!)) {
    _initEthBalanceEmitWallet(state.fromWallet);
  }

  Future<void> _initEthBalanceEmitWallet(Wallet fromWallet) async {
    if (fromWallet == _sessionCubit.state.ethereumWallet) {
      final int? balance = await _ethereumService.getBalance(_sessionCubit.state.ethereumWallet!.address.address);
      if (balance != null) {
        emit(
          TransferInputState(
            fromWallet: fromWallet,
            balance: TokenAmountModel(
              defaultDenominationAmount: Decimal.fromInt(balance),
              tokenAliasModel: TokenAliasModel.local('ETH'),
            ),
          ),
        );
      } else {
        emit(TransferInputState(fromWallet: fromWallet));
      }
    }
  }

  Future<void> toggleFromWallet() async {
    if (state.fromWallet == _sessionCubit.state.kiraWallet && _sessionCubit.state.ethereumWallet != null) {
      _initEthBalanceEmitWallet(_sessionCubit.state.ethereumWallet!);
    } else if (state.fromWallet == _sessionCubit.state.ethereumWallet && _sessionCubit.state.kiraWallet != null) {
      emit(TransferInputState(fromWallet: _sessionCubit.state.kiraWallet!));
    }
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
