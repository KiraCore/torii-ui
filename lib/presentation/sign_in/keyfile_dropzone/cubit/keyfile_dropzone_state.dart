import 'package:equatable/equatable.dart';
import 'package:torii_client/domain/exports.dart';
import 'package:torii_client/utils/exports.dart';

class KeyfileDropzoneState extends Equatable {
  final AEncryptedKeyfileModel? encryptedKeyfileModel;
  final FileModel? fileModel;
  final KeyfileExceptionType? keyfileExceptionType;

  const KeyfileDropzoneState({this.encryptedKeyfileModel, this.fileModel, this.keyfileExceptionType});

  factory KeyfileDropzoneState.empty() {
    return const KeyfileDropzoneState();
  }

  bool get hasFile => fileModel != null;

  bool get hasKeyfile => encryptedKeyfileModel != null;

  @override
  List<Object?> get props => <Object?>[encryptedKeyfileModel, fileModel, keyfileExceptionType];
}
