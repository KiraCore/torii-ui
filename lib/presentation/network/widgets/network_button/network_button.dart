import 'package:flutter/material.dart';
import 'package:torii_client/presentation/network/bloc/events/network_module_connect_event.dart';
import 'package:torii_client/presentation/network/bloc/events/network_module_disconnect_event.dart';
import 'package:torii_client/presentation/network/bloc/network_module_bloc.dart';
import 'package:torii_client/presentation/network/widgets/network_button/network_connect_button.dart';
import 'package:torii_client/presentation/network/widgets/network_button/network_selected_button.dart';
import 'package:torii_client/utils/exports.dart';
import 'package:torii_client/utils/network/app_config.dart';
import 'package:torii_client/utils/network/status/a_network_status_model.dart';
import 'package:torii_client/utils/network/status/network_offline_model.dart';
import 'package:torii_client/utils/network/status/network_unknown_model.dart';
import 'package:torii_client/utils/network/status/online/a_network_online_model.dart';

class NetworkButton extends StatelessWidget {
  final ANetworkStatusModel networkStatusModel;

  const NetworkButton({
    required this.networkStatusModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    bool networkConnected = networkStatusModel.connectionStatusType.isConnected;
    bool networkConnecting = networkStatusModel.connectionStatusType.isConnecting;
    bool networkOnline = networkStatusModel is ANetworkOnlineModel;
    bool networkUnknown = networkStatusModel is NetworkUnknownModel;
    bool networkOffline = networkStatusModel is NetworkOfflineModel;

    if (networkConnected && networkOffline) {
      return SizedBox(
        width: double.infinity,
        child: Text(
          S.of(context).networkServerOffline,
          style: textTheme.bodySmall!.copyWith(color: DesignColors.redStatus1),
        ),
      );
    } else if (networkConnected) {
      return NetworkSelectedButton(networkStatusModel: networkStatusModel, title: 'Disconnect', onPressed: _disconnect,
      );
    } else if (networkConnecting) {
      return NetworkSelectedButton(
        networkStatusModel: networkStatusModel,
        title: S.of(context).networkButtonConnecting,
      );
    } else if (networkOnline) {
      return NetworkConnectButton(networkStatusModel: networkStatusModel, onPressed: _handleConnectToNetworkPressed);
    } else if (networkUnknown) {
      return NetworkConnectButton(networkStatusModel: networkStatusModel, opacity: 0.6, onPressed: null);
    } else {
      return Text(
        S.of(context).networkErrorCannotConnect,
        style: textTheme.bodySmall!.copyWith(color: DesignColors.redStatus1),
      );
    }
  }

  Future<void> _handleConnectToNetworkPressed() async {
    ANetworkStatusModel networkStatusModelToConnect = networkStatusModel;
    bool networkConnected = networkStatusModelToConnect.connectionStatusType.isConnected;
    if (networkStatusModelToConnect is ANetworkOnlineModel && !networkConnected) {
      getIt<NetworkModuleBloc>().add(NetworkModuleConnectEvent(networkStatusModelToConnect));
      
      // TODO: fix bug - we should wait for init of rpc url in browser url controller
      await Future.delayed(const Duration(milliseconds: 100));
      router.createUrlContextWithRpcAtInit();
    }
  }

  void _disconnect() async {
    getIt<NetworkModuleBloc>().add(NetworkModuleDisconnectEvent());

    // TODO: fix bug - we should wait for init of rpc url in browser url controller
    await Future.delayed(const Duration(milliseconds: 100));
    router.createUrlContextWithRpcAtInit();
  }
}
