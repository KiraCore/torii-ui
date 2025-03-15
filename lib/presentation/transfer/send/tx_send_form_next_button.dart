import 'package:flutter/material.dart';
import 'package:torii_client/presentation/widgets/exports.dart';
import 'package:torii_client/utils/exports.dart';

class TxSendFormNextButton extends StatelessWidget {
  final bool disabledBool;
  final bool errorExistsBool;
  final VoidCallback onPressed;

  TxSendFormNextButton({required this.disabledBool, required this.errorExistsBool, required this.onPressed, Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        KiraElevatedButton(disabled: disabledBool, title: S.of(context).txButtonNext, width: 82, onPressed: onPressed),
        const SizedBox(height: 8),
        if (errorExistsBool)
          Text(S.of(context).txErrorCannotCreate, style: textTheme.bodySmall!.copyWith(color: DesignColors.redStatus1)),
      ],
    );
  }
}
