import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:torii_client/domain/exports.dart';
import 'package:torii_client/domain/services/miro/network_module_service.dart';
import 'package:torii_client/presentation/network/bloc/a_network_module_event.dart';
import 'package:torii_client/presentation/network/bloc/events/network_module_auto_connect_event.dart';
import 'package:torii_client/presentation/network/bloc/events/network_module_connect_event.dart';
import 'package:torii_client/presentation/network/bloc/events/network_module_disconnect_event.dart';
import 'package:torii_client/presentation/network/bloc/events/network_module_init_event.dart';
import 'package:torii_client/presentation/network/bloc/events/network_module_refresh_event.dart';
import 'package:torii_client/presentation/network/network_list/network_custom_section/network_custom_section_cubit.dart';
import 'package:torii_client/presentation/network/network_list/network_list/network_list_cubit.dart';
import 'package:torii_client/presentation/network/bloc/network_module_state.dart';
import 'package:torii_client/presentation/session/cubit/session_cubit.dart';
import 'package:torii_client/utils/browser/rpc_browser_url_controller.dart';
import 'package:torii_client/utils/exports.dart';
import 'package:torii_client/utils/network/app_config.dart';
import 'package:torii_client/utils/network/network_utils.dart';
import 'package:torii_client/utils/network/status/a_network_status_model.dart';
import 'package:torii_client/utils/network/status/network_empty_model.dart';
import 'package:torii_client/utils/network/status/network_unknown_model.dart';
import 'package:torii_client/utils/network/status/online/a_network_online_model.dart';

@singleton
class NetworkModuleBloc extends Bloc<ANetworkModuleEvent, NetworkModuleState> {
  final Completer<void> initializationCompleter = Completer<void>();

  final AppConfig _appConfig;
  final NetworkListCubit _networkListCubit;
  final NetworkCustomSectionCubit _networkCustomSectionCubit;
  final NetworkModuleService _networkModuleService;
  final RpcBrowserUrlController _rpcBrowserUrlController;
  final KeyValueRepository _keyValueRepository;

  late Timer _timer;
  TokenDefaultDenomModel tokenDefaultDenomModel = TokenDefaultDenomModel.empty();

  NetworkModuleBloc(
    this._networkModuleService,
    this._networkListCubit,
    this._networkCustomSectionCubit,
    this._rpcBrowserUrlController,
    this._keyValueRepository,
    this._appConfig,
  ) : super(NetworkModuleState.disconnected()) {
    on<NetworkModuleInitEvent>(_mapInitEventToState);
    on<NetworkModuleRefreshEvent>(_mapRefreshEventToState);
    on<NetworkModuleAutoConnectEvent>(_mapAutoConnectEventToState);
    on<NetworkModuleConnectEvent>(_mapConnectEventToState);
    on<NetworkModuleDisconnectEvent>(_mapDisconnectEventToState);
    if (_rpcBrowserUrlController.getRpcAddress() != null || _appConfig.getDefaultNetworkUnknownModel() != null) {
      add(NetworkModuleInitEvent());
    }
  }

  @override
  Future<void> close() async {
    _timer.cancel();
    await super.close();
  }

  void _mapInitEventToState(NetworkModuleInitEvent networkModuleInitEvent, Emitter<NetworkModuleState> emit) {
    NetworkUnknownModel? defaultNetworkUnknownModel = _appConfig.getDefaultNetworkUnknownModel();
    if (defaultNetworkUnknownModel != null) {
      add(NetworkModuleAutoConnectEvent(defaultNetworkUnknownModel));
      _updateNetworkStatusModelList(ignoreNetworkUnknownModel: defaultNetworkUnknownModel);
    }

    _timer = Timer.periodic(_appConfig.refreshInterval, (Timer timer) {
      add(NetworkModuleRefreshEvent());
    });
  }

  Future<void> _mapRefreshEventToState(
    NetworkModuleRefreshEvent networkModuleRefreshEvent,
    Emitter<NetworkModuleState> emit,
  ) async {
    if (state.networkStatusModel is NetworkEmptyModel || state.isRefreshing) {
      _updateNetworkStatusModelList();
    } else {
      emit(NetworkModuleState.refreshing(state.networkStatusModel));
      NetworkUnknownModel networkUnknownModel = NetworkUnknownModel.fromNetworkStatusModel(state.networkStatusModel);
      ANetworkStatusModel networkStatusModel = await _networkModuleService.getNetworkStatusModel(networkUnknownModel);

      _networkListCubit.setNetworkStatusModel(networkStatusModel: networkStatusModel);
      _updateNetworkStatusModelList(ignoreNetworkUnknownModel: networkUnknownModel);

      bool networkUnchangedBool = networkStatusModel.uri == state.networkStatusModel.uri;
      if (networkUnchangedBool) {
        _networkCustomSectionCubit.updateNetworks(networkStatusModel);
        emit(NetworkModuleState.connected(networkStatusModel));
        _refreshTokenDefaultDenomModel(networkStatusModel);
        await _checkIfSignOutNeeded();
      }
    }

    await _networkCustomSectionCubit.refreshNetworks();
  }

