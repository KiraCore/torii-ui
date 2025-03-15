import 'package:flutter/material.dart';
import 'package:torii_client/presentation/widgets/loading_container.dart';
import 'package:torii_client/utils/exports.dart';

class TxDialogLoading extends StatelessWidget {
  const TxDialogLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return SizedBox(
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const LoadingContainer(),
          const SizedBox(height: 20),
          Text(S.of(context).txFetchingRemoteData, style: textTheme.bodyLarge!.copyWith(color: DesignColors.white1)),
        ],
      ),
    );
  }
}
