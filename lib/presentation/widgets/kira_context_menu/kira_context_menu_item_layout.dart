import 'package:flutter/material.dart';
import 'package:torii_client/utils/exports.dart';

class KiraContextMenuItemLayout extends StatelessWidget {
  final String label;
  final IconData iconData;

  const KiraContextMenuItemLayout({required this.label, required this.iconData, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(iconData, color: Colors.white, size: 18),
        const SizedBox(width: 8),
        Expanded(child: Text(label, style: const TextStyle(fontSize: 12, color: DesignColors.white1))),
      ],
    );
  }
}
