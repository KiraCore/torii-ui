import 'package:flutter/material.dart';
import 'package:torii_client/presentation/widgets/exports.dart';
import 'package:torii_client/utils/exports.dart';

class KiraChipButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool selected;
  final EdgeInsets? margin;

  const KiraChipButton({required this.label, required this.onTap, required this.selected, this.margin, super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return MouseStateListener(
      mouseCursor: SystemMouseCursors.click,
      onTap: onTap,
      childBuilder: (Set<WidgetState> states) {
        return Container(
          margin: margin,
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
          decoration: BoxDecoration(color: _selectBackgroundColor(states), borderRadius: BorderRadius.circular(100)),
          child: Text(
            label,
            style: textTheme.bodySmall!.copyWith(
              color: selected ? DesignColors.black : DesignColors.white1,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      },
    );
  }

  Color _selectBackgroundColor(Set<WidgetState> states) {
    if (states.contains(WidgetState.hovered)) {
      return selected ? DesignColors.white2 : DesignColors.grey2;
    }
    return selected ? DesignColors.white1 : DesignColors.grey3;
  }
}
