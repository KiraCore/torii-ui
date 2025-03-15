import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:torii_client/domain/models/tokens/a_msg_form_model.dart';
import 'package:torii_client/presentation/transfer/send/tx_dialog.dart';
import 'package:torii_client/presentation/transfer/tx_process_cubit/tx_process_cubit.dart';
import 'package:torii_client/presentation/widgets/buttons/kira_elevated_button.dart';
import 'package:torii_client/presentation/widgets/buttons/kira_outlined_button.dart';
import 'package:torii_client/utils/exports.dart';

class TxDialogConfirmLayout<T extends AMsgFormModel> extends StatelessWidget {
  final Widget formPreviewWidget;
  final bool editButtonVisibleBool;
  final String? title;

  const TxDialogConfirmLayout({
    required this.formPreviewWidget,
    this.editButtonVisibleBool = true,
    this.title,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TxProcessCubit<T> txProcessCubit = BlocProvider.of<TxProcessCubit<T>>(context);

    return TxDialog(
      suffixWidget:
          editButtonVisibleBool
              ? KiraOutlinedButton(
                width: 68,
                height: 39,
                title: S.of(context).txButtonEdit,
                onPressed: txProcessCubit.editTransactionForm,
              )
              : null,
      title: title ?? S.of(context).txConfirm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          formPreviewWidget,
          const SizedBox(height: 30),
          KiraElevatedButton(
            width: 160,
            onPressed: txProcessCubit.confirmTransactionForm,
            title: S.of(context).txButtonConfirmSend,
          ),
        ],
      ),
    );
  }
}
