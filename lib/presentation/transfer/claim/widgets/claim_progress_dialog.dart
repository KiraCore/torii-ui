import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:torii_client/presentation/transfer/claim/cubit/transfer_claim_cubit.dart';
import 'package:torii_client/presentation/transfer/claim/widgets/claim_form_preview.dart';
import 'package:torii_client/presentation/transfer/input/msg_send_form/msg_send_form_preview.dart';
import 'package:torii_client/presentation/transfer/send/tx_dialog.dart';
import 'package:torii_client/presentation/transfer/widgets/request_passphrase_dialog.dart';
import 'package:torii_client/presentation/widgets/exports.dart';
import 'package:torii_client/utils/exports.dart';
import 'package:torii_client/utils/extensions/int_extension.dart';

class ClaimProgressDialog extends StatelessWidget {
  const ClaimProgressDialog({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: temp way, fix this
    if (context.read<TransferClaimCubit>().state.navigateToInput) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        router.replace(const TransferInputRoute().location);
      });
    }
    final theme = Theme.of(context).textTheme;
    return BlocConsumer<TransferClaimCubit, TransferClaimState>(
      listenWhen: (previous, current) {
        if (previous.isClaiming) {
          if (current.navigateToInput) {
            KiraToast.of(context).show(message: 'Claimed successfully', type: ToastType.success);
          } else if (current.isError) {
            KiraToast.of(context).show(message: 'Claim failed', type: ToastType.error);
            context.read<TransferClaimCubit>().claimErrorHandled();
          }
        }
        return previous.navigateToInput != current.navigateToInput;
      },
      listener: (context, state) {
        if (state.navigateToInput) {
          router.replace(const TransferInputRoute().location);
        }
      },
      builder: (context, state) {
        if (state.isLoading) {
          return Padding(padding: const EdgeInsets.only(top: 150), child: const CenterLoadSpinner());
        }
        // TODO: fix this
        if (state.isError || state.txToProcess == null) {
          return Column(
            children: [
              const SizedBox(height: 100),
              Text(
                'There was a processing error.\nPlease try again later or return to home and submit a new transaction.',
                style: theme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              KiraElevatedButton(
                onPressed: () => context.read<TransferClaimCubit>().forceReloadTransactions(),
                title: 'Retry',
                width: 300,
              ),
              const SizedBox(height: 10),
              KiraOutlinedButton(
                onPressed: () => TransferInputRoute().go(context),
                width: 300,
                title: 'Return to home',
              ),
            ],
          );
        }
        return TxDialog(
          suffixWidget: null,
          title:
              state.isReadyToClaim
                  ? 'Ready to claim'
                  : state.isClaiming
                  ? 'Claiming...'
                  : state.waitForRecipientToClaim
                  ? 'Waiting for recipient to claim'
                  : state.shouldBeManuallyClaimed
                  ? 'Waiting for confirmation'
                  : '',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClaimFormPreview(txListItemModel: state.txToProcess!),
              const SizedBox(height: 30),
              if (!state.isReadyToClaim || state.isClaiming)
                Center(
                  child: Text(
                    'Confirmed in ${state.passedSeconds.toTimeFromSeconds()}',
                    style: theme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                )
              else
                Center(
                  child: BlocBuilder<TransferClaimCubit, TransferClaimState>(
                    buildWhen: (previous, current) => previous.passedSeconds != current.passedSeconds,
                    builder: (context, state) {
                      return Text(
                        'In progress for ${state.passedSeconds.toTimeFromSeconds()}\n(${state.passedSeconds} / ${15} blocks)',
                        style: theme.headlineSmall,
                        textAlign: TextAlign.center,
                      );
                    },
                  ),
                ),
              const SizedBox(height: 20),
              if (state.shouldBeManuallyClaimed)
                Row(
                  children: [
                    const Spacer(),
                    KiraElevatedButton(
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
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: KiraOutlinedButton(
                          width: 100,
                          disabled: state.isReadyToClaim || state.isClaiming,
                          onPressed: context.read<TransferClaimCubit>().refreshIsReadyToClaim,
                          title: 'Refresh',
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}
