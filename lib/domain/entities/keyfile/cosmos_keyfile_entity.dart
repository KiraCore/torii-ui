import 'package:logger/logger.dart';
import 'package:torii_client/utils/di/locator.dart';

import 'a_keyfile_entity.dart';

class CosmosKeyfileEntity extends AKeyfileEntity {
  final String version;
  final String publicKey;
  final String secretData;

  const CosmosKeyfileEntity({required this.version, required this.publicKey, required this.secretData});

  factory CosmosKeyfileEntity.fromJson(Map<String, dynamic> json) {
    try {
      return CosmosKeyfileEntity(
        version: json['version'] as String,
        publicKey: json['public_key'] as String,
        secretData: json['secret_data'] as String,
      );
    } catch (e) {
      getIt<Logger>().e('Error on CosmosKeyfileEntity.fromJson: $e');
      throw Exception('KeyfileException: invalidKeyfile');
    }
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{'version': version, 'public_key': publicKey, 'secret_data': secretData};
  }

  @override
  List<Object?> get props => <Object>[version, publicKey, secretData];
}
