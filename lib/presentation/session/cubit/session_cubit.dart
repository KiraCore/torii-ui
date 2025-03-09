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
      emit(SessionState(ethereumWallet: wallet));
    } else {
      emit(SessionState(kiraWallet: wallet));
    }
  }

  void signOutKira() {
    emit(state.copyWith(ethereumWallet: () => null));
  }

  void signOutEthereum() {
    emit(state.copyWith(ethereumWallet: () => null));
  }
}
