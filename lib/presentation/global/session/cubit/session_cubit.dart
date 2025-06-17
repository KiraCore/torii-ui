import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:torii_client/domain/exports.dart';

part 'session_state.dart';

@singleton
class SessionCubit extends Cubit<SessionState> {
  SessionCubit() : super(SessionState());

  void signIn(Wallet wallet) {
    if (wallet.isEthereum) {
      emit(SessionState(ethereumWallet: wallet, kiraWallet: state.kiraWallet));
    } else {
      emit(SessionState(kiraWallet: wallet, ethereumWallet: state.ethereumWallet));
    }
  }

  void signOutKira() {
    emit(state.copyWith(kiraWallet: () => null));
  }

  void signOutEthereum() {
    emit(state.copyWith(ethereumWallet: () => null));
  }
}
