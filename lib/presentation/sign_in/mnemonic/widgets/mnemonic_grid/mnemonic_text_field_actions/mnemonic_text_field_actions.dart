import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:torii_client/presentation/sign_in/mnemonic/text_field/mnemonic_text_field_cubit.dart';
import 'package:torii_client/presentation/widgets/kira_context_menu/kira_context_menu.dart';
import 'package:torii_client/presentation/widgets/kira_context_menu/kira_context_menu_item.dart';
import 'package:torii_client/utils/exports.dart';

import 'actions/accept_mnemonic_hint_action.dart';
import 'actions/accept_mnemonic_hint_intent.dart';
import 'actions/paste_mnemonic_action.dart';
import 'actions/paste_mnemonic_intent.dart';

class MnemonicTextFieldActions extends StatelessWidget {
  final Widget child;
  final MnemonicTextFieldCubit mnemonicTextFieldCubit;

  const MnemonicTextFieldActions({required this.child, required this.mnemonicTextFieldCubit, super.key});

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (PointerDownEvent event) => _handlePointerDown(context, event),
      child: Shortcuts(
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.tab): AcceptMnemonicHintIntent(),
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyV): PasteMnemonicIntent(),
          LogicalKeySet(LogicalKeyboardKey.paste): PasteMnemonicIntent(),
        },
        child: Actions(
          actions: <Type, Action<Intent>>{
            AcceptMnemonicHintIntent: AcceptMnemonicHintAction(mnemonicTextFieldCubit: mnemonicTextFieldCubit),
            PasteMnemonicIntent: PasteMnemonicAction(
              pasteIndex: mnemonicTextFieldCubit.index,
              mnemonicGridCubit: mnemonicTextFieldCubit.mnemonicGridCubit,
            ),
          },
          child: child,
        ),
      ),
    );
  }

  Future<void> _handlePointerDown(BuildContext context, PointerDownEvent event) async {
    bool secondaryMouseButtonPressedBool =
        event.kind == PointerDeviceKind.mouse && event.buttons == kSecondaryMouseButton;
    if (secondaryMouseButtonPressedBool) {
      await _showContextMenu(context, event.position);
    }
  }

  Future<void> _showContextMenu(BuildContext context, Offset position) async {
    await KiraContextMenu.of(context).show(
      position: position,
      kiraContextMenuItems: <KiraContextMenuItem>[
        KiraContextMenuItem(label: S.of(context).paste, iconData: Icons.content_paste, onTap: _pasteClipboard),
      ],
    );
  }

  void _pasteClipboard() {
    PasteMnemonicAction(
      pasteIndex: mnemonicTextFieldCubit.index,
      mnemonicGridCubit: mnemonicTextFieldCubit.mnemonicGridCubit,
    ).invoke(PasteMnemonicIntent());
  }
}
