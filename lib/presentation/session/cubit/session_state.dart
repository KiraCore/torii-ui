part of 'session_cubit.dart';

class SessionState extends Equatable {
  final Wallet? kiraWallet;
  final Wallet? ethereumWallet;

  const SessionState({this.kiraWallet, this.ethereumWallet});

  bool get isLoggedIn => kiraWallet != null || ethereumWallet != null;

  SessionState copyWith({Wallet? Function()? kiraWallet, Wallet? Function()? ethereumWallet}) {
    return SessionState(
      kiraWallet: kiraWallet?.call() ?? this.kiraWallet,
      ethereumWallet: ethereumWallet?.call() ?? this.ethereumWallet,
    );
  }

  @override
  List<Object?> get props => [kiraWallet, ethereumWallet];
}
