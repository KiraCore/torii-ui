import 'package:decimal/decimal.dart';
import 'package:torii_client/domain/models/transaction/signed_transaction_model.dart';
import 'package:torii_client/presentation/transfer/tx_process_cubit/a_tx_process_state.dart';
import 'package:torii_client/presentation/transfer/tx_process_cubit/states/tx_process_loaded_state.dart';

abstract class TxProcessConfirmState extends ATxProcessState {
  final TxProcessLoadedState txProcessLoadedState;

  const TxProcessConfirmState({required this.txProcessLoadedState});

  @override
  List<Object?> get props => <Object?>[txProcessLoadedState];
}

class TxProcessConfirmFromKiraState extends TxProcessConfirmState {
  final SignedTxModel signedTxModel;

  const TxProcessConfirmFromKiraState({required super.txProcessLoadedState, required this.signedTxModel});

  @override
  List<Object?> get props => <Object?>[signedTxModel, ...super.props];
}

class TxProcessConfirmFromEthState extends TxProcessConfirmState {
  final String kiraRecipient;
  final Decimal amountInEth;

  const TxProcessConfirmFromEthState({
    required super.txProcessLoadedState,
    required this.kiraRecipient,
    required this.amountInEth,
  });

  @override
  List<Object?> get props => <Object?>[kiraRecipient, amountInEth, ...super.props];
}
