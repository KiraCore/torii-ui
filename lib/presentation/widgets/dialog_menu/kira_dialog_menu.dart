import 'package:flutter/material.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:torii_client/presentation/widgets/dialog_menu/kira_dialog_menu_item.dart';
import 'package:torii_client/presentation/widgets/mouse_state_listener.dart';
import 'package:torii_client/utils/exports.dart';

class KiraDialogMenu extends StatefulWidget {
  final bool disabled;
  final Color backgroundColor;
  final Widget button;
  final List<KiraDialogMenuItem> popupItems;
  final double popupWidth;
  
  const KiraDialogMenu({
    required super.key,
    required this.button,
    required this.popupItems,
    required this.popupWidth,
    this.backgroundColor = DesignColors.background,
    this.disabled = false,
  });

  @override
  State<KiraDialogMenu> createState() => _KiraDialogMenuState();
}

class _KiraDialogMenuState extends State<KiraDialogMenu> {
  late JustTheController controller;

  @override
  void initState() {
    super.initState();
    controller = JustTheController();
  }
    
  @override
  Widget build(BuildContext context) {
    return JustTheTooltip(
      key: widget.key,
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
          decoration: BoxDecoration(color: widget.backgroundColor, borderRadius: BorderRadius.circular(8)),
          width: widget.popupWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: widget.popupItems,
          ),
        ),
      ),
      child: MouseStateListener(
        onTap:
            widget.disabled
                ? null
                : () async {
                  // NOTE: async is required due to the controller.showTooltip() call bug
                  await Future.delayed(const Duration(milliseconds: 50));
                  return controller.showTooltip();
                },
        childBuilder: (Set<WidgetState> states) {
          return Padding(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), child: widget.button);
        },
      ),
    );
  }
}
