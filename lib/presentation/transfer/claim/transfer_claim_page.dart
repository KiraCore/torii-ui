import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:torii_client/domain/exports.dart';
import 'package:torii_client/domain/models/transaction/signed_transaction_model.dart';
import 'package:torii_client/presentation/transfer/claim/cubit/transfer_claim_cubit.dart';
import 'package:torii_client/presentation/transfer/claim/widgets/claim_progress_dialog.dart';
import 'package:torii_client/presentation/transfer/widgets/transfer_app_bar.dart';
import 'package:torii_client/utils/exports.dart';

class TransferClaimPage extends StatelessWidget {
  const TransferClaimPage({super.key, required this.signedTx, required this.msgSendFormModel});

  final SignedTxModel? signedTx;
  final MsgSendFormModel? msgSendFormModel;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<TransferClaimCubit>()..init(signedTx: signedTx, msgSendFormModel: msgSendFormModel),
      child: Scaffold(
        body: SingleChildScrollView(child: Column(children: [TransferAppBar(), const ClaimProgressDialog()])),
      ),
    );
  }
}
