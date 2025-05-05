import 'package:torii_client/domain/models/network/network_properties_model.dart';
import 'package:torii_client/domain/models/tokens/token_amount_model.dart';
import 'package:torii_client/presentation/transfer/tx_process_cubit/a_tx_process_state.dart';

class TxProcessReadyToSignState extends ATxProcessState {
  final TokenAmountModel feeTokenAmountModel;
  final NetworkPropertiesModel networkPropertiesModel;

  const TxProcessReadyToSignState({required this.feeTokenAmountModel, required this.networkPropertiesModel});

  @override
  List<Object?> get props => <Object>[feeTokenAmountModel, networkPropertiesModel];
}
