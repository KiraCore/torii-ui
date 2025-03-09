import 'package:equatable/equatable.dart';

import 'keyfile_exception_type.dart';

class KeyfileException extends Equatable implements Exception {
  final KeyfileExceptionType keyfileExceptionType;

  const KeyfileException(this.keyfileExceptionType);

  @override
  List<Object?> get props => <Object>[keyfileExceptionType];
}
