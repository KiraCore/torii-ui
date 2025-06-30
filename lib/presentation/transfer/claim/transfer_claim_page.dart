import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:torii_client/domain/exports.dart';
import 'package:torii_client/domain/models/tokens/list/tx_list_item_model.dart';
import 'package:torii_client/domain/models/transaction/signed_transaction_model.dart';
import 'package:torii_client/presentation/global/logs/torii_logs_cubit.dart';
import 'package:torii_client/presentation/transfer/claim/cubit/transfer_claim_cubit.dart';
import 'package:torii_client/presentation/transfer/claim/widgets/claim_progress_dialog.dart';
import 'package:torii_client/presentation/transfer/widgets/transfer_app_bar.dart';
import 'package:torii_client/presentation/widgets/loading/center_load_spinner.dart';
import 'package:torii_client/presentation/widgets/torii_scaffold.dart';
import 'package:torii_client/utils/exports.dart';

@Deprecated('Use notif box instead')
class TransferClaimPage extends StatelessWidget {
  const TransferClaimPage({
    super.key,
    required this.signedTx,
    required this.msgSendFormModel,
    required this.pendingSenderTransaction,
    required this.pendingRecipientTransaction,
  });

  final TxListItemModel? signedTx;
  final MsgSendFormModel? msgSendFormModel;
  // TODO: fix type, remove msgSendFormModel ??
  final TxListItemModel? pendingSenderTransaction;
  final TxListItemModel? pendingRecipientTransaction;

  @override
  Widget build(BuildContext context) {
    print(
      'TransferClaimPage: build() $signedTx $msgSendFormModel $pendingSenderTransaction $pendingRecipientTransaction',
    );
    return BlocProvider(
      create:
          (context) =>
              getIt<TransferClaimCubit>()..init(
                signedTx: signedTx,
                msgSendFormModel: msgSendFormModel,
                pendingSenderTransaction: pendingSenderTransaction,
                pendingRecipientTransaction: pendingRecipientTransaction,
              ),
      child: BlocConsumer<ToriiLogsCubit, ToriiLogsState>(
        listenWhen:
            (previous, current) =>
                previous.pendingEthTxs != current.pendingEthTxs,
        listener: (context, state) {
          context.read<TransferClaimCubit>().reloadTransactions(
            pendingSenderTransaction: null,
            // todo: remove, its temp
            pendingRecipientTransaction: state.pendingEthTxs?.listItems.firstOrNull,
          );
        },
        buildWhen: (previous, current) => previous.isLoading != current.isLoading,
        builder: (context, state) {
          if (state.isLoading) {
            // TODO: shimmer, appbar
            return const ToriiScaffold(child: CenterLoadSpinner());
          }
          return ToriiScaffold(
            child: SingleChildScrollView(child: Column(children: [TransferAppBar(), const ClaimProgressDialog()])),
          );
        },
      ),
    );
  }
}
