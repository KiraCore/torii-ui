import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:torii_client/domain/models/connection/connection_error_type.dart';
import 'package:torii_client/presentation/network/bloc/events/network_module_disconnect_event.dart';
import 'package:torii_client/presentation/network/bloc/network_module_bloc.dart';
import 'package:torii_client/presentation/network/bloc/network_module_state.dart';
import 'package:torii_client/utils/network/status/a_network_status_model.dart';
import 'package:torii_client/utils/network/status/network_offline_model.dart';
import 'package:torii_client/utils/network/status/online/network_healthy_model.dart';
import 'package:torii_client/utils/network/status/online/network_unhealthy_model.dart';

part 'loading_page_state.dart';

@injectable
class LoadingPageCubit extends Cubit<LoadingPageState> {
  final NetworkModuleBloc _networkModuleBloc;
  late final StreamSubscription<NetworkModuleState> _networkModuleStateSubscription;

  LoadingPageCubit(this._networkModuleBloc) : super(const LoadingPageState()) {
    _init();
  }

  @override
  Future<void> close() {
    _networkModuleStateSubscription.cancel();
    return super.close();
  }

  void cancelConnection() {
    _networkModuleBloc.add(NetworkModuleDisconnectEvent());
  }

  Future<void> _init() async {
    await _networkModuleBloc.initializationCompleter.future;

    emit(LoadingPageState(networkStatusModel: _networkModuleBloc.state.networkStatusModel));
    _networkModuleStateSubscription = _networkModuleBloc.stream.listen(_handleNetworkModuleStateChanged);
  }

  Future<void> _handleNetworkModuleStateChanged(NetworkModuleState networkModuleState) async {
    ANetworkStatusModel networkStatusModel = networkModuleState.networkStatusModel;

    if (networkStatusModel is NetworkHealthyModel) {
      emit(LoadingPageState(networkStatusModel: networkStatusModel, isConnected: true, canBeCanceled: true));
    } else {
      // TODO: wtf?
      _networkModuleBloc.add(NetworkModuleDisconnectEvent());

      ConnectionErrorType? connectionErrorType;

      if (networkStatusModel is NetworkUnhealthyModel) {
        connectionErrorType = ConnectionErrorType.serverUnhealthy;
      } else if (networkStatusModel is NetworkOfflineModel) {
        connectionErrorType = ConnectionErrorType.serverOffline;
      }

      emit(
        LoadingPageState(
          networkStatusModel: networkStatusModel,
          connectionErrorType: connectionErrorType,
          canBeCanceled: true,
        ),
      );
    }
  }
}
