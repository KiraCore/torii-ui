import 'package:equatable/equatable.dart';

import 'cosmos_keyfile_entity.dart';
import 'ethereum_keyfile_entity.dart';

abstract class AKeyfileEntity extends Equatable {
  const AKeyfileEntity();

  factory AKeyfileEntity.fromJson(Map<String, dynamic> json) {
    try {
      return CosmosKeyfileEntity.fromJson(json);
    } catch (_) {
      return EthereumKeyfileEntity.fromJson(json);
    }
  }

  Map<String, dynamic> toJson();

  @override
  List<Object?> get props => <Object>[];
}
