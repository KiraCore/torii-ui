import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:torii_client/presentation/network/network_list/network_list/a_network_list_state.dart';
import 'package:torii_client/presentation/network/network_list/network_list/states/network_list_loaded_state.dart';
import 'package:torii_client/presentation/network/network_list/network_list/states/network_list_loading_state.dart';
import 'package:torii_client/utils/exports.dart';
import 'package:torii_client/utils/network/app_config.dart';
import 'package:torii_client/utils/network/network_utils.dart';
import 'package:torii_client/utils/network/status/a_network_status_model.dart';

class NetworkListCubit extends Cubit<ANetworkListState> {
  final AppConfig appConfig = getIt<AppConfig>();

  List<ANetworkStatusModel> networkStatusModelList = List<ANetworkStatusModel>.empty(growable: true);

  NetworkListCubit() : super(NetworkListLoadingState());

  void initNetworkStatusModelList() {
    networkStatusModelList = List<ANetworkStatusModel>.from(appConfig.networkList);
    emit(NetworkListLoadedState(networkStatusModelList: networkStatusModelList));
  }

  void setNetworkStatusModel({required ANetworkStatusModel networkStatusModel}) {
    int networkStatusModelIndex = networkStatusModelList.indexWhere(
      (ANetworkStatusModel e) => NetworkUtils.compareUrisByUrn(e.uri, networkStatusModel.uri),
    );
    if (networkStatusModelIndex != -1) {
      networkStatusModelList[networkStatusModelIndex] = networkStatusModel;
      emit(NetworkListLoadedState(networkStatusModelList: networkStatusModelList));
    }
  }
}
