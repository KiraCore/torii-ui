import 'package:flutter/material.dart';
import 'package:torii_client/domain/models/network/error_explorer_model.dart';
import 'package:torii_client/presentation/transfer/error_explorer_dialog/error_explorer_json_preview.dart';
import 'package:torii_client/presentation/transfer/send/tx_dialog.dart';
import 'package:torii_client/presentation/transfer/widgets/tx_input_wrapper.dart';
import 'package:torii_client/utils/exports.dart';

class ErrorExplorerDialog extends StatelessWidget {
  final ErrorExplorerModel errorExplorerModel;

  const ErrorExplorerDialog({required this.errorExplorerModel, super.key});

  @override
  Widget build(BuildContext context) {
    return TxDialog(
      maxWidth: 800,
      title: S.of(context).errorExplorer,
      subtitle: <String>[errorExplorerModel.code, if (errorExplorerModel.message != null) errorExplorerModel.message!],
      suffixWidget: IconButton(
        icon: const Icon(AppIcons.cancel, color: DesignColors.white1),
        onPressed: () => Navigator.of(context).pop(),
      ),
      child: Column(
        children: <Widget>[
          TxInputWrapper(
            child: Row(
              children: <Widget>[
                Text(errorExplorerModel.method, style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(width: 20),
                Expanded(child: SelectableText(errorExplorerModel.uri.toString())),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Row(
            children: <Widget>[
              Expanded(
                child: ErrorExplorerJsonPreview(
                  title: S.of(context).txErrorHttpRequest,
                  jsonObject: errorExplorerModel.request,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: ErrorExplorerJsonPreview(
                  title: S.of(context).txErrorHttpResponse,
                  jsonObject: errorExplorerModel.response,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
