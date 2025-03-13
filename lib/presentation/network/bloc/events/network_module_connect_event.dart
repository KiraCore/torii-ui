import 'package:torii_client/presentation/network/bloc/a_network_module_event.dart';
import 'package:torii_client/utils/network/status/online/a_network_online_model.dart';

class NetworkModuleConnectEvent extends ANetworkModuleEvent {
  final ANetworkOnlineModel networkOnlineModel;

  const NetworkModuleConnectEvent(this.networkOnlineModel);

  @override
  List<Object?> get props => <Object?>[networkOnlineModel];
}
