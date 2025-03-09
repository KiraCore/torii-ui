import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:hex/hex.dart';
import 'package:torii_client/domain/exports.dart';
import 'package:torii_client/utils/exports.dart';

class CosmosEncryptedKeyfileModel extends AEncryptedKeyfileModel {
  final String version;
  final String encryptedSecretData;
  final Uint8List publicKey;

  const CosmosEncryptedKeyfileModel({
    required this.version,
    required this.encryptedSecretData,
    required this.publicKey,
  });

  factory CosmosEncryptedKeyfileModel.fromEntity(CosmosKeyfileEntity keyfileEntity) {
    return CosmosEncryptedKeyfileModel(
      version: keyfileEntity.version,
      encryptedSecretData: keyfileEntity.secretData,
      publicKey: base64Decode(keyfileEntity.publicKey),
    );
  }

  @override
  Future<CosmosDecryptedKeyfileModel> decrypt(String password) async {
    bool passwordValidBool = Aes256.verifyPassword(password, encryptedSecretData);
    if (passwordValidBool == false) {
      throw const KeyfileException(KeyfileExceptionType.wrongPassword);
    }

    late KeyfileSecretDataEntity keyfileSecretDataEntity;
    try {
      Map<String, dynamic> secretDataJson =
          jsonDecode(Aes256.decrypt(password, encryptedSecretData)) as Map<String, dynamic>;
      keyfileSecretDataEntity = KeyfileSecretDataEntity.fromJson(secretDataJson);
    } catch (_) {
      throw Exception('KeyfileException: invalidKeyfile');
    }

    return CosmosDecryptedKeyfileModel(
      version: version,
      keyfileSecretDataModel: KeyfileSecretDataModel(
        wallet: Wallet(
          address: CosmosWalletAddress.fromPublicKey(publicKey),
          ecPrivateKey: ECPrivateKey.fromBytes(
            HEX.decode(keyfileSecretDataEntity.privateKey),
            CurvePoints.generatorSecp256k1,
          ),
        ),
      ),
    );
  }

  @override
  List<Object?> get props => <Object>[version, encryptedSecretData, publicKey];
}
