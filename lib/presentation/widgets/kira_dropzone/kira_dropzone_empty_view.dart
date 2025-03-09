import 'package:flutter/material.dart';
import 'package:torii_client/presentation/widgets/text_link.dart';
import 'package:torii_client/utils/exports.dart';

class KiraDropzoneEmptyView extends StatelessWidget {
  final String emptyLabel;
  final VoidCallback? onTap;

  const KiraDropzoneEmptyView({required this.emptyLabel, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(emptyLabel, style: textTheme.bodyMedium!.copyWith(color: DesignColors.white1)),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            Text('${S.of(context).or} ', style: textTheme.bodyMedium!.copyWith(color: DesignColors.white1)),
            TextLink(text: S.of(context).browse, textStyle: textTheme.bodyMedium!, onTap: onTap),
          ],
        ),
      ],
    );
  }
}
