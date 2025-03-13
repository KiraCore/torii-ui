import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:torii_client/utils/exports.dart';

class KiraTextField extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? hint;
  final String? label;
  final bool obscureText;
  final bool readOnly;
  final Widget? suffixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;

  /// [errorText] is dedicated for external error text. It'll be reset after value change.
  final String? errorText;

  const KiraTextField({
    this.controller,
    this.focusNode,
    this.hint,
    this.label,
    this.obscureText = false,
    this.readOnly = false,
    this.suffixIcon,
    this.inputFormatters,
    this.onChanged,
    this.validator,
    this.errorText,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _KiraTextField();
}

class _KiraTextField extends State<KiraTextField> {
  String? errorText;
  late bool obscureText;
  
  @override
  void initState() {
    super.initState();
    obscureText = widget.obscureText;
    errorText = widget.errorText;
  }

  @override
  void didUpdateWidget(covariant KiraTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.errorText != oldWidget.errorText) {
      errorText = widget.errorText;
      setState(() {});
    }
    if (widget.obscureText != oldWidget.obscureText) {
      obscureText = widget.obscureText;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderSide: const BorderSide(color: DesignColors.grey3, width: 1),
      borderRadius: BorderRadius.circular(8),
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (widget.label != null) ...<Widget>[
          Text(widget.label!, style: textTheme.bodyMedium!.copyWith(color: _getLabelColor())),
          const SizedBox(height: 8),
        ],
        TextField(
          focusNode: widget.focusNode,
          controller: widget.controller,
          onChanged: (String value) {
            widget.onChanged?.call(value);
            _handleValidateTextField();
          },
          obscureText: widget.obscureText,
          readOnly: widget.readOnly,
          inputFormatters: widget.inputFormatters,
          style: textTheme.bodyLarge!.copyWith(color: DesignColors.white1),
          decoration: InputDecoration(
            filled: true,
            fillColor: DesignColors.black,
            hoverColor: DesignColors.greyHover2,
            errorText: errorText,
            errorStyle: textTheme.bodySmall!.copyWith(color: DesignColors.redStatus1),
            suffixIcon: _getSuffixIcon(),
            errorMaxLines: 1,
            hintText: widget.hint,
            hintStyle: textTheme.bodyLarge!.copyWith(color: DesignColors.grey1),
            border: outlineInputBorder,
            enabledBorder: outlineInputBorder.copyWith(
              borderSide: outlineInputBorder.borderSide.copyWith(color: DesignColors.greyOutline),
            ),
            focusedBorder: outlineInputBorder.copyWith(
              borderSide: outlineInputBorder.borderSide.copyWith(color: DesignColors.white1),
            ),
            errorBorder: outlineInputBorder.copyWith(
              borderSide: outlineInputBorder.borderSide.copyWith(color: DesignColors.redStatus1),
            ),
            focusedErrorBorder: outlineInputBorder.copyWith(
              borderSide: outlineInputBorder.borderSide.copyWith(color: DesignColors.redStatus1),
            ),
          ),
        ),
      ],
    );
  }

  void _handleValidateTextField() {
    final oldErrorText = errorText;
    if (widget.validator != null) {
      errorText = widget.validator!(widget.controller?.text ?? '');
    }
    if (oldErrorText != errorText) {
      setState(() {});
    }
  }

  Color _getLabelColor() {
    if (errorText != null) {
      return DesignColors.redStatus1;
    }
    if (widget.focusNode?.hasFocus ?? false) {
      return DesignColors.white1;
    }
    return DesignColors.white2;
  }

  Widget? _getSuffixIcon() {
    Widget? iconWidget;
    if (widget.suffixIcon != null) {
      iconWidget = widget.suffixIcon;
    }
     else {
      if (widget.obscureText) {
      iconWidget = IconButton(
          onPressed: () => setState(() => obscureText = false),
        icon: const Icon(AppIcons.eye_hidden, size: 16, color: DesignColors.accent),
      );
      } else {
      iconWidget = IconButton(
          onPressed: () => setState(() => obscureText = true),
        icon: const Icon(AppIcons.eye_visible, size: 16, color: DesignColors.accent),
        );
      }
    }
    return Padding(padding: const EdgeInsets.only(right: 12), child: iconWidget);
  }
}
