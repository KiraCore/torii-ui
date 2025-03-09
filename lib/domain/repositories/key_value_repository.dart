import 'package:injectable/injectable.dart';
import 'package:torii_client/domain/exports.dart';
import 'package:torii_client/utils/exports.dart';
import 'package:torii_client/data/exports.dart';

@injectable
class KeyValueRepository {
  final ShardsDao _shardsDao;

  const KeyValueRepository(this._shardsDao);

  EthereumSignatureDecodeResult? readEthSignatureResult(String ethereumAddress) {
    try {
      return EthereumSignatureDecodeResult.fromDataJson(
        _shardsDao.readEthSignatureResult(ethereumAddress)!,
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
}
