import 'package:torii_client/domain/models/network/error_explorer_model.dart';
import 'package:torii_client/presentation/transfer/tx_broadcast/cubit/a_tx_broadcast_state.dart';

class TxBroadcastErrorState extends ATxBroadcastState {
  final ErrorExplorerModel errorExplorerModel;

  const TxBroadcastErrorState({required this.errorExplorerModel});

  @override
  List<Object?> get props => <Object?>[errorExplorerModel];
}
