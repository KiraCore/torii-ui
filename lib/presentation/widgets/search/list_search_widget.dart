import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:torii_client/presentation/widgets/search/kira_search_bar.dart';
import 'package:torii_client/utils/theme/design_colors.dart';

class ListSearchWidget extends StatefulWidget {
  final TextEditingController textEditingController;
  final bool enabled;
  final double height;
  final double width;
  final String? hint;
  final Function(String)? onSubmit;
  final Function()? onClear;

  const ListSearchWidget({
    required this.textEditingController,
    this.enabled = true,
    this.height = 50,
    this.width = 285,
    this.hint,
    this.onSubmit,
    this.onClear,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ListSearchWidget();
}

class _ListSearchWidget extends State<ListSearchWidget> {
  @override
  Widget build(BuildContext context) {
    return KiraSearchBar(
      textEditingController: widget.textEditingController,
      textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: DesignColors.white1),
      enabled: widget.enabled,
      height: widget.height,
      width: widget.width,
      label: widget.hint,
      backgroundColor: DesignColors.black,
      onClear: widget.onClear,
      onSubmit: widget.onSubmit,
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: DesignColors.greyOutline),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
