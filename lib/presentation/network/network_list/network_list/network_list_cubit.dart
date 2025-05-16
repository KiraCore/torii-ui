import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:torii_client/presentation/network/network_list/network_list/a_network_list_state.dart';
import 'package:torii_client/presentation/network/network_list/network_list/states/network_list_loaded_state.dart';
import 'package:torii_client/presentation/network/network_list/network_list/states/network_list_initial_state.dart';
import 'package:torii_client/utils/network/app_config.dart';
import 'package:torii_client/utils/network/network_utils.dart';
import 'package:torii_client/utils/network/status/a_network_status_model.dart';

@singleton
class NetworkListCubit extends Cubit<ANetworkListState> {
  NetworkListCubit(this._appConfig) : super(NetworkListInitialState());

  final AppConfig _appConfig;

  List<ANetworkStatusModel> networkStatusModelList = List<ANetworkStatusModel>.empty(growable: true);

  @PostConstruct()
  void initNetworkStatusModelList() {
    networkStatusModelList = List<ANetworkStatusModel>.from(_appConfig.networkList);
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
