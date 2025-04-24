import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:torii_client/presentation/network/bloc/network_module_bloc.dart';
import 'package:torii_client/presentation/network/bloc/network_module_state.dart';
import 'package:torii_client/presentation/network/widgets/network_custom_section/network_custom_section.dart';
import 'package:torii_client/presentation/network/widgets/network_list.dart';
import 'package:torii_client/presentation/widgets/drawer/drawer_subtitle.dart';
import 'package:torii_client/utils/exports.dart';
import 'package:torii_client/utils/network/app_config.dart';

class NetworkDrawerPage extends StatelessWidget {
  const NetworkDrawerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return BlocBuilder<NetworkModuleBloc, NetworkModuleState>(
      builder: (context, NetworkModuleState networkModuleState) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DrawerTitle(
                title:
                    networkModuleState.networkStatusModel.connectionStatusType == ConnectionStatusType.connected
                        ? 'Connected to INTERX'
                        : 'Connect to INTERX',
              ),
              const SizedBox(height: 16),
              NetworkList(arrowEnabledBool: false, moduleState: networkModuleState),
              NetworkCustomSection(arrowEnabledBool: false, moduleState: networkModuleState),
              const SizedBox(height: 28),
              Text('Examples:', style: textTheme.titleMedium!.copyWith(color: DesignColors.white2)),
              const SizedBox(height: 10),
              Text('https, without proxy:', style: textTheme.bodySmall!.copyWith(color: DesignColors.grey1)),
              SelectableText(
                'https://123.45.67.89:11000/',
                style: textTheme.bodyMedium!.copyWith(color: DesignColors.white2),
              ),
              const SizedBox(height: 10),
              Text(
                'http (our https proxy will be applied):',
                style: textTheme.bodySmall!.copyWith(color: DesignColors.grey1),
              ),
              SelectableText(
                'http://123.45.67.89:11000/',
                style: textTheme.bodyMedium!.copyWith(color: DesignColors.white2),
              ),
              const SizedBox(height: 10),
              Text('your custom https proxy:', style: textTheme.bodySmall!.copyWith(color: DesignColors.grey1)),
              SelectableText(
                'https://your-proxy.com/http://123.45.67.89:11000/',
                style: textTheme.bodyMedium!.copyWith(color: DesignColors.white2),
              ),
              const SizedBox(height: 150),
            ],
          ),
        );
      },
    );
  }
}
