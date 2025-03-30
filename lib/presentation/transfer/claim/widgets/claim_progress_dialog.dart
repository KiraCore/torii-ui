import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:torii_client/presentation/transfer/claim/cubit/transfer_claim_cubit.dart';
import 'package:torii_client/presentation/transfer/input/msg_send_form/msg_send_form_preview.dart';
import 'package:torii_client/presentation/transfer/send/tx_dialog.dart';
import 'package:torii_client/presentation/transfer/widgets/request_passphrase_dialog.dart';
import 'package:torii_client/presentation/widgets/buttons/kira_elevated_button.dart';
import 'package:torii_client/presentation/widgets/exports.dart';
import 'package:torii_client/utils/exports.dart';
import 'package:torii_client/utils/extensions/int_extension.dart';

class ClaimProgressDialog extends StatelessWidget {
  const ClaimProgressDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return BlocConsumer<TransferClaimCubit, TransferClaimState>(
      listener: (context, state) {
        if (state.isClaimed) {
          router.replace(const TransferInputRoute().location);
        }
      },
      buildWhen:
          (previous, current) =>
              previous.isReadyToClaim != current.isReadyToClaim ||
              previous.isClaiming != current.isClaiming ||
              previous.msgSendFormModel != current.msgSendFormModel ||
              previous.signedTx != current.signedTx ||
              previous.isClaimed != current.isClaimed,
      builder: (context, state) {
        if (state.msgSendFormModel == null) {
          return const SizedBox.shrink();
        }
        return TxDialog(
          suffixWidget: null,
          title:
              state.isReadyToClaim
                  ? 'Ready to claim'
                  : state.isClaiming
                  ? 'Claiming...'
                  : 'Waiting for confirmation',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              MsgSendFormPreview(
                msgSendFormModel: state.msgSendFormModel!,
                txLocalInfoModel: state.signedTx?.txLocalInfoModel,
              ),
              const SizedBox(height: 30),
              if (state.isReadyToClaim || state.isClaiming)
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
              Row(
                children: [
                  if (state.shouldBeManuallyClaimed)
                  KiraElevatedButton(
                    width: 160,
                    disabled: !state.isReadyToClaim,
                    onPressed: () {
                      RequestPassphraseDialog.show(
                        context,
                        onProceed: context.read<TransferClaimCubit>().claim,
                        needToConfirm: false,
                      );
                    },
                    title: 'Claim',
                  ),
                  const Spacer(),
                  KiraOutlinedButton(
                    width: 100,
                    disabled: state.isReadyToClaim || state.isClaiming,
                    onPressed: context.read<TransferClaimCubit>().refreshIsReadyToClaim,
                    title: 'Refresh',
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