  Future<void> _mapAutoConnectEventToState(
    NetworkModuleAutoConnectEvent networkModuleAutoConnectEvent,
    Emitter<NetworkModuleState> emit,
  ) async {
    NetworkUnknownModel networkUnknownModel = networkModuleAutoConnectEvent.networkUnknownModel;
    emit(NetworkModuleState.connecting(networkUnknownModel));

    if (initializationCompleter.isCompleted == false) {
      initializationCompleter.complete();
    }
    ANetworkStatusModel networkStatusModel = await _networkModuleService.getNetworkStatusModel(networkUnknownModel);
    _networkListCubit.setNetworkStatusModel(networkStatusModel: networkStatusModel);

    bool networkUnchangedBool = NetworkUtils.compareUrisByUrn(networkStatusModel.uri, state.networkStatusModel.uri);

    if (networkUnchangedBool) {
      _rpcBrowserUrlController.setRpcAddress(networkStatusModel);
      _networkCustomSectionCubit.updateNetworks(networkStatusModel);
      emit(NetworkModuleState.autoConnected(networkStatusModel));
      _refreshTokenDefaultDenomModel(networkStatusModel);
    } else {
      _networkCustomSectionCubit.updateNetworks();
    }
  }

  Future<void> _mapConnectEventToState(
    NetworkModuleConnectEvent networkModuleConnectEvent,
    Emitter<NetworkModuleState> emit,
  ) async {
    ANetworkOnlineModel networkOnlineModel = networkModuleConnectEvent.networkOnlineModel;
    _rpcBrowserUrlController.setRpcAddress(networkOnlineModel);
    _networkCustomSectionCubit.updateNetworks(networkOnlineModel);
    if (networkOnlineModel.uri != null) {
      await _keyValueRepository.addNetworkToList(networkOnlineModel.uri!);
    }
    emit(NetworkModuleState.connected(networkOnlineModel));
    _switchTokenDefaultDenomModel(networkOnlineModel);
    await _checkIfSignOutNeeded();
  }

  Future<void> _mapDisconnectEventToState(
    NetworkModuleDisconnectEvent networkModuleDisconnectEvent,
    Emitter<NetworkModuleState> emit,
  ) async {
    _rpcBrowserUrlController.removeRpcAddress();
    _networkCustomSectionCubit.updateNetworks(null);
    emit(NetworkModuleState.disconnected());
  }

  Future<void> _checkIfSignOutNeeded() async {
    SessionCubit sessionCubit = getIt<SessionCubit>();
    if (tokenDefaultDenomModel.valuesFromNetworkExistBool == false && sessionCubit.state.isKiraLoggedIn) {
      sessionCubit.signOutKira();
    }
  }

  void _refreshTokenDefaultDenomModel(ANetworkStatusModel networkStatusModel) {
    bool networkOnlineBool = networkStatusModel is ANetworkOnlineModel;
    bool emptyTokenDefaultDenomModelBool = tokenDefaultDenomModel.valuesFromNetworkExistBool == false;
    if (networkOnlineBool && emptyTokenDefaultDenomModelBool) {
      tokenDefaultDenomModel = tokenDefaultDenomModel.copyWith(networkStatusModel.tokenDefaultDenomModel);
    }
  }

  void _switchTokenDefaultDenomModel(ANetworkStatusModel networkStatusModel) {
    if (networkStatusModel is ANetworkOnlineModel) {
      tokenDefaultDenomModel = tokenDefaultDenomModel.copyWith(networkStatusModel.tokenDefaultDenomModel);
    }
  }

  void _updateNetworkStatusModelList({NetworkUnknownModel? ignoreNetworkUnknownModel}) {
    List<ANetworkStatusModel> networkStatusModelList = _networkListCubit.networkStatusModelList;
    for (ANetworkStatusModel networkStatusModel in networkStatusModelList) {
      bool networkNotIgnoredBool = networkStatusModel.uri != ignoreNetworkUnknownModel?.uri;
      if (networkNotIgnoredBool && networkStatusModel.connectionStatusType != ConnectionStatusType.refreshing) {
        _updateNetworkStatusModel(networkUnknownModel: NetworkUnknownModel.fromNetworkStatusModel(networkStatusModel));
      }
    }
  }

  Future<void> _updateNetworkStatusModel({required NetworkUnknownModel networkUnknownModel}) async {
    ANetworkStatusModel networkStatusModel = await _networkModuleService.getNetworkStatusModel(networkUnknownModel);
    _networkListCubit.setNetworkStatusModel(networkStatusModel: networkStatusModel);
  }
}
