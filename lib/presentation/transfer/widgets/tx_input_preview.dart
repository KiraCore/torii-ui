import 'package:flutter/material.dart';
import 'package:torii_client/presentation/widgets/buttons/copy_button.dart';
import 'package:torii_client/presentation/widgets/kira_tooltip.dart';
import 'package:torii_client/utils/exports.dart';

class TxInputPreview extends StatelessWidget {
  final String label;
  final String value;
  final Widget? icon;
  final bool large;
  final Color labelColor;
  final bool copyable;
  final bool fitInOneLine;

  const TxInputPreview({
    required this.label,
    required this.value,
    this.icon,
    this.large = false,
    this.labelColor = DesignColors.accent,
    this.copyable = false,
    this.fitInOneLine = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    TextStyle? textStyle = textTheme.bodyLarge;

    Widget valueText = Text(
      value,
      style: textStyle?.copyWith(
        fontSize: large ? 22 : null,
        fontWeight: large ? FontWeight.w500 : null,
        color: DesignColors.white1,
      ),
      maxLines: fitInOneLine ? 1 : null,
      overflow: fitInOneLine ? TextOverflow.ellipsis : null,
    );
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
              Row(
                children: [
                  if (fitInOneLine)
                    Expanded(child: KiraToolTip(childMargin: EdgeInsets.zero, message: value, child: valueText))
                  else
                    Expanded(child: valueText),
                  if (copyable) CopyButton(value: value, notificationText: S.of(context).toastSuccessfullyCopied),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
