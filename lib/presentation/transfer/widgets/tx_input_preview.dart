import 'package:flutter/material.dart';
import 'package:torii_client/utils/exports.dart';

class TxInputPreview extends StatelessWidget {
  final String label;
  final String value;
  final Widget? icon;
  final bool large;
  final Color labelColor;

  const TxInputPreview({
    required this.label,
    required this.value,
    this.icon,
    this.large = false,
    this.labelColor = DesignColors.accent,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    TextStyle? textStyle = textTheme.bodyLarge;

    return Row(
      children: <Widget>[
        if (icon != null) ...<Widget>[SizedBox(width: 45, height: 45, child: icon), const SizedBox(width: 12)],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(label, style: textTheme.bodySmall!.copyWith(color: labelColor)),
              SizedBox(height: 5),
              Text(
                value,
                style: textStyle?.copyWith(
                  fontSize: large ? 22 : null,
                  fontWeight: large ? FontWeight.w500 : null,
                  color: DesignColors.white1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
