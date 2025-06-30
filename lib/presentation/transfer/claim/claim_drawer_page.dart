import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:torii_client/domain/models/tokens/list/tx_list_item_model.dart';
import 'package:torii_client/domain/models/tokens/msg_send_form_model.dart';
import 'package:torii_client/presentation/global/logs/torii_logs_cubit.dart';
import 'package:torii_client/presentation/network/bloc/network_module_bloc.dart';
import 'package:torii_client/presentation/network/bloc/network_module_state.dart';
import 'package:torii_client/presentation/network/widgets/network_custom_section/network_custom_section.dart';
import 'package:torii_client/presentation/network/widgets/network_list.dart';
import 'package:torii_client/presentation/transfer/claim/cubit/transfer_claim_cubit.dart';
import 'package:torii_client/presentation/transfer/claim/widgets/claim_form_preview.dart';
import 'package:torii_client/presentation/transfer/claim/widgets/claim_progress_dialog.dart';
import 'package:torii_client/presentation/transfer/widgets/request_passphrase_dialog.dart';
import 'package:torii_client/presentation/widgets/buttons/kira_elevated_button.dart';
import 'package:torii_client/presentation/widgets/buttons/kira_outlined_button.dart';
import 'package:torii_client/presentation/widgets/drawer/drawer_subtitle.dart';
import 'package:torii_client/presentation/widgets/kira_toast/kira_toast.dart';
import 'package:torii_client/presentation/widgets/kira_toast/toast_type.dart';
import 'package:torii_client/presentation/widgets/loading/center_load_spinner.dart';
import 'package:torii_client/presentation/widgets/torii_scaffold.dart';
import 'package:torii_client/utils/exports.dart';
import 'package:torii_client/utils/extensions/int_extension.dart';
import 'package:torii_client/utils/network/app_config.dart';

class ClaimDrawerPage extends StatelessWidget {
  const ClaimDrawerPage({super.key, required this.pendingTransaction});

  final TxListItemModel pendingTransaction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return BlocProvider(
      create:
          (context) =>
              getIt<TransferClaimCubit>()..init(
                signedTx: null,
                msgSendFormModel: null,
                pendingSenderTransaction: null,
                pendingRecipientTransaction: pendingTransaction,
              ),
      child: BlocConsumer<TransferClaimCubit, TransferClaimState>(
        listenWhen: (previous, current) => previous.navigateToInput != current.navigateToInput,
        listener: (context, state) {
          if (state.navigateToInput) {
            KiraToast.of(context).show(message: 'Claimed successfully', type: ToastType.success);
            router.pop();
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: DrawerTitle(
                    title:
                        state.isError
                            ? 'Error'
                            : state.isReadyToClaim
                            ? 'Ready to claim'
                            : state.isClaiming
                            ? 'Claiming...'
                            : state.waitForRecipientToClaim
                            ? 'Waiting for recipient to claim'
                            : state.shouldBeManuallyClaimed
                            ? 'Waiting for confirmation'
                            : '',
                  ),
                ),
                const SizedBox(height: 32),
                ClaimFormPreview(txListItemModel: pendingTransaction),

                const SizedBox(height: 30),
                if (!state.isReadyToClaim && state.remainingSeconds > 0)
                  Center(
                    child: Text(
                      'Wait for ${state.remainingSeconds.toTimeFromSeconds()}',
                      style: theme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  )
                else if (state.isError)
                  Center(
                    child: SelectableText(
                      'Processing error. Options:\n\n1. The transaction was already claimed.\n2. The transaction has not yet been confirmed.\n3. The passphrase is incorrect.',
                      style: theme.bodyLarge?.copyWith(color: DesignColors.redStatus1),
                    ),
                  ),
                const SizedBox(height: 20),
                if (state.shouldBeManuallyClaimed)
                  Center(
                    child: KiraElevatedButton(
                      width: 200,
                      disabled: !state.isReadyToClaim || state.isClaiming,
                      onPressed: () {
                        RequestPassphraseDialog.show(
                          context,
                          onProceed: context.read<TransferClaimCubit>().claim,
                          needToConfirm: false,
                        );
                      },
                      title: 'Claim',
                    ),
                  ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}
