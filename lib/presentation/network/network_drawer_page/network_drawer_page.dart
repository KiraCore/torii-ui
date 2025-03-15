import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:torii_client/presentation/network/bloc/network_module_bloc.dart';
import 'package:torii_client/presentation/network/bloc/network_module_state.dart';
import 'package:torii_client/presentation/network/widgets/network_custom_section/network_custom_section.dart';
import 'package:torii_client/presentation/network/widgets/network_list.dart';
import 'package:torii_client/presentation/widgets/drawer/drawer_subtitle.dart';
import 'package:torii_client/utils/exports.dart';

class NetworkDrawerPage extends StatelessWidget {
  const NetworkDrawerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NetworkModuleBloc, NetworkModuleState>(
      builder: (context, NetworkModuleState networkModuleState) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DrawerTitle(title: S.of(context).networkChoose, tooltipMessage: S.of(context).networkList),
              const SizedBox(height: 28),
              NetworkList(arrowEnabledBool: false, moduleState: networkModuleState),
              NetworkCustomSection(arrowEnabledBool: false, moduleState: networkModuleState),
              const SizedBox(height: 150),
            ],
          ),
        );
      },
    );
  }
}
