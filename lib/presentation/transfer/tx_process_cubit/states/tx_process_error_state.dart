import 'package:torii_client/presentation/transfer/tx_process_cubit/a_tx_process_state.dart';

class TxProcessErrorState extends ATxProcessState {
  final bool accountErrorBool;

  const TxProcessErrorState({this.accountErrorBool = false});
}
