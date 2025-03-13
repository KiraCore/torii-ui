import 'package:flutter/widgets.dart';
import 'package:torii_client/utils/exports.dart';

class TxInputStaticLabel extends StatelessWidget {
  final Widget child;
  final String label;
  final EdgeInsets contentPadding;

  const TxInputStaticLabel({
    required this.child,
    required this.label,
    this.contentPadding = const EdgeInsets.only(top: 4),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: DesignColors.accent,
            letterSpacing: 0.01,
          ),
        ),
        Padding(padding: contentPadding, child: child),
      ],
    );
  }
}
