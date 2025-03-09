import 'package:flutter/material.dart';
import 'package:torii_client/presentation/sign_in/mnemonic/text_field/mnemonic_text_field_cubit.dart';

import 'accept_mnemonic_hint_intent.dart';

class AcceptMnemonicHintAction extends Action<AcceptMnemonicHintIntent> {
  final MnemonicTextFieldCubit mnemonicTextFieldCubit;

  AcceptMnemonicHintAction({required this.mnemonicTextFieldCubit}) : super();

  @override
  void invoke(AcceptMnemonicHintIntent intent) {
    mnemonicTextFieldCubit.focusNode?.nextFocus();
    mnemonicTextFieldCubit.acceptHint();
  }
}
