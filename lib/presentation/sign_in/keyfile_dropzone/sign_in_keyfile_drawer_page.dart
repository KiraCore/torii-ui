import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:torii_client/domain/exports.dart';
import 'package:torii_client/presentation/session/cubit/session_cubit.dart';
import 'package:torii_client/presentation/sign_in/keyfile_dropzone/cubit/keyfile_dropzone_state.dart';
import 'package:torii_client/presentation/sign_in/keyfile_dropzone/cubit/sign_in_keyfile_drawer_page_cubit.dart';
import 'package:torii_client/presentation/sign_in/keyfile_dropzone/keyfile_dropzone_preview.dart';
import 'package:torii_client/presentation/widgets/buttons/kira_elevated_button.dart';
import 'package:torii_client/presentation/widgets/drawer/drawer_subtitle.dart';
import 'package:torii_client/presentation/widgets/kira_dropzone/kira_dropzone.dart';
import 'package:torii_client/presentation/widgets/kira_text_field/kira_text_field.dart';
import 'package:torii_client/presentation/widgets/kira_text_field/kira_text_field_controller.dart';
import 'package:torii_client/utils/exports.dart';

import 'cubit/keyfile_dropzone_cubit.dart';

class SignInKeyfileDrawerPage extends StatefulWidget {
  const SignInKeyfileDrawerPage({super.key});

  @override
  State<StatefulWidget> createState() => _SignInKeyfileDrawerPage();
}

class _SignInKeyfileDrawerPage extends State<SignInKeyfileDrawerPage> {
  final KiraTextFieldController keyfileKiraTextFieldController = KiraTextFieldController();

  @override
  void dispose() {
    keyfileKiraTextFieldController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyfileDropzoneCubit = getIt<KeyfileDropzoneCubit>();
    return MultiBlocProvider(
      providers: [
        BlocProvider<KeyfileDropzoneCubit>(create: (_) => keyfileDropzoneCubit),
        BlocProvider<SignInKeyfileDrawerPageCubit>(
          create:
              (BuildContext context) => SignInKeyfileDrawerPageCubit(
                sessionCubit: context.read<SessionCubit>(),
                // NOTE: we need to pass the same instance of the cubit to the cubit and the provider
                keyfileDropzoneCubit: keyfileDropzoneCubit,
              ),
        ),
      ],
      child: BlocConsumer<SignInKeyfileDrawerPageCubit, SignInKeyfileDrawerPageState>(
        listener: (BuildContext context, SignInKeyfileDrawerPageState signInKeyfileDrawerPageState) {
          String? errorMessage = _selectTextFieldErrorMessage(signInKeyfileDrawerPageState.keyfileExceptionType);
          keyfileKiraTextFieldController.setErrorMessage(errorMessage);
          _selectDropzoneErrorMessage(signInKeyfileDrawerPageState.keyfileExceptionType);

          if (signInKeyfileDrawerPageState.signInSuccessBool) {
            router.pop();
          }
        },
        builder: (BuildContext context, SignInKeyfileDrawerPageState signInKeyfileDrawerPageState) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DrawerTitle(
                title: S.of(context).keyfileSignIn,
                subtitle: S.of(context).keyfileToDropzone,
                tooltipMessage: S.of(context).keyfileTipSecretData,
              ),
              const SizedBox(height: 37),
              BlocBuilder<KeyfileDropzoneCubit, KeyfileDropzoneState>(
                builder: (BuildContext context, KeyfileDropzoneState keyfileDropzoneState) {
                  KeyfileExceptionType? keyfileExceptionType = signInKeyfileDrawerPageState.keyfileExceptionType;

                  return KiraDropzone(
                    hasFileBool: keyfileDropzoneState.hasFile,
                    width: double.infinity,
                    height: 128,
                    emptyLabel: S.of(context).keyfileDropHere,
                    uploadViaHtmlFile: context.read<KeyfileDropzoneCubit>().uploadFileViaHtml,
                    uploadFileManually: context.read<KeyfileDropzoneCubit>().uploadFileManually,
                    errorMessage: _selectDropzoneErrorMessage(keyfileExceptionType),
                    filePreviewErrorBuilder: (String? errorMessage) {
                      return KeyfileDropzonePreview(
                        keyfileDropzoneState: keyfileDropzoneState,
                        errorMessage: errorMessage,
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              KiraTextField(
                controller: keyfileKiraTextFieldController,
                hint: S.of(context).keyfileEnterPassword,
                inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.deny(StringUtils.whitespacesRegExp)],
                obscureText: true,
              ),
              const SizedBox(height: 24),
              KiraElevatedButton(
                title: S.of(context).connectWalletButtonSignIn,
                disabled: signInKeyfileDrawerPageState.isLoading,
                onPressed:
                    () => context.read<SignInKeyfileDrawerPageCubit>().signIn(
                      keyfileKiraTextFieldController.textEditingController.text,
                    ),
              ),
              const SizedBox(height: 32),
            ],
          );
        },
      ),
    );
  }

  String? _selectDropzoneErrorMessage(KeyfileExceptionType? keyfileExceptionType) {
    if (keyfileExceptionType == KeyfileExceptionType.invalidKeyfile) {
      return S.of(context).keyfileErrorInvalid;
    } else {
      return null;
    }
  }

  String? _selectTextFieldErrorMessage(KeyfileExceptionType? keyfileExceptionType) {
    if (keyfileKiraTextFieldController.textEditingController.text.isEmpty) {
      return null;
    }
    return switch (keyfileExceptionType) {
      KeyfileExceptionType.wrongPassword => S.of(context).keyfileErrorWrongPassword,
      (_) => null,
    };
  }
}
