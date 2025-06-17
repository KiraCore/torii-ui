// todo: refactor
import 'package:injectable/injectable.dart';
import 'package:torii_client/domain/repositories/key_value_repository.dart';
import 'package:torii_client/utils/browser/rpc_browser_url_controller.dart';
import 'package:torii_client/utils/exports.dart';
import 'package:torii_client/utils/network/network_utils.dart';
import 'package:torii_client/utils/network/status/network_unknown_model.dart';

@singleton
class AppConfig {
  final KeyValueRepository _keyValueRepository;
  final Uri proxyServerUri;
  final int bulkSinglePageSize;
  final Duration defaultApiCacheMaxAge;
  final Duration outdatedBlockDuration;
  final Duration loadingPageTimerDuration;
  final List<String> supportedInterxVersions;
  final RpcBrowserUrlController rpcBrowserUrlController;
  final int _refreshIntervalSeconds;

  late List<NetworkUnknownModel> _networkList = List<NetworkUnknownModel>.empty(growable: true);

  AppConfig({
    required this.proxyServerUri,
    required this.bulkSinglePageSize,
    required this.defaultApiCacheMaxAge,
    required this.outdatedBlockDuration,
    required this.loadingPageTimerDuration,
    required this.supportedInterxVersions,
    required this.rpcBrowserUrlController,
    required int refreshIntervalSeconds,
  }) : _refreshIntervalSeconds = refreshIntervalSeconds,
       _keyValueRepository = getIt<KeyValueRepository>();

  @factoryMethod
  factory AppConfig.buildDefaultConfig(RpcBrowserUrlController rpcBrowserUrlController) {
    return AppConfig(
      proxyServerUri: Uri.parse('https://cors.kira.network'),
      bulkSinglePageSize: 500,
      defaultApiCacheMaxAge: const Duration(seconds: 60),
      outdatedBlockDuration: const Duration(minutes: 5),
      loadingPageTimerDuration: const Duration(seconds: 4),
      supportedInterxVersions: <String>['v0.4.46', 'v0.4.48'],
      rpcBrowserUrlController: rpcBrowserUrlController,
      // TODO: decrease refresh interval
      refreshIntervalSeconds: 6000,
    );
  }

  int get refreshIntervalSeconds => _refreshIntervalSeconds;

  Duration get refreshInterval => Duration(seconds: _refreshIntervalSeconds);

  List<NetworkUnknownModel> get networkList => _networkList;

  @PostConstruct()
  void init() {
    _initNetworkList(_keyValueRepository.readNetworkList());
  }

  NetworkUnknownModel findNetworkModelInConfig(NetworkUnknownModel networkUnknownModel) {
    List<NetworkUnknownModel> matchingNetworkUnknownModels =
        networkList
            .where((NetworkUnknownModel e) => NetworkUtils.compareUrisByUrn(e.uri, networkUnknownModel.uri))
            .toList();

    if (matchingNetworkUnknownModels.isEmpty) {
      return networkUnknownModel;
    }
    return matchingNetworkUnknownModels.first;
  }

  NetworkUnknownModel? getDefaultNetworkUnknownModel() {
    NetworkUnknownModel? urlNetworkUnknownModel = _getNetworkUnknownModelFromUrl();
    if (urlNetworkUnknownModel == null) {
      if (networkList.isNotEmpty) {
        return networkList.first;
      }
      //  else if (rpcBrowserUrlController.getRpcAddress() != null) {
      //   return NetworkUnknownModel(
      //     uri: Uri.parse(rpcBrowserUrlController.getRpcAddress()),
      //     connectionStatusType: ConnectionStatusType.disconnected,
      //     lastRefreshDateTime: DateTime.now(),
      //   );
      // }
    }
    return urlNetworkUnknownModel;
  }

  bool isInterxVersionOutdated(String version) {
    bool isVersionSupported = supportedInterxVersions.contains(version);
    if (isVersionSupported) {
      return false;
    } else {
      getIt<Logger>().w('Interx version [$version] is not supported');
      return true;
    }
  }

  void _initNetworkList(List<Uri> networkListJson) {
    _networkList = List<NetworkUnknownModel>.empty(growable: true);
    for (Uri networkListItem in networkListJson) {
      _networkList.add(NetworkUnknownModel.fromUri(networkListItem));
    }
  }

  NetworkUnknownModel? _getNetworkUnknownModelFromUrl() {
    String? networkAddress = rpcBrowserUrlController.getRpcAddress();
    if (networkAddress == null) {
      return null;
    }
    Uri uri = NetworkUtils.parseUrlToInterxUri(networkAddress);
    NetworkUnknownModel urlNetworkUnknownModel = NetworkUnknownModel.fromUri(uri);
    urlNetworkUnknownModel = findNetworkModelInConfig(urlNetworkUnknownModel);
    return urlNetworkUnknownModel;
  }
}

enum ConnectionStatusType { connecting, autoConnected, connected, disconnected, refreshing }

extension ConnectionStatusTypeExtension on ConnectionStatusType {
  bool get isConnected =>
      this == ConnectionStatusType.autoConnected ||
      this == ConnectionStatusType.connected ||
      this == ConnectionStatusType.refreshing;

  bool get isDisconnected => this == ConnectionStatusType.disconnected;

  bool get isRefreshing => this == ConnectionStatusType.refreshing;

  bool get isConnecting => this == ConnectionStatusType.connecting;
}
