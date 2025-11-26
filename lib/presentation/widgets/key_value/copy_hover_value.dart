import 'package:flutter/material.dart';
import 'package:torii_client/presentation/widgets/buttons/copy_button.dart';
import 'package:torii_client/presentation/widgets/key_value/detail_value.dart';
import 'package:torii_client/presentation/widgets/kira_tooltip.dart';
import 'package:torii_client/utils/exports.dart';

class CopyHoverValue extends StatelessWidget {
  const CopyHoverValue({required this.value, this.hoverUsingIcon = false, this.shortenAddress = false, super.key});

  final String value;
  final bool hoverUsingIcon;
  final bool shortenAddress;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        CopyButton(value: value, notificationText: S.of(context).toastSuccessfullyCopied),
        const SizedBox(width: 4),
        if (hoverUsingIcon) ...[
          KiraToolTip(
            childMargin: EdgeInsets.zero,
            message: value,
            child: Icon(AppIcons.eye_visible, color: DesignColors.white2, size: 15),
          ),
          const SizedBox(width: 4),
          if (shortenAddress) DetailValue(value.toShortenedAddress()) else Expanded(child: DetailValue(value)),
        ] else
          Expanded(child: KiraToolTip(childMargin: EdgeInsets.zero, message: value, child: DetailValue(value))),
      ],
    );
  }
}
