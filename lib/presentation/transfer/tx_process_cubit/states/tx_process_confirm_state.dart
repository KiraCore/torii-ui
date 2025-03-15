import 'package:torii_client/domain/models/transaction/signed_transaction_model.dart';
import 'package:torii_client/presentation/transfer/tx_process_cubit/a_tx_process_state.dart';
import 'package:torii_client/presentation/transfer/tx_process_cubit/states/tx_process_loaded_state.dart';

class TxProcessConfirmState extends ATxProcessState {
  final TxProcessLoadedState txProcessLoadedState;
  final SignedTxModel signedTxModel;

  const TxProcessConfirmState({required this.txProcessLoadedState, required this.signedTxModel});

  @override
  List<Object?> get props => <Object>[txProcessLoadedState, signedTxModel];
}
