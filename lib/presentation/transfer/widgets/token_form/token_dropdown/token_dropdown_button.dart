import 'package:flutter/material.dart';
import 'package:torii_client/domain/exports.dart';
import 'package:torii_client/presentation/transfer/widgets/token_form/tx_input_static_label.dart';
import 'package:torii_client/presentation/widgets/avatar/token_avatar.dart';
import 'package:torii_client/utils/exports.dart';

class TokenDropdownButton extends StatelessWidget {
  final bool disabledBool;
  final TokenAliasModel? tokenAliasModel;

  const TokenDropdownButton({this.disabledBool = false, this.tokenAliasModel, super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: TxInputStaticLabel(
            label: S.of(context).txToken,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                TokenAvatar(iconUrl: tokenAliasModel?.icon, size: 24),
                const SizedBox(width: 8),
                // Text(
                //   tokenAliasModel?.networkTokenDenominationModel.name ?? '---',
                //   style: textTheme.bodyLarge!.copyWith(
                //     color: DesignColors.white1,
                //   ),
                // ),
              ],
            ),
          ),
        ),
        if (disabledBool == false) const Icon(AppIcons.check, color: DesignColors.white1, size: 16),
      ],
    );
  }
}
