import 'package:flutter/material.dart';
import 'package:torii_client/utils/exports.dart';

class DrawerPopButton extends StatelessWidget {
  final VoidCallback onClose;
  final VoidCallback onPop;
  final double size;
  final Color color;

  const DrawerPopButton({
    required this.onClose,
    required this.onPop,
    this.size = 24,
    this.color = DesignColors.white1,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: check in gorouter if 2+ dialogs are opened
    if (router.isPreviousRouteDialog()) {
      return IconButton(onPressed: onPop, icon: Icon(Icons.arrow_back, size: size, color: color));
    }
    return IconButton(onPressed: onClose, icon: Icon(Icons.close, size: size, color: color));
  }
}
