import 'package:flutter/material.dart';
import 'package:torii_client/presentation/transfer/tx_send_tokens/tx_send_tokens_page.dart';
import 'package:torii_client/presentation/transfer/widgets/transfer_app_bar.dart';

class TransferInputPage extends StatelessWidget {
  const TransferInputPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [TransferAppBar(), TxSendTokensPage()]),
    );
  }
}
