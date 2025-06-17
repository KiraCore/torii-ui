import 'package:flutter/material.dart';
import 'package:torii_client/presentation/widgets/buttons/copy_button.dart';
import 'package:torii_client/presentation/widgets/key_value/detail_value.dart';
import 'package:torii_client/presentation/widgets/kira_tooltip.dart';
import 'package:torii_client/utils/exports.dart';

class CopyHoverValue extends StatelessWidget {
  const CopyHoverValue({required this.value, super.key});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        CopyButton(value: value, notificationText: S.of(context).toastSuccessfullyCopied),
        const SizedBox(width: 4),
        Expanded(child: KiraToolTip(childMargin: EdgeInsets.zero, message: value, child: DetailValue(value))),
      ],
    );
  }
}
