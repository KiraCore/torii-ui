import 'package:flutter/material.dart';
import 'package:torii_client/presentation/widgets/kira_tooltip.dart';
import 'package:torii_client/utils/exports.dart';

class DrawerTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? tooltipMessage;
  final Color? subtitleColor;

  const DrawerTitle({
    required this.title,
    this.subtitle,
    this.tooltipMessage,
    this.subtitleColor = DesignColors.accent,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            Text(title, style: textTheme.displaySmall!.copyWith(color: DesignColors.white1)),
            if (subtitle == null && tooltipMessage != null) KiraToolTip(message: tooltipMessage!),
          ],
        ),
        if (subtitle != null)
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              Text(subtitle!, style: textTheme.bodyLarge!.copyWith(color: subtitleColor)),
              if (tooltipMessage != null) KiraToolTip(message: tooltipMessage!),
            ],
          ),
      ],
    );
  }
}
