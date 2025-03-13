import 'package:torii_client/presentation/network/network_list/network_list/a_network_list_state.dart';
import 'package:torii_client/utils/network/status/a_network_status_model.dart';

class NetworkListLoadedState extends ANetworkListState {
  final List<ANetworkStatusModel> networkStatusModelList;

  NetworkListLoadedState({required List<ANetworkStatusModel> networkStatusModelList})
    : networkStatusModelList = List<ANetworkStatusModel>.from(networkStatusModelList);

  @override
  List<Object> get props => <Object>[networkStatusModelList];
}
