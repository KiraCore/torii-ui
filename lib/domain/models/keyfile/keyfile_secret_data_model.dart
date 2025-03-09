import 'package:equatable/equatable.dart';
import 'package:torii_client/domain/exports.dart';

class KeyfileSecretDataModel extends Equatable {
  final Wallet wallet;

  const KeyfileSecretDataModel({required this.wallet});

  @override
  List<Object?> get props => <Object>[wallet];
}
