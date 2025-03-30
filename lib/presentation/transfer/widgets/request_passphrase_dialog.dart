import 'package:flutter/material.dart';
import 'package:torii_client/utils/exports.dart';

import '../../widgets/exports.dart';

class RequestPassphraseDialog extends StatefulWidget {
  const RequestPassphraseDialog({super.key, required this.onProceed, required this.needToConfirm});

  final void Function({required String passphrase}) onProceed;
  final bool needToConfirm;

  static void show(
    BuildContext context, {
    required void Function({required String passphrase}) onProceed,
    required bool needToConfirm,
  }) {
    showDialog<void>(
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: DesignColors.background,
          child: RequestPassphraseDialog(onProceed: onProceed, needToConfirm: needToConfirm),
        );
      },
    );
  }

  @override
  State<RequestPassphraseDialog> createState() => _RequestPassphraseDialogState();
}

class _RequestPassphraseDialogState extends State<RequestPassphraseDialog> {
  final controller = TextEditingController();
  final confirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      padding: EdgeInsets.all(16),
      width: 400,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.needToConfirm ? 'Set a passphrase for the transaction' : 'Confirm the transaction passphrase',
            style: textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          if (widget.needToConfirm)
            Column(
              children: [
                Text(
                  'You will need to enter the passphrase again to claim the amount after transaction is confirmed.',
                  style: textTheme.bodyMedium,
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 32),
                SizedBox(
                  height: 58,
                  child: KiraTextField(
                    controller: controller,
                    hint: 'Enter passphrase',
                    obscureText: true,
                    canGeneratePassword: true,
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                SizedBox(height: 8),
                SizedBox(
                  height: 58,
                  child: KiraTextField(
                    controller: confirmController,
                    hint: 'Confirm passphrase',
                    obscureText: true,
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ],
            )
          else ...[
            SizedBox(height: 16),
            KiraTextField(controller: controller, obscureText: true, onChanged: (_) => setState(() {})),
          ],
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: KiraOutlinedButton(
                  title: 'Proceed',
                  disabled:
                      controller.text.isEmpty || (widget.needToConfirm && confirmController.text != controller.text),
                  onPressed: () {
                    widget.onProceed(passphrase: controller.text);
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
    );
  }
}
