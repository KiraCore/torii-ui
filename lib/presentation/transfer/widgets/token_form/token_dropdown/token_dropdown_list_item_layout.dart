import 'package:flutter/material.dart';
import 'package:torii_client/presentation/widgets/exports.dart';
import 'package:torii_client/utils/exports.dart';

class TokenDropdownListItemLayout extends StatelessWidget {
  final Widget icon;
  final VoidCallback onTap;
  final bool selected;
  final Widget subtitle;
  final Widget title;

  const TokenDropdownListItemLayout({
    required this.icon,
    required this.onTap,
    required this.selected,
    required this.subtitle,
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MouseStateListener(
      onTap: onTap,
      childBuilder: (Set<WidgetState> materialStates) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 2),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            color: _selectColor(materialStates),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(width: 30, height: 30, child: icon),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[title, subtitle],
                ),
              ),
              const SizedBox(width: 16),
              if (selected)
                const Icon(AppIcons.done, size: 24, color: DesignColors.white1)
              else
                const SizedBox(width: 24, height: 24),
            ],
          ),
        );
      },
    );
  }

  Color _selectColor(Set<WidgetState> materialStates) {
    bool isHovered = materialStates.contains(WidgetState.hovered);
    if (isHovered || selected) {
      return DesignColors.black;
    } else {
      return Colors.transparent;
    }
  }
}
