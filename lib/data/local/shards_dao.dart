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

  Future<bool> dropData() async {
    return await _shards.clear();
  }
}
