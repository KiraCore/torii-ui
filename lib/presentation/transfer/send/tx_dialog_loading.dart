import 'package:flutter/material.dart';
import 'package:torii_client/presentation/widgets/loading/center_load_spinner.dart';
import 'package:torii_client/utils/exports.dart';

class TxDialogLoading extends StatelessWidget {
  const TxDialogLoading({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return SizedBox(
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const CenterLoadSpinner(),
          const SizedBox(height: 20),
          Text(S.of(context).txFetchingRemoteData, style: textTheme.bodyLarge!.copyWith(color: DesignColors.white1)),
        ],
      ),
    );
  }
}
