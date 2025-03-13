import 'package:torii_client/presentation/network/bloc/a_network_module_event.dart';
import 'package:torii_client/utils/network/status/network_unknown_model.dart';

class NetworkModuleAutoConnectEvent extends ANetworkModuleEvent {
  final NetworkUnknownModel networkUnknownModel;

  const NetworkModuleAutoConnectEvent(this.networkUnknownModel);

  @override
  List<Object?> get props => <Object?>[networkUnknownModel];
}
