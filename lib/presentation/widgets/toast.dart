import 'package:flash/flash.dart';
import 'package:flutter/material.dart';

enum ToastType {
  warning,
  danger,
  help,
  success;

  Color getColor(BuildContext context) {
    switch (this) {
      case ToastType.warning:
        return Colors.orange;
      case ToastType.danger:
        return Colors.red;
      case ToastType.help:
        return Colors.blue;
      case ToastType.success:
        return Colors.green;
    }
  }

  // TODO: implement getTextStyle
  // TextStyle getTextStyle(BuildContext context) {
  //   switch (this) {
  //     case ToastType.warning:
  //     case ToastType.danger:
  //     case ToastType.help:
  //     case ToastType.success:
  //       return theme.appFonts.bold16.copyWith(color: Colors.white);
  //   }
  // }
}

class ToriiToast extends StatelessWidget {
  const ToriiToast({required this.message, required this.type, required this.controller, super.key});

  final String message;
  final ToastType type;
  final FlashController controller;

  @override
  Widget build(BuildContext context) {
    return FlashBar(
      controller: controller,
      backgroundColor: type.getColor(context),
      clipBehavior: Clip.antiAlias,
      behavior: FlashBehavior.floating,
      title: Text(
        message,
        // style: type.getTextStyle(context),
        textHeightBehavior: const TextHeightBehavior(leadingDistribution: TextLeadingDistribution.even),
        textAlign: TextAlign.center,
      ),
      content: Container(),
    );
  }
}
