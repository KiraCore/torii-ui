part of 'mnemonic_text_field_cubit.dart';

class MnemonicTextFieldState extends Equatable {
  final String mnemonicText;
  final MnemonicTextFieldStatus mnemonicTextFieldStatus;

  const MnemonicTextFieldState({required this.mnemonicText, required this.mnemonicTextFieldStatus});

  const MnemonicTextFieldState.empty() : mnemonicTextFieldStatus = MnemonicTextFieldStatus.empty, mnemonicText = '';

  MnemonicTextFieldState copyWith({String? mnemonicText, MnemonicTextFieldStatus? mnemonicTextFieldStatus}) {
    return MnemonicTextFieldState(
      mnemonicText: mnemonicText ?? this.mnemonicText,
      mnemonicTextFieldStatus: mnemonicTextFieldStatus ?? this.mnemonicTextFieldStatus,
    );
  }

  @override
  List<Object?> get props => <Object?>[mnemonicText, mnemonicTextFieldStatus];
}
