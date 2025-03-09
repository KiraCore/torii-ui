import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:torii_client/utils/exports.dart';

part 'mnemonic_hint_state.dart';

class MnemonicHintCubit extends Cubit<MnemonicHintState> {
  MnemonicHintCubit() : super(const MnemonicHintState.empty(placeholderVisibleBool: true));

  void clearHint({required bool placeholderVisibleBool}) {
    emit(MnemonicHintState.empty(placeholderVisibleBool: placeholderVisibleBool));
  }

  void updateHint({required String wordPattern}) {
    if (wordPattern.isEmpty) {
      emit(const MnemonicHintState.empty(placeholderVisibleBool: true));
      return;
    }

    String matchedMnemonicWord = Bip39Extension.findMnemonicWord(wordPattern);

    if (matchedMnemonicWord.isEmpty) {
      emit(const MnemonicHintState.empty(placeholderVisibleBool: false));
    } else {
      String hintText = matchedMnemonicWord.replaceFirst(wordPattern, '');
      emit(MnemonicHintState(hintText: hintText));
    }
  }
}
