import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:torii_client/presentation/transfer/widgets/tx_input_wrapper.dart';
import 'package:torii_client/presentation/widgets/kira_toast/kira_toast.dart';
import 'package:torii_client/presentation/widgets/kira_toast/toast_type.dart';
import 'package:torii_client/utils/exports.dart';
import 'package:torii_client/utils/theme/app_icons.dart';

class ErrorExplorerJsonPreview extends StatelessWidget {
  final String title;
  final dynamic jsonObject;

  const ErrorExplorerJsonPreview({required this.title, required this.jsonObject, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TxInputWrapper(
      height: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //todo
          // Row(
          //   children: <Widget>[
          //     Text(title),
          //     const Spacer(),
          //     TextButton.icon(
          //       onPressed: () => _handleCopy(context),
          //       icon: const Icon(AppIcons.copy, size: 18),
          //       label: Text(S.of(context).copy),
          //     ),
          //   ],
          // ),
          const SizedBox(height: 15),
          // if (jsonObject is List || jsonObject is Map)
          //   SizedBoxExpanded(
          //     expandOn: const <ScreenSize>[ScreenSize.desktop, ScreenSize.tablet],
          //     defaultOn: const <ScreenSize>[ScreenSize.mobile],
          //     child: JsonView(
          //       json: jsonObject,
          //       shrinkWrap: const ResponsiveValue<bool>(
          //         largeScreen: false,
          //         mediumScreen: false,
          //         smallScreen: true,
          //       ).get(context),
          //       physics: const ResponsiveValue<ScrollPhysics?>(
          //         largeScreen: null,
          //         mediumScreen: null,
          //         smallScreen: NeverScrollableScrollPhysics(),
          //       ).get(context),
          //       styleScheme: const JsonStyleScheme(openAtStart: true),
          //     ),
          //   )
          // else if (jsonObject != null)
          //   Text(jsonObject.toString())
          // else
          //   Text(S.of(context).errorPreviewNotAvailable),
        ],
      ),
    );
  }

  void _handleCopy(BuildContext context) {
    JsonEncoder encoder = const JsonEncoder.withIndent('    ');
    String jsonData = encoder.convert(jsonObject);

    Clipboard.setData(ClipboardData(text: jsonData));
    //todo
    // KiraToast.of(context).show(message: S.of(context).toastSuccessfullyCopied, type: ToastType.success);
  }
}
