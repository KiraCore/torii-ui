import 'package:equatable/equatable.dart';
import 'package:torii_client/domain/exports.dart';

abstract class AEncryptedKeyfileModel extends Equatable {
  const AEncryptedKeyfileModel();

  factory AEncryptedKeyfileModel.fromEntity(AKeyfileEntity keyfileEntity) {
    if (keyfileEntity is CosmosKeyfileEntity) {
      return CosmosEncryptedKeyfileModel.fromEntity(keyfileEntity);
    } else if (keyfileEntity is EthereumKeyfileEntity) {
      return EthereumEncryptedKeyfileModel(ethereumKeyfileEntity: keyfileEntity);
    }
    throw Exception('KeyfileException: invalidKeyfile');
  }

  Future<ADecryptedKeyfileModel> decrypt(String password);

  @override
  List<Object?> get props => <Object>[];
}
