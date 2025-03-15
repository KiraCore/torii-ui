import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:torii_client/domain/models/connection/connection_error_model.dart';
import 'package:torii_client/domain/models/connection/connection_error_type.dart';
import 'package:torii_client/presentation/network/bloc/network_module_bloc.dart';
import 'package:torii_client/presentation/network/bloc/network_module_state.dart';
import 'package:torii_client/presentation/network/widgets/network_custom_section/network_custom_section.dart';
import 'package:torii_client/presentation/network/widgets/network_list.dart';
import 'package:torii_client/presentation/network/widgets/network_list_tile.dart';
import 'package:torii_client/utils/assets.dart';
import 'package:torii_client/utils/exports.dart';
import 'package:torii_client/utils/network/status/a_network_status_model.dart';
import 'package:torii_client/utils/network/status/network_empty_model.dart';

class NetworkListPage extends StatefulWidget {
  final ConnectionErrorType connectionErrorType;
  final ANetworkStatusModel? canceledNetworkStatusModel;

  const NetworkListPage({
    this.connectionErrorType = ConnectionErrorType.canceledByUser,
    this.canceledNetworkStatusModel,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _NetworkListPage();
}

class _NetworkListPage extends State<NetworkListPage> {
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ConnectionErrorModel? connectionErrorModel = _selectConnectionErrorModel();
    return Scaffold(
      body: BlocBuilder<NetworkModuleBloc, NetworkModuleState>(
        builder: (BuildContext context, NetworkModuleState networkModuleState) {
          return SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(top: 100), // AppSizes.defaultMobilePageMargin.copyWith(top: 100),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(width: 40, height: 42, child: Image.asset(Assets.assetsLogoSignet, fit: BoxFit.contain)),
                    const SizedBox(height: 16),

                    _NetworkHeadline(
                      textStyle: textTheme.displayLarge!.copyWith(color: DesignColors.white1),
                      networkModuleState: networkModuleState,
                    ),
                    const SizedBox(height: 4),
                    if (connectionErrorModel != null) ...<Widget>[
                      Text(
                        connectionErrorModel.message,
                        textAlign: TextAlign.center,
                        style: textTheme.bodyMedium!.copyWith(color: connectionErrorModel.color),
                      ),
                      const SizedBox(height: 16),
                    ],
                    if (_isAutoDisconnected == false) ...<Widget>[
                      Text(
                        S.of(context).networkSelectServers,
                        style: textTheme.bodyLarge!.copyWith(color: DesignColors.white1),
                      ),
                      const SizedBox(height: 10),
                    ],
                    Container(
                      width: MediaQuery.of(context).size.width,
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(height: 20),
                          if (_isAutoDisconnected) ...<Widget>[
                            Text(
                              S.of(context).networkServerToConnect,
                              style: textTheme.bodyLarge!.copyWith(color: DesignColors.white1),
                            ),
                            const SizedBox(height: 10),
                            NetworkListTile(
                              networkStatusModel: widget.canceledNetworkStatusModel!,
                              moduleState: networkModuleState,
                              arrowEnabledBool: true,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              S.of(context).networkOtherServers,
                              style: textTheme.bodyLarge!.copyWith(color: DesignColors.white1),
                            ),
                            const SizedBox(height: 10),
                          ],
                          NetworkList(
                            hiddenNetworkStatusModel: _isAutoDisconnected ? widget.canceledNetworkStatusModel : null,
                            moduleState: networkModuleState,
                            emptyListWidget: Text(
                              S.of(context).networkNoAvailable,
                              style: textTheme.bodyMedium!.copyWith(color: DesignColors.white2),
                            ),
                            arrowEnabledBool: true,
                          ),
                          NetworkCustomSection(arrowEnabledBool: true, moduleState: networkModuleState),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  ConnectionErrorModel? _selectConnectionErrorModel() {
    switch (widget.connectionErrorType) {
      case ConnectionErrorType.serverOffline:
        return ConnectionErrorModel(message: S.of(context).networkServerOfflineReason, color: DesignColors.redStatus1);
      case ConnectionErrorType.serverUnhealthy:
        return ConnectionErrorModel(message: S.of(context).networkProblemReason, color: DesignColors.yellowStatus1);
      default:
        return null;
    }
  }

  bool get _isAutoDisconnected {
    return widget.canceledNetworkStatusModel != null && widget.canceledNetworkStatusModel is! NetworkEmptyModel;
  }
}

class _NetworkHeadline extends StatelessWidget {
  final TextStyle textStyle;
  final NetworkModuleState networkModuleState;

  const _NetworkHeadline({required this.textStyle, required this.networkModuleState});

  @override
  Widget build(BuildContext context) {
    bool connectionCanceledBool = networkModuleState.isDisconnected;
    if (connectionCanceledBool) {
      return Text(S.of(context).networkConnectionCancelled, textAlign: TextAlign.center, style: textStyle);
    } else {
      return Text(S.of(context).networkConnectionEstablished, textAlign: TextAlign.center, style: textStyle);
    }
  }
}
