part of 'sign_in_keyfile_drawer_page_cubit.dart';

class SignInKeyfileDrawerPageState extends Equatable {
  final KeyfileExceptionType? keyfileExceptionType;
  final bool isLoading;
  final bool signInSuccessBool;

  const SignInKeyfileDrawerPageState({
    this.keyfileExceptionType,
    this.isLoading = false,
    this.signInSuccessBool = false,
  });

  SignInKeyfileDrawerPageState copyWith({
    KeyfileExceptionType? keyfileExceptionType,
    bool? isLoading,
    bool? signInSuccessBool,
  }) {
    return SignInKeyfileDrawerPageState(
      keyfileExceptionType: keyfileExceptionType ?? this.keyfileExceptionType,
      isLoading: isLoading ?? this.isLoading,
      signInSuccessBool: signInSuccessBool ?? this.signInSuccessBool,
    );
  }

  @override
  List<Object?> get props => <Object?>[keyfileExceptionType, isLoading, signInSuccessBool];
}
