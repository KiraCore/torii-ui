import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:torii_client/domain/exports.dart';
import 'package:torii_client/domain/models/messages/msg_send_model.dart';
import 'package:torii_client/domain/models/transaction/signed_transaction_model.dart';
import 'package:torii_client/domain/models/transaction/unsigned_tx_model.dart';
import 'package:torii_client/presentation/metamask/cubit/metamask_cubit.dart';
import 'package:torii_client/presentation/session/cubit/session_cubit.dart';
import 'package:torii_client/presentation/transfer/send/tx_send_form_completing_indicator.dart';
import 'package:torii_client/presentation/transfer/send/tx_send_form_next_button.dart';
import 'package:torii_client/presentation/transfer/tx_form_builder_cubit/a_tx_form_builder_state.dart';
import 'package:torii_client/presentation/transfer/tx_form_builder_cubit/states/tx_form_builder_downloading_state.dart';
import 'package:torii_client/presentation/transfer/tx_form_builder_cubit/states/tx_form_builder_error_state.dart';
import 'package:torii_client/presentation/transfer/tx_form_builder_cubit/tx_form_builder_cubit.dart';
import 'package:torii_client/presentation/transfer/tx_process_cubit/tx_process_cubit.dart';
import 'package:torii_client/presentation/transfer/widgets/request_passphrase_dialog.dart';
import 'package:torii_client/utils/exports.dart';
import 'package:torii_client/domain/models/tokens/a_msg_form_model.dart';

class TxSendFormFooter extends StatefulWidget {
  final TokenAmountModel feeTokenAmountModel;
  final GlobalKey<FormState> formKey;

  const TxSendFormFooter({required this.feeTokenAmountModel, required this.formKey, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TxSendFormFooter();
}

class _TxSendFormFooter extends State<TxSendFormFooter> {
  final SessionCubit sessionCubit = getIt<SessionCubit>();
  final MetamaskCubit metamaskCubit = getIt<MetamaskCubit>();

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return BlocBuilder<TxFormBuilderCubit, ATxFormBuilderState>(
      builder: (BuildContext context, ATxFormBuilderState txFormBuilderState) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (txFormBuilderState is TxFormBuilderDownloadingState)
              const TxSendFormCompletingIndicator()
            else
              AnimatedBuilder(
                animation: context.read<TxProcessCubit<MsgSendFormModel>>().msgFormModel,
                builder: (BuildContext context, Widget? _) {
                  bool formFilledBool = context.read<TxProcessCubit<MsgSendFormModel>>().msgFormModel.canBuildTxMsg();

                  return TxSendFormNextButton(
                    errorExistsBool: txFormBuilderState is TxFormBuilderErrorState,
                    disabledBool: formFilledBool == false,
                    onPressed: () => _handleNextButtonPressed(context),
                  );
                },
              ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  S.of(context).txNoticeFee(widget.feeTokenAmountModel.toString()),
                  style: textTheme.bodySmall!.copyWith(color: DesignColors.white1),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleNextButtonPressed(BuildContext context) async {
    if (widget.formKey.currentState!.validate() == false) {
      getIt<Logger>().e('Form is not valid');
      return;
    }
    final model = context.read<TxProcessCubit<MsgSendFormModel>>().msgFormModel;
    if (model.senderWalletAddress is EthereumWalletAddress) {
      try {
        // TODO(Mykyta): is there possibility that model can be not a MsgSendModel ? (`send-via-metamask` task)
        // ignore:unused_local_variable
        Decimal amount = model.tokenAmountModel?.getAmountInBaseDenomination() ?? Decimal.zero;
        if (amount == Decimal.zero || model.recipientWalletAddress == null) {
          getIt<Logger>().e('Form is not valid');
          return;
        }

        RequestPassphraseDialog.show(
          context,
          onProceed: ({required String passphrase}) async {
            context.read<TxProcessCubit<MsgSendFormModel>>().submitTransactionFromEth(passphrase: passphrase);
          },
          needToConfirm: true,
        );

        // RequestPassphraseDialog.show(
        //   context,
        //   onProceed: ({required String passphrase}) {
        //     getIt<EthereumService>().exportContractTokens(
        //       passphrase: passphrase,
        //       kiraAddress: model.recipientWalletAddress!.address,
        //       amountInEth: model.tokenAmountModel!.getAmountInBaseDenomination(),
        //     );
        //   },
        //   needToConfirm: true,
        // );
        // await metamaskCubit.pay(
        //   to: model.recipientWalletAddress!,
        //   amount: model.tokenAmountModel!.getAmountInBaseDenomination().toDouble().toInt(),
        // );
      } catch (e) {
        getIt<Logger>().e('Metamask pay ${e.toString()}');
      }
    } else {
      RequestPassphraseDialog.show(
        context,
        onProceed: ({required String passphrase}) async {
          context.read<TxProcessCubit<MsgSendFormModel>>().signSubmitTransactionFromKira(
            context.read<TxFormBuilderCubit>(),
            passphrase: passphrase,
          );
        },
        needToConfirm: true,
      );
    }
  }
}
