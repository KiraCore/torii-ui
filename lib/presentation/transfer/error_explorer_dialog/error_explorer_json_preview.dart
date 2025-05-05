import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_view/json_view.dart';
import 'package:torii_client/presentation/transfer/widgets/tx_input_wrapper.dart';
import 'package:torii_client/presentation/widgets/kira_toast/kira_toast.dart';
import 'package:torii_client/presentation/widgets/kira_toast/toast_type.dart';
import 'package:torii_client/utils/exports.dart';

class ErrorExplorerJsonPreview extends StatelessWidget {
  final String title;
  final dynamic jsonObject;

  const ErrorExplorerJsonPreview({required this.title, required this.jsonObject, super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    Widget text;
    bool isJson = jsonObject is List || jsonObject is Map;
    if (isJson) {
      text = Expanded(
        child: JsonView(
          json: jsonObject,
          shrinkWrap: false,
          physics: null,
          styleScheme: const JsonStyleScheme(openAtStart: true),
        ),
      );
    } else if (jsonObject != null) {
      text = SelectableText(jsonObject.toString(), style: textTheme.bodyMedium?.copyWith(color: DesignColors.white2));
    } else {
      text = Text(
        S.of(context).errorPreviewNotAvailable,
        style: textTheme.bodyMedium?.copyWith(color: DesignColors.white2),
      );
    }
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(title),
            TextButton.icon(
              onPressed: () => _handleCopy(context),
              icon: const Icon(AppIcons.copy, size: 18),
              label: Text(S.of(context).copy),
            ),
          ],
        ),
        const SizedBox(height: 15),
        text,
      ],
    );

    return TxInputWrapper(height: 400, child: isJson ? content : SingleChildScrollView(child: content));
  }

  void _handleCopy(BuildContext context) {
    JsonEncoder encoder = const JsonEncoder.withIndent('    ');
    String jsonData = encoder.convert(jsonObject);

    Clipboard.setData(ClipboardData(text: jsonData));

    KiraToast.of(context).show(message: S.of(context).toastSuccessfullyCopied, type: ToastType.success);
  }
}
