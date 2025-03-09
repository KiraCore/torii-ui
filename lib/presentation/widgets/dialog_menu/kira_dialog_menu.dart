import 'package:flutter/material.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:torii_client/presentation/widgets/mouse_state_listener.dart';
import 'package:torii_client/utils/exports.dart';

class KiraDialogMenu extends StatelessWidget {
  final bool disabled;
  final Color backgroundColor;
  final Widget button;
  final Widget popup;

  const KiraDialogMenu({
    required this.button,
    required this.popup,
    this.backgroundColor = DesignColors.background,
    this.disabled = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = JustTheController();
    return JustTheTooltip(
      isModal: true,
      controller: controller,
      triggerMode: TooltipTriggerMode.manual,
      tailLength: 0,
      backgroundColor: Colors.transparent,
      content: Container(
        margin: const EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: DesignColors.grey3),
          boxShadow: const <BoxShadow>[
            BoxShadow(color: DesignColors.greyTransparent, spreadRadius: 3, blurRadius: 7, offset: Offset.zero),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(8)),
          child: popup,
        ),
      ),
      child: MouseStateListener(
        // NOTE: async is required due to the controller.showTooltip() call bug
        onTap: disabled ? null : () async => controller.showTooltip(),
        childBuilder: (Set<WidgetState> states) {
          return Container(color: Colors.transparent, child: button);
        },
      ),
    );
  }
}
