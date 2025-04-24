import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:torii_client/domain/models/tokens/a_msg_form_model.dart';
import 'package:torii_client/presentation/transfer/tx_process_cubit/tx_process_cubit.dart';
import 'package:torii_client/utils/exports.dart';

class TxDialogError<T extends AMsgFormModel> extends StatelessWidget {
  final bool accountErrorBool;

  const TxDialogError({required this.accountErrorBool, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return SizedBox(
      height: 200,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          if (accountErrorBool)
            Text(
              S.of(context).txErrorAccountNumberNotExist,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium!.copyWith(color: DesignColors.redStatus1),
            )
          else
            Text(
              'Cannot fetch details.\nINTERX network is down or your internet is unstable.', //S.of(context).txErrorCannotFetchDetails,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium!.copyWith(color: DesignColors.redStatus1),
            ),
          const SizedBox(height: 20),
          TextButton.icon(
            // TODO: make refresh for eth too
            onPressed: () => BlocProvider.of<TxProcessCubit<T>>(context).init(sendFromKira: true),
            icon: const Icon(AppIcons.refresh, size: 18),
            label: Text(S.of(context).txTryAgain, style: textTheme.titleSmall!.copyWith(color: DesignColors.white1)),
          ),
        ],
      ),
    );
  }
}
