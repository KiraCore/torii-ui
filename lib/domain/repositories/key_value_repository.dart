import 'package:injectable/injectable.dart';
import 'package:torii_client/domain/exports.dart';
import 'package:torii_client/utils/exports.dart';
import 'package:torii_client/data/exports.dart';

@injectable
class KeyValueRepository {
  const KeyValueRepository(this._shardsDao);

  final ShardsDao _shardsDao;

  List<Uri> readNetworkList() {
    return _shardsDao.readNetworkList().map((e) => Uri.parse(e)).toList();
  }

  Future<void> addNetworkToList(Uri network) async {
    Set<String> networks = _shardsDao.readNetworkList().toSet();
    if (!networks.contains(network.toString())) {
      networks.add(network.toString());
      await _shardsDao.writeNetworkList(networks.toList());
    }
  }

  EthereumSignatureDecodeResult? readEthSignatureResult(String ethereumAddress) {
    try {
      final result = _shardsDao.readEthSignatureResult(ethereumAddress);
      if (result == null) {
        return null;
      }
      return EthereumSignatureDecodeResult.fromDataJson(
        result,
        ethAddress: ethereumAddress,
      );
    } catch (e) {
      getIt<Logger>().e('Error readEthSignatureResult: $e');
      return null;
    }
  }

  Future<void> writeEthSignatureResult(EthereumSignatureDecodeResult result) async {
    await _shardsDao.writeEthSignatureResult(ethereumAddress: result.ethAddress, result: result.toDataJson());
  }

  bool wasIntroShown() {
    return _shardsDao.wasIntroShown();
  }

  Future<void> setIntroShown() async {
    await _shardsDao.setIntroShown();
  }

  bool wasWkexAssetAdded() {
    return _shardsDao.wasWkexAssetAdded();
  }

  Future<void> setWkexAssetAdded() async {
    await _shardsDao.setWkexAssetAdded();
  }
}
