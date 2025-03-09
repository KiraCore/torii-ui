import 'package:flutter/material.dart';
import 'package:torii_client/presentation/transfer/widgets/transfer_app_bar.dart';
import 'package:torii_client/utils/theme/design_colors.dart';

class TransferInputPage extends StatelessWidget {
  const TransferInputPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [TransferAppBar(), Expanded(child: Container(color: DesignColors.background))]),
    );
  }
}
