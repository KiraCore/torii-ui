import 'package:flutter/material.dart';
import 'package:torii_client/presentation/widgets/kira_toast/toast_container.dart';
import 'package:torii_client/presentation/widgets/kira_toast/toast_type.dart';
import 'package:torii_client/utils/exports.dart';
import 'package:torii_client/utils/network/interx_warning_model.dart';

class NetworkWarningContainer extends StatelessWidget {
  final InterxWarningType interxWarningType;
  final String latestBlockTime;

  const NetworkWarningContainer({required this.interxWarningType, required this.latestBlockTime, super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    Map<InterxWarningType, String> interxWarningMessages = <InterxWarningType, String>{
      InterxWarningType.missingDefaultTokenDenomModel: S.of(context).networkWarningMissingInfo,
      InterxWarningType.blockTimeOutdated: S.of(context).networkWarningWhenLastBlock(latestBlockTime),
      InterxWarningType.versionOutdated: S.of(context).networkWarningIncompatible,
    };

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ToastContainer(
        width: double.infinity,
        title: Text(
          interxWarningMessages[interxWarningType] ?? S.of(context).errorUndefined,
          style: textTheme.bodySmall!,
        ),
        toastType: ToastType.warning,
      ),
    );
  }
}
