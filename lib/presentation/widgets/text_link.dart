import 'package:flutter/material.dart';
import 'package:torii_client/presentation/widgets/mouse_state_listener.dart';
import 'package:torii_client/utils/exports.dart';

class TextLink extends StatelessWidget {
  final String text;
  final TextStyle textStyle;
  final GestureTapCallback? onTap;

  const TextLink({required this.text, required this.textStyle, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return MouseStateListener(
      onTap: onTap,
      childBuilder: (Set<WidgetState> states) {
        return Text(
          text,
          style: textStyle.copyWith(color: _selectColor(states), decoration: _selectTextDecoration(states)),
        );
      },
    );
  }

  Color _selectColor(Set<WidgetState> states) {
    if (states.contains(WidgetState.hovered)) {
      return DesignColors.white1;
    } else {
      return DesignColors.accent;
    }
  }

  TextDecoration? _selectTextDecoration(Set<WidgetState> states) {
    if (states.contains(WidgetState.hovered)) {
      return TextDecoration.underline;
    } else {
      return null;
    }
  }
}
