import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:torii_client/domain/models/tokens/a_msg_form_model.dart';
import 'package:torii_client/domain/models/tokens/msg_send_form_model.dart';
import 'package:torii_client/presentation/transfer/send/tx_dialog_error.dart';
import 'package:torii_client/presentation/transfer/send/tx_dialog_loading.dart';
import 'package:torii_client/presentation/transfer/tx_broadcast/tx_broadcast_page.dart';
import 'package:torii_client/presentation/transfer/tx_process_cubit/a_tx_process_state.dart';
import 'package:torii_client/presentation/transfer/tx_process_cubit/states/tx_process_broadcast_state.dart';
import 'package:torii_client/presentation/transfer/tx_process_cubit/states/tx_process_confirm_state.dart';
import 'package:torii_client/presentation/transfer/tx_process_cubit/states/tx_process_error_state.dart';
import 'package:torii_client/presentation/transfer/tx_process_cubit/states/tx_process_loaded_state.dart';
import 'package:torii_client/presentation/transfer/tx_process_cubit/states/tx_process_loading_state.dart';
import 'package:torii_client/presentation/transfer/tx_process_cubit/tx_process_cubit.dart';

typedef TxFormWidgetBuilder = Widget Function(TxProcessLoadedState txProcessLoadedState);
typedef TxFormPreviewWidgetBuilder = Widget Function(TxProcessConfirmState txProcessConfirmState);

class TxProcessWrapper<T extends AMsgFormModel> extends StatefulWidget {
  final TxProcessCubit<T> txProcessCubit;
  final TxFormPreviewWidgetBuilder txFormPreviewWidgetBuilder;
  final TxFormWidgetBuilder? txFormWidgetBuilder;
  final bool formEnabledBool;

  const TxProcessWrapper({
    required this.txProcessCubit,
    required this.txFormWidgetBuilder,
    required this.txFormPreviewWidgetBuilder,
    this.formEnabledBool = true,
    Key? key,
  }) : assert(
         (formEnabledBool == false) || (formEnabledBool && txFormWidgetBuilder != null),
         'txFormWidgetBuilder should be defined when formEnabledBool is equal true',
       ),
       super(key: key);

  @override
  State<StatefulWidget> createState() => _TxProcessWrapper<T>();
}

class _TxProcessWrapper<T extends AMsgFormModel> extends State<TxProcessWrapper<T>> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<TxProcessCubit<T>>.value(
      value: widget.txProcessCubit,
      child: BlocBuilder<TxProcessCubit<T>, ATxProcessState>(
        bloc: widget.txProcessCubit,
        builder: (BuildContext context, ATxProcessState txProcessState) {
          late Widget dialogWidget;

          // Build widget representing the associated ATxProcessState
          if (txProcessState is TxProcessLoadingState) {
            dialogWidget = const TxDialogLoading();
          } else if (txProcessState is TxProcessLoadedState && widget.txFormWidgetBuilder != null) {
            dialogWidget = widget.txFormWidgetBuilder!(txProcessState);
          } else if (txProcessState is TxProcessConfirmState) {
            dialogWidget = widget.txFormPreviewWidgetBuilder(txProcessState);
          } else if (txProcessState is TxProcessBroadcastState) {
            dialogWidget = TxBroadcastPage<T>(
              signedTxModel: txProcessState.signedTxModel,
              // TODO: refactor
              msgSendFormModel: widget.txProcessCubit.msgFormModel as MsgSendFormModel,
            );
          } else if (txProcessState is TxProcessErrorState) {
            dialogWidget = TxDialogError<T>(accountErrorBool: txProcessState.accountErrorBool);
          }
          return AnimatedSwitcher(duration: const Duration(milliseconds: 400), child: dialogWidget);
        },
      ),
    );
  }
}
