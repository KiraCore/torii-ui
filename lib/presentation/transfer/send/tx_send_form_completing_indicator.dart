import 'package:flutter/material.dart';
import 'package:torii_client/presentation/widgets/loading_container.dart';
import 'package:torii_client/utils/exports.dart';

class TxSendFormCompletingIndicator extends StatelessWidget {
  const TxSendFormCompletingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const LoadingContainer(),
        const SizedBox(width: 10),
        Text(S.of(context).txSigning, style: textTheme.bodySmall!.copyWith(color: DesignColors.white1)),
      ],
    );
  }
}
