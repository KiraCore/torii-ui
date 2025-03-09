import 'package:flutter/material.dart';
import 'package:torii_client/utils/exports.dart';

class KiraDropzoneDropView extends StatelessWidget {
  const KiraDropzoneDropView({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Center(
      child: Text(
        S.of(context).keyfileDropFile.toUpperCase(),
        style: textTheme.bodyMedium!.copyWith(color: DesignColors.white1),
      ),
    );
  }
}
