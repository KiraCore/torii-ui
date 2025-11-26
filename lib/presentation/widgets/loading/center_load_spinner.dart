import 'package:flutter/material.dart';
import 'package:torii_client/utils/exports.dart';

class CenterLoadSpinner extends StatelessWidget {
  const CenterLoadSpinner({super.key, this.size = 30});

  final double? size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(height: size, width: size, child: const CircularProgressIndicator(color: DesignColors.white1)),
    );
  }
}
