import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// todo: remove
class KiraTextFieldController extends ChangeNotifier {
  final ValueNotifier<String?> errorNotifier = ValueNotifier<String?>(null);
  final ValueNotifier<bool> obscureTextNotifier = ValueNotifier<bool>(false);
  final TextEditingController textEditingController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  void close() {
    errorNotifier.dispose();
    obscureTextNotifier.dispose();
    textEditingController.dispose();
    focusNode.dispose();
  }

  void reloadErrorMessage() {
    // TODO: test
    notifyListeners();
  }

  void setErrorMessage(String? errorMessage) {
    errorNotifier.value = errorMessage;
  }
}
