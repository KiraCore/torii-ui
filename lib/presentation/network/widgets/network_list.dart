import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:torii_client/presentation/network/bloc/network_module_state.dart';
import 'package:torii_client/presentation/network/network_list/network_list/a_network_list_state.dart';
import 'package:torii_client/presentation/network/network_list/network_list/network_list_cubit.dart';
import 'package:torii_client/presentation/network/network_list/network_list/states/network_list_loaded_state.dart';
import 'package:torii_client/presentation/network/widgets/network_list_tile.dart';
import 'package:torii_client/presentation/widgets/exports.dart';
import 'package:torii_client/presentation/widgets/loading/center_load_spinner.dart';
import 'package:torii_client/utils/exports.dart';
import 'package:torii_client/utils/network/network_utils.dart';
import 'package:torii_client/utils/network/status/a_network_status_model.dart';

class NetworkList extends StatelessWidget {
  final bool arrowEnabledBool;
  final ValueChanged<ANetworkStatusModel>? onConnected;
  final ANetworkStatusModel? hiddenNetworkStatusModel;
  final Widget? emptyListWidget;
  final NetworkModuleState moduleState;

  const NetworkList({
    required this.arrowEnabledBool,
    this.onConnected,
    this.hiddenNetworkStatusModel,
    this.emptyListWidget,
    required this.moduleState,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NetworkListCubit, ANetworkListState>(
      bloc: getIt<NetworkListCubit>(),
      builder: (_, ANetworkListState networkListState) {
        if (networkListState is NetworkListLoadedState) {
          List<ANetworkStatusModel> visibleNetworkStatusModelList = _getVisibleNetworkStatusModelList(networkListState);
          if (visibleNetworkStatusModelList.isEmpty && emptyListWidget != null) {
            return emptyListWidget!;
          }
          return ListView.builder(
            controller: ScrollController(),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: visibleNetworkStatusModelList.length,
            itemBuilder: (_, int index) {
              ANetworkStatusModel currentNetwork = visibleNetworkStatusModelList[index];
              return NetworkListTile(
                networkStatusModel: currentNetwork,
                moduleState: moduleState,
                arrowEnabledBool: arrowEnabledBool,
              );
            },
          );
        } else {
          return const CenterLoadSpinner();
        }
      },
    );
  }

  List<ANetworkStatusModel> _getVisibleNetworkStatusModelList(NetworkListLoadedState networkListLoadedState) {
    List<ANetworkStatusModel> availableNetworkStatusModelList = networkListLoadedState.networkStatusModelList;
    if (hiddenNetworkStatusModel == null) {
      return availableNetworkStatusModelList;
    } else {
      List<ANetworkStatusModel> visibleNetworkStatusModelList =
          availableNetworkStatusModelList.where((ANetworkStatusModel networkStatusModel) {
            bool networkStatusModelVisibleBool =
                NetworkUtils.compareUrisByUrn(networkStatusModel.uri, hiddenNetworkStatusModel!.uri) == false;
            return networkStatusModelVisibleBool;
          }).toList();
      return visibleNetworkStatusModelList;
    }
  }
}
