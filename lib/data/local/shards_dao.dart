import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@injectable
class ShardsDao {
  const ShardsDao(this._shards);

  final SharedPreferences _shards;

  static const _ethereumKey = 'signature_';

  Map<String, dynamic>? readEthSignatureResult(String ethereumAddressKey) {
    final result = _shards.getString('$_ethereumKey${ethereumAddressKey.toLowerCase()}');
    if (result == null) {
      return null;
    }
    return json.decode(result) as Map<String, dynamic>;
  }

  Future<void> writeEthSignatureResult({required String ethereumAddress, required Map<String, dynamic> result}) async {
    await _shards.setString('$_ethereumKey${ethereumAddress.toLowerCase()}', json.encode(result));
  }

  bool wasIntroShown() {
    return _shards.getBool('intro_shown') ?? false;
  }

  Future<void> setIntroShown() async {
    await _shards.setBool('intro_shown', true);
  }

  bool wasWkexAssetAdded() {
    return _shards.getBool('wkex_asset_added') ?? false;
  }

  Future<void> setWkexAssetAdded() async {
    await _shards.setBool('wkex_asset_added', true);
  }
  Future<bool> dropData() async {
    return await _shards.clear();
  }
}
