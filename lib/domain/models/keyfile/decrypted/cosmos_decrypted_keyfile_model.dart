import 'dart:convert';

import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:hex/hex.dart';
import 'package:torii_client/domain/exports.dart';
import 'package:torii_client/utils/exports.dart';

class CosmosDecryptedKeyfileModel extends ADecryptedKeyfileModel {
  static String latestKeyfileVersion = '2.0.0';
  final String? version;

  const CosmosDecryptedKeyfileModel({required super.keyfileSecretDataModel, this.version});

  @override
  Future<String> buildFileContent(String password) async {
    ECPrivateKey ecPrivateKey = keyfileSecretDataModel.wallet.ecPrivateKey!;
    KeyfileSecretDataEntity keyfileSecretDataEntity = KeyfileSecretDataEntity(
      privateKey: HEX.encode(ecPrivateKey.bytes),
    );

    String secretData = Aes256.encrypt(password, jsonEncode(keyfileSecretDataEntity.toJson()));
    CosmosKeyfileEntity keyfileEntity = CosmosKeyfileEntity(
      version: latestKeyfileVersion,
      publicKey: base64Encode(ecPrivateKey.ecPublicKey.compressed),
      secretData: secretData,
    );

    Map<String, dynamic> fileContentJson = keyfileEntity.toJson();
    JsonEncoder encoder = const JsonEncoder.withIndent('  ');
    String jsonContent = encoder.convert(fileContentJson);
    return jsonContent;
  }

  @override
  List<Object?> get props => <Object?>[...super.props, version];
}
