import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:torii_client/domain/exports.dart';
import 'package:torii_client/presentation/session/cubit/session_cubit.dart';
import 'package:torii_client/presentation/sign_in/mnemonic/text_field/mnemonic_text_field_cubit.dart';
import 'package:torii_client/utils/exports.dart';

part 'mnemonic_grid_state.dart';

@injectable
class MnemonicGridCubit extends Cubit<MnemonicGridState> {
  final ValueNotifier<MnemonicValidationResult> mnemonicValidationResultNotifier =
      ValueNotifier<MnemonicValidationResult>(MnemonicValidationResult.mnemonicTooShort);
  final SessionCubit _sessionCubit;

  MnemonicGridCubit(this._sessionCubit) : super(MnemonicGridState.loading());

  @override
  Future<void> close() async {
    mnemonicValidationResultNotifier.dispose();
    for (MnemonicTextFieldCubit mnemonicTextFieldCubit in state.mnemonicTextFieldCubitList) {
      await mnemonicTextFieldCubit.close();
    }
    await super.close();
  }

  void init({required int initialMnemonicGridSize}) {
    List<MnemonicTextFieldCubit> mnemonicTextFieldCubitList = List<MnemonicTextFieldCubit>.generate(
      initialMnemonicGridSize,
      (int i) {
        return MnemonicTextFieldCubit(index: i, mnemonicGridCubit: this);
      },
    );
    emit(MnemonicGridState.loaded(mnemonicTextFieldCubitList: mnemonicTextFieldCubitList));
  }

  Future<void> signIn() async {
    final mnemonic = _buildMnemonicObject();
    if (mnemonic == null) {
      // TODO: show error state
      return;
    }
    // Complete all UI operations before heavy Wallet deriving
    await Future<void>.delayed(const Duration(milliseconds: 500));
    try {
      final wallet = await Wallet.derive(mnemonic: mnemonic);
      _sessionCubit.signIn(wallet);
    } catch (e) {
      getIt<Logger>().f('Cannot generate wallet');
      // TODO: show error state
    }
  }

  Mnemonic? _buildMnemonicObject() {
    try {
      return Mnemonic.fromArray(array: mnemonicPhraseList);
    } catch (e) {
      getIt<Logger>().e('Cannot create [Mnemonic] from given mnemonic phrase');
      return null;
    }
  }

  void updateMnemonicGridSize({required int mnemonicGridSize}) {
    List<MnemonicTextFieldCubit> previousMnemonicTextFieldCubitList = state.mnemonicTextFieldCubitList;
    List<MnemonicTextFieldCubit> mnemonicTextFieldCubitList = List<MnemonicTextFieldCubit>.empty(growable: true);

    for (int i = 0; i < mnemonicGridSize; i++) {
      bool mnemonicTextFieldExistsBool = i < previousMnemonicTextFieldCubitList.length;
      if (mnemonicTextFieldExistsBool) {
        MnemonicTextFieldCubit mnemonicTextFieldCubit = previousMnemonicTextFieldCubitList[i]..clear();
        mnemonicTextFieldCubitList.add(mnemonicTextFieldCubit);
      } else {
        mnemonicTextFieldCubitList.add(MnemonicTextFieldCubit(index: i, mnemonicGridCubit: this));
      }
    }

    emit(MnemonicGridState.loaded(mnemonicTextFieldCubitList: mnemonicTextFieldCubitList));
    validateGrid();
  }

  void insertMnemonicWords(int insertPosition, List<String> mnemonicWordsToInsert) {
    int calculatedInsertPosition = 0;
    int unchangedTextFieldsCount = state.mnemonicTextFieldCubitList.length - mnemonicWordsToInsert.length;
    if (unchangedTextFieldsCount > 0) {
      calculatedInsertPosition = _calculateInsertPosition(unchangedTextFieldsCount, insertPosition);
    }
    for (int i = 0; i < mnemonicWordsToInsert.length; i++) {
      int mnemonicTextFieldCubitIndex = calculatedInsertPosition + i;
      if (mnemonicTextFieldCubitIndex < state.mnemonicTextFieldCubitList.length) {
        state.mnemonicTextFieldCubitList[mnemonicTextFieldCubitIndex].setValue(mnemonicWordsToInsert[i]);
      }
    }
  }

  void validateGrid() {
    int mnemonicGridSize = state.mnemonicTextFieldCubitList.length;
    MnemonicValidationResult mnemonicValidationResult = Bip39Extension.validateMnemonic(
      mnemonicList: mnemonicPhraseList,
      mnemonicSize: mnemonicGridSize,
    );
    mnemonicValidationResultNotifier.value = mnemonicValidationResult;

    bool checksumInvalidBool = mnemonicValidationResult == MnemonicValidationResult.invalidChecksum;
    if (checksumInvalidBool) {
      state.mnemonicTextFieldCubitList.last.setErrorStatus();
    }
  }

  List<String> get mnemonicPhraseList {
    List<String> mnemonicWords =
        state.mnemonicTextFieldCubitList.map((MnemonicTextFieldCubit mnemonicTextFieldCubit) {
          return mnemonicTextFieldCubit.textEditingController.text;
        }).toList();
    return mnemonicWords;
  }

  int _calculateInsertPosition(int unchangedTextFieldsCount, int initialInsertPosition) {
    if (initialInsertPosition > unchangedTextFieldsCount) {
      return unchangedTextFieldsCount;
    } else {
      return initialInsertPosition;
    }
  }
}
