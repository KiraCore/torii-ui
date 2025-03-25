import 'package:decimal/decimal.dart';
import 'package:torii_client/domain/models/transaction/signed_transaction_model.dart';
import 'package:torii_client/presentation/transfer/tx_process_cubit/a_tx_process_state.dart';
import 'package:torii_client/presentation/transfer/tx_process_cubit/states/tx_process_loaded_state.dart';

abstract class TxProcessBroadcastState extends ATxProcessState {
  final TxProcessLoadedState txProcessLoadedState;
  final String passphrase;

  const TxProcessBroadcastState({required this.txProcessLoadedState, required this.passphrase});

  @override
  List<Object?> get props => <Object>[txProcessLoadedState, passphrase];
}

class TxProcessBroadcastFromKiraState extends TxProcessBroadcastState {
  final SignedTxModel signedTxModel;

  const TxProcessBroadcastFromKiraState({
    required super.txProcessLoadedState,
    required super.passphrase,
    required this.signedTxModel,
  });

  @override
  List<Object?> get props => <Object?>[signedTxModel, ...super.props];
}

class TxProcessBroadcastFromEthState extends TxProcessBroadcastState {
  const TxProcessBroadcastFromEthState({
    required super.txProcessLoadedState,
    required super.passphrase,
    required this.kiraRecipient,
    required this.amountInEth,
  });

  final String kiraRecipient;
  final Decimal amountInEth;

  @override
  List<Object?> get props => <Object?>[kiraRecipient, amountInEth, ...super.props];
}
