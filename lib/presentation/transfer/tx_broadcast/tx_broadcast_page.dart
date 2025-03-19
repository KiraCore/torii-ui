import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:torii_client/domain/exports.dart';
import 'package:torii_client/domain/models/tokens/a_msg_form_model.dart';
import 'package:torii_client/domain/models/transaction/signed_transaction_model.dart';
import 'package:torii_client/presentation/transfer/tx_broadcast/cubit/a_tx_broadcast_state.dart';
import 'package:torii_client/presentation/transfer/tx_broadcast/cubit/states/tx_broadcast_completed_state.dart';
import 'package:torii_client/presentation/transfer/tx_broadcast/cubit/states/tx_broadcast_error_state.dart';
import 'package:torii_client/presentation/transfer/tx_broadcast/cubit/states/tx_broadcast_loading_state.dart';
import 'package:torii_client/presentation/transfer/tx_broadcast/cubit/tx_broadcast_cubit.dart';
import 'package:torii_client/presentation/transfer/tx_broadcast/widgets/tx_broadcast_complete_body.dart';
import 'package:torii_client/presentation/transfer/tx_broadcast/widgets/tx_broadcast_error_body.dart';
import 'package:torii_client/presentation/transfer/tx_broadcast/widgets/tx_broadcast_loading_body.dart';
import 'package:torii_client/utils/exports.dart';

class TxBroadcastPage<T extends AMsgFormModel> extends StatefulWidget {
  final SignedTxModel signedTxModel;
  final MsgSendFormModel msgSendFormModel;

  const TxBroadcastPage({required this.signedTxModel, required this.msgSendFormModel, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TxBroadcastPage<T>();
}

class _TxBroadcastPage<T extends AMsgFormModel> extends State<TxBroadcastPage<T>> {
  final TxBroadcastCubit txBroadcastCubit = TxBroadcastCubit();

  @override
  void initState() {
    super.initState();
    txBroadcastCubit.broadcast(widget.signedTxModel);
  }

  @override
  void dispose() {
    txBroadcastCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TxBroadcastCubit>.value(
      value: txBroadcastCubit,
      child: BlocConsumer<TxBroadcastCubit, ATxBroadcastState>(
        listener: (BuildContext context, ATxBroadcastState txBroadcastState) {
          if (txBroadcastState is TxBroadcastCompletedState) {
            ClaimProgressRoute(
              ClaimProgressRouteExtra(signedTx: widget.signedTxModel, msgSendFormModel: widget.msgSendFormModel),
            ).replace(context);
          }
        },
        builder: (BuildContext context, ATxBroadcastState txBroadcastState) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: _buildTxStatusWidget(txBroadcastState),
          );
        },
      ),
    );
  }

  Widget _buildTxStatusWidget(ATxBroadcastState txBroadcastState) {
    if (txBroadcastState is TxBroadcastErrorState) {
      return TxBroadcastErrorBody<T>(
        errorExplorerModel: txBroadcastState.errorExplorerModel,
        signedTxModel: widget.signedTxModel,
      );
    } else if (txBroadcastState is TxBroadcastLoadingState || txBroadcastState is TxBroadcastCompletedState) {
      return TxBroadcastLoadingBody();
    } else {
      getIt<Logger>().e('Unexpected ATxBroadcastState state $txBroadcastState');
      return const SizedBox();
    }
  }
}
