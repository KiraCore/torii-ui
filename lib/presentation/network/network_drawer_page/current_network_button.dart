import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:torii_client/main.dart';
import 'package:torii_client/presentation/network/bloc/network_module_bloc.dart';
import 'package:torii_client/presentation/network/bloc/network_module_state.dart';
import 'package:torii_client/presentation/network/network_list/network_custom_section/network_custom_section_cubit.dart';
import 'package:torii_client/presentation/network/widgets/network_status_icon.dart';
import 'package:torii_client/presentation/widgets/kira_tooltip.dart';
import 'package:torii_client/presentation/widgets/mouse_state_listener.dart';
import 'package:torii_client/utils/exports.dart';
import 'package:torii_client/utils/network/app_config.dart';
import 'package:torii_client/utils/network/status/a_network_status_model.dart';

class CurrentNetworkButton extends StatelessWidget {
  final NetworkCustomSectionCubit _networkCustomSectionCubit = getIt<NetworkCustomSectionCubit>();
  final Size size;
  final bool disabled;

  CurrentNetworkButton({this.size = const Size(200, 40), this.disabled = !kiraEthEnabled, super.key});

  @override
  Widget build(BuildContext context) {
    final widget = BlocConsumer<NetworkModuleBloc, NetworkModuleState>(
      bloc: getIt<NetworkModuleBloc>(),
      listener: (_, NetworkModuleState networkModuleState) {
        if (networkModuleState.networkStatusModel.connectionStatusType == ConnectionStatusType.autoConnected) {
          router.createUrlContextWithRpcAtInit();
        }
      },
      builder: (_, NetworkModuleState networkModuleState) {
        ANetworkStatusModel networkStatusModel = networkModuleState.networkStatusModel;

        return MouseStateListener(
          disabled: disabled,
          onTap: disabled ? null : () => _openDrawerNetworkPage(context),
          disableSplash: true,
          childBuilder: (Set<WidgetState> states) {
            Color foregroundColor = _selectForegroundColor(states);
            Color backgroundColor = _selectBackgroundColor(states);

            return Container(
              width: size.width,
              height: size.height,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: backgroundColor,
                border: Border.all(color: foregroundColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  NetworkStatusIcon(networkStatusModel: networkStatusModel, size: 13),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        networkStatusModel.name,
                        overflow: TextOverflow.ellipsis,
                        textDirection: TextDirection.ltr,
                        style: const TextStyle(
                          height: 1,
                          color: DesignColors.white1,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.more_vert, color: foregroundColor, size: 16),
                ],
              ),
            );
          },
        );
      },
    );

    if (disabled) {
      return Opacity(opacity: 0.3, child: KiraToolTip.kiraNotSupported(childMargin: EdgeInsets.zero, child: widget));
    }
    return widget;
  }

  void _openDrawerNetworkPage(BuildContext context) {
    router.push(const NetworkDrawerRoute().location);
    _networkCustomSectionCubit.resetSwitchValueWhenConnected();
  }

  Color _selectForegroundColor(Set<WidgetState> states) {
    if (disabled) {
      return DesignColors.greyOutline;
    }
    if (states.contains(WidgetState.hovered) || states.contains(WidgetState.pressed)) {
      return DesignColors.white1;
    }
    return DesignColors.greyOutline;
  }

  Color _selectBackgroundColor(Set<WidgetState> states) {
    if (states.contains(WidgetState.hovered) || states.contains(WidgetState.pressed)) {
      return DesignColors.greyHover2;
    }
    return Colors.transparent;
  }
}
