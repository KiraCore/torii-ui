import 'package:flutter/material.dart';
import 'package:torii_client/presentation/network/bloc/events/network_module_connect_event.dart';
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
  final bool arrowEnabledBool;
  final ANetworkStatusModel networkStatusModel;
  final ValueChanged<ANetworkStatusModel>? onConnected;

  const NetworkButton({required this.arrowEnabledBool, required this.networkStatusModel, this.onConnected, super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    bool networkConnected =
        networkStatusModel.connectionStatusType == ConnectionStatusType.connected ||
        networkStatusModel.connectionStatusType == ConnectionStatusType.refreshing;
    bool networkConnecting = networkStatusModel.connectionStatusType == ConnectionStatusType.connecting;
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
      return Row(
        children: <Widget>[
          NetworkSelectedButton(
            networkStatusModel: networkStatusModel,
            title: S.of(context).networkButtonConnected,
            onPressed: _handleConnectToNetworkPressed,
            clickableBool: arrowEnabledBool,
          ),
          if (arrowEnabledBool)
            IconButton(
              icon: const Icon(Icons.arrow_forward_outlined),
              tooltip: S.of(context).networkButtonArrowTip,
              onPressed: _handleConnectToNetworkPressed,
            ),
        ],
      );
    } else if (networkConnecting) {
      return NetworkSelectedButton(
        networkStatusModel: networkStatusModel,
        title: S.of(context).networkButtonConnecting,
        clickableBool: false,
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

  void _handleConnectToNetworkPressed() {
    ANetworkStatusModel networkStatusModelToConnect = networkStatusModel;
    bool networkConnectedBool =
        networkStatusModelToConnect.connectionStatusType == ConnectionStatusType.connected ||
        networkStatusModelToConnect.connectionStatusType == ConnectionStatusType.refreshing;
    if (networkStatusModelToConnect is ANetworkOnlineModel) {
      if (networkConnectedBool == false) {
        getIt<NetworkModuleBloc>().add(NetworkModuleConnectEvent(networkStatusModelToConnect));
      }
      onConnected?.call(networkStatusModelToConnect);
    }
  }
}
