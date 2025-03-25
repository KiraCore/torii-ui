import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gpassword/gpassword.dart';
import 'package:torii_client/utils/exports.dart';
import 'package:torii_client/utils/router/router.dart';

import '../../widgets/exports.dart';

class RequestPassphraseDialog extends StatelessWidget {
  const RequestPassphraseDialog({super.key, required this.onProceed, required this.initEnter});

  final void Function({required String passphrase}) onProceed;
  final bool initEnter;

  static void show(
    BuildContext context, {
    required void Function({required String passphrase}) onProceed,
    required bool initEnter,
  }) {
    showDialog<void>(
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: RequestPassphraseDialog(onProceed: onProceed, initEnter: initEnter),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    final controller = TextEditingController();
    final confirmController = TextEditingController();
    return Dialog(
        backgroundColor: DesignColors.background,
      child: Container(
        padding: EdgeInsets.all(16),
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              initEnter ? 'Set the passphrase for the transaction' : 'Confirm the transaction passphrase',
              style: textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            if (initEnter)
              Column(
                  children: [
                  Text(
                    'The passphrase will be used to encrypt the transaction data. You will need to enter the passphrase again to claim the transaction after it is confirmed.',
                    style: textTheme.bodyMedium,
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    height: 58,
                    child: KiraTextField(
                      controller: controller,
                      hint: 'Enter passphrase',
                      obscureText: true,
                      canGeneratePassword: true,
                    ),
                    ),
                    SizedBox(height: 8),
                  SizedBox(
                    height: 58,
                    child: KiraTextField(controller: confirmController, hint: 'Confirm passphrase', obscureText: true),
                    ),
                  ],
                )
            else
              KiraTextField(controller: controller, obscureText: true),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: KiraOutlinedButton(
                    title: 'Proceed',
                    onPressed: () {
                      if (controller.text.isEmpty || (initEnter && confirmController.text != controller.text)) {
                        return;
                      }
                      onProceed(passphrase: controller.text);
                      router.pop();
                    },
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: KiraOutlinedButton(
                    title: 'Cancel',
                    onPressed: () {
                      router.pop();
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
