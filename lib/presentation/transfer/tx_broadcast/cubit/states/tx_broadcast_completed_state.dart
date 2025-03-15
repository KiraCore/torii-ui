import 'package:torii_client/domain/models/transaction/broadcast_resp_model.dart';
import 'package:torii_client/presentation/transfer/tx_broadcast/cubit/a_tx_broadcast_state.dart';

class TxBroadcastCompletedState extends ATxBroadcastState {
  final BroadcastRespModel broadcastRespModel;

  const TxBroadcastCompletedState({required this.broadcastRespModel});

  @override
  List<Object?> get props => <Object>[broadcastRespModel];
}
