import 'package:flutter/material.dart';
import 'package:torii_client/presentation/widgets/key_value/copy_value.dart';
import 'package:torii_client/presentation/widgets/key_value/detail_title.dart';

class CopyTitleValue extends StatelessWidget {
  const CopyTitleValue({required this.title, required this.value, super.key});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[DetailTitle(title), const SizedBox(height: 4), CopyValue(value: value)],
    );
  }
}
