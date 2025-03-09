import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:torii_client/domain/exports.dart';
import 'package:torii_client/presentation/session/cubit/session_cubit.dart';
import 'package:torii_client/presentation/sign_in/keyfile_dropzone/cubit/keyfile_dropzone_cubit.dart';
import 'package:torii_client/utils/exports.dart';

part 'sign_in_keyfile_drawer_page_state.dart';

@injectable
class SignInKeyfileDrawerPageCubit extends Cubit<SignInKeyfileDrawerPageState> {
  final SessionCubit sessionCubit;
  final KeyfileDropzoneCubit keyfileDropzoneCubit;

  SignInKeyfileDrawerPageCubit({required this.sessionCubit, required this.keyfileDropzoneCubit})
    : super(const SignInKeyfileDrawerPageState());

  Future<void> signIn(String password) async {
    if (state.isLoading || state.signInSuccessBool) {
      return;
    }
    try {
      emit(state.copyWith(isLoading: true));
      final decryptedKeyfile = await keyfileDropzoneCubit.state.encryptedKeyfileModel!.decrypt(password);
      sessionCubit.signIn(decryptedKeyfile.keyfileSecretDataModel.wallet);
      emit(state.copyWith(signInSuccessBool: true, isLoading: false));
    } catch (e) {
      getIt<Logger>().e('Cannot generate wallet: $e');
      emit(state.copyWith(keyfileExceptionType: KeyfileExceptionType.wrongPassword));
    }
  }
}
