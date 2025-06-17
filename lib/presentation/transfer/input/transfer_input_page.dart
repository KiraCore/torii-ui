import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:torii_client/presentation/global/logs/torii_logs_cubit.dart';
import 'package:torii_client/presentation/global/session/cubit/session_cubit.dart';
import 'package:torii_client/presentation/transfer/input/cubit/transfer_input_cubit.dart';
import 'package:torii_client/presentation/transfer/tx_send_tokens/tx_send_tokens_page.dart';
import 'package:torii_client/presentation/transfer/widgets/transfer_app_bar.dart';
import 'package:torii_client/presentation/widgets/loading/center_load_spinner.dart';
import 'package:torii_client/presentation/widgets/torii_scaffold.dart';
import 'package:torii_client/utils/exports.dart';

class TransferInputPage extends StatelessWidget {
  const TransferInputPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<TransferInputCubit>(),
      child: BlocListener<SessionCubit, SessionState>(
        listener: (context, state) {
          context.read<TransferInputCubit>().onAuthChanged();
        },
        child: BlocBuilder<ToriiLogsCubit, ToriiLogsState>(
          buildWhen: (previous, current) => previous.isLoading != current.isLoading,
          builder: (context, state) {
            if (state.isLoading) {
              // TODO: shimmer
              return const ToriiScaffold(child: CenterLoadSpinner());
            }
            return ToriiScaffold(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TransferAppBar(),
                    BlocBuilder<TransferInputCubit, TransferInputState>(
                      builder: (context, state) {
                        return TxSendTokensPage(fromWallet: state.fromWallet, balance: state.balance);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
