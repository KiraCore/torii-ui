import 'package:flutter/material.dart';
import 'package:torii_client/presentation/widgets/mouse_state_listener.dart';
import 'package:torii_client/utils/exports.dart';

class KiraDialogMenuItem extends StatelessWidget {
  final String title;
  final Color? color;
  final VoidCallback? onTap;

  const KiraDialogMenuItem({required this.title, this.color, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return MouseStateListener(
      onTap: onTap,
      childBuilder: (Set<WidgetState> states) {
        Color color = _selectColor(states);
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(color: _selectBackgroundColor(states)),
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodyMedium!.copyWith(color: onTap != null ? color : color.withOpacity(0.5)),
          ),
        );
      },
    );
  }

  Color _selectColor(Set<WidgetState> states) {
    if (states.contains(WidgetState.hovered)) {
      return DesignColors.white1;
    } else if (color != null) {
      return color!;
    } else {
      return DesignColors.white2;
    }
  }

  Color _selectBackgroundColor(Set<WidgetState> states) {
    if (states.contains(WidgetState.hovered)) {
      return DesignColors.greyHover2;
    } else {
      return Colors.transparent;
    }
  }
}
