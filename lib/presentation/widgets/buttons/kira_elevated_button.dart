import 'package:flutter/material.dart';
import 'package:torii_client/presentation/widgets/mouse_state_listener.dart';
import 'package:torii_client/utils/exports.dart';

class KiraElevatedButton extends StatefulWidget {
  final GestureTapCallback? onPressed;
  final String? title;
  final Widget? icon;
  final double? width;
  final double height;
  final bool disabled;
  final Color? foregroundColor;

  const KiraElevatedButton({
    required this.onPressed,
    this.title,
    this.width,
    this.icon,
    this.foregroundColor,
    this.disabled = false,
    this.height = 51,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _KiraElevatedButton();
}

class _KiraElevatedButton extends State<KiraElevatedButton> {
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Opacity(
      opacity: widget.disabled ? 0.3 : 1,
      child: MouseStateListener(
        disabled: widget.disabled,
        onTap: widget.disabled ? null : widget.onPressed,
        childBuilder: (Set<WidgetState> states) {
          return Container(
            decoration: BoxDecoration(
              gradient: widget.foregroundColor != null ? null : _getButtonGradient(states),
              color: widget.foregroundColor?.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            height: widget.height,
            width: widget.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                if (widget.icon != null) ...<Widget>[widget.icon!, if (widget.title != null) const SizedBox(width: 12)],
                if (widget.title != null) ...<Widget>[
                  Text(
                    widget.title!.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: textTheme.labelLarge!.copyWith(color: widget.foregroundColor ?? DesignColors.background),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Gradient _getButtonGradient(Set<WidgetState> states) {
    if (!widget.disabled && states.contains(WidgetState.hovered)) {
      return DesignColors.primaryButtonGradientHover;
    }
    return DesignColors.primaryButtonGradient;
  }
}
