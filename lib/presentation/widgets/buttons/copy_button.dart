import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:torii_client/presentation/widgets/exports.dart';
import 'package:torii_client/utils/exports.dart';

class CopyButton extends StatelessWidget {
  final String value;
  final String? notificationText;
  final double size;

  const CopyButton({required this.value, this.notificationText, this.size = 15, super.key});

  @override
  Widget build(BuildContext context) {
    return MouseStateListener(
      onTap: () => _copy(context),
      disableSplash: true,
      childBuilder: (Set<WidgetState> states) {
        Color color = DesignColors.white2;
        if (states.contains(WidgetState.hovered)) {
          color = DesignColors.white1;
        }
        return Icon(AppIcons.copy, color: color, size: size);
      },
    );
  }

  void _copy(BuildContext context) {
    Clipboard.setData(ClipboardData(text: value));
    if (notificationText != null) {
      KiraToast.of(context).show(type: ToastType.success, message: notificationText!);
    }
  }
}
