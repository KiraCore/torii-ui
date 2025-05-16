import 'package:flutter/material.dart';
import 'package:torii_client/presentation/network/bloc/network_module_state.dart';
import 'package:torii_client/presentation/network/widgets/network_button/network_button.dart';
import 'package:torii_client/presentation/network/widgets/network_list_tile_content.dart';
import 'package:torii_client/presentation/network/widgets/network_list_tile_title.dart';
import 'package:torii_client/utils/exports.dart';
import 'package:torii_client/utils/network/app_config.dart';
import 'package:torii_client/utils/network/network_utils.dart';
import 'package:torii_client/utils/network/status/a_network_status_model.dart';

class NetworkListTile extends StatefulWidget {
  final bool arrowEnabledBool;
  final ANetworkStatusModel networkStatusModel;
  final NetworkModuleState moduleState;

  const NetworkListTile({
    required this.arrowEnabledBool,
    required this.networkStatusModel,
    required this.moduleState,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _NetworkListTile();
}

class _NetworkListTile extends State<NetworkListTile> {
  Color outlineColor = DesignColors.greyOutline;

  @override
  Widget build(BuildContext context) {
    ANetworkStatusModel networkStatusModel = widget.networkStatusModel;
    bool networksEqualBool = NetworkUtils.compareUrisByUrn(
      networkStatusModel.uri,
      widget.moduleState.networkStatusModel.uri,
    );
    if (networksEqualBool) {
      networkStatusModel = widget.moduleState.networkStatusModel;
    }
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: _selectBorderColor(networkStatusModel)),
        color: _selectBackgroundColor(networkStatusModel),
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Wrap(
        children: <Widget>[
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent, splashColor: Colors.transparent),
            child: ExpansionTile(
              title: NetworkListTileTitle(networkStatusModel: networkStatusModel),
              iconColor: DesignColors.white1,
              onExpansionChanged: _swapBorderColor,
              children: <Widget>[NetworkListTileContent(networkStatusModel: networkStatusModel)],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              const SizedBox(width: 35),
              Expanded(
                child: NetworkButton(
                  networkStatusModel: networkStatusModel,
                  arrowEnabledBool: widget.arrowEnabledBool,
                  onConnected: (networkStatusModel) {
                    router.createUrlContextWithRpcAtInit();
                  },
                ),
              ),
              const SizedBox(width: 35),
            ],
          ),
        ],
      ),
    );
  }

  void _swapBorderColor(bool expandedStatus) {
    if (expandedStatus) {
      setState(() {
        outlineColor = DesignColors.white1;
      });
    } else {
      setState(() {
        outlineColor = DesignColors.greyOutline;
      });
    }
  }

  Color _selectBorderColor(ANetworkStatusModel networkStatusModel) {
    switch (networkStatusModel.connectionStatusType) {
      case ConnectionStatusType.connected:
      case ConnectionStatusType.refreshing:
        return networkStatusModel.statusColor;
      default:
        return outlineColor;
    }
  }

  Color _selectBackgroundColor(ANetworkStatusModel networkStatusModel) {
    switch (networkStatusModel.connectionStatusType) {
      case ConnectionStatusType.disconnected:
        return Colors.transparent;
      default:
        return networkStatusModel.statusColor.withOpacity(0.1);
    }
  }
}
