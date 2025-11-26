import 'package:datify/datify.dart';
import 'package:flutter/material.dart';
import 'package:torii_client/utils/exports.dart';

class DateTextField extends StatelessWidget {
  final String label;
  final TextEditingController textEditingController;
  final ValueChanged<DateTime?> onDateChanged;

  const DateTextField({required this.label, required this.textEditingController, required this.onDateChanged, super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    OutlineInputBorder textFieldBorder = const OutlineInputBorder(
      borderSide: BorderSide(color: DesignColors.grey2),
      borderRadius: BorderRadius.all(Radius.circular(8)),
    );

    return TextField(
      controller: textEditingController,
      style: textTheme.bodyMedium!.copyWith(color: DesignColors.white1),
      decoration: InputDecoration(
        label: Text(label),
        labelStyle: textTheme.bodyMedium!.copyWith(color: DesignColors.white2),
        border: textFieldBorder,
        enabledBorder: textFieldBorder,
      ),
      onSubmitted: _handleDateSubmitted,
    );
  }

  void _handleDateSubmitted(String value) {
    try {
      DateTime? dateTime = Datify.parse(value).date;
      onDateChanged(dateTime);
    } catch (e) {
      getIt<Logger>().e('Error during parsing date: $e');
    }
  }
}
