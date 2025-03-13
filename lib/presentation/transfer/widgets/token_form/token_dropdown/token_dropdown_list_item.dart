import 'package:flutter/material.dart';
import 'package:torii_client/domain/models/tokens/token_alias_model.dart';
import 'package:torii_client/presentation/transfer/widgets/token_form/token_dropdown/token_dropdown_list_item_layout.dart';
import 'package:torii_client/presentation/widgets/avatar/token_avatar.dart';
import 'package:torii_client/utils/exports.dart';

class TokenDropdownListItem extends StatelessWidget {
  final VoidCallback onTap;
  final bool selected;
  final TokenAliasModel tokenAliasModel;

  const TokenDropdownListItem({required this.onTap, required this.selected, required this.tokenAliasModel, super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return TokenDropdownListItemLayout(
      onTap: onTap,
      selected: selected,
      icon: TokenAvatar(iconUrl: tokenAliasModel.icon, size: 30),
      title: Text(
        // TODO: it was networkTokenDenominationModel.name
        tokenAliasModel.defaultTokenDenominationModel.name,
        style: textTheme.titleSmall!.copyWith(color: DesignColors.white1),
      ),
      subtitle: Text(tokenAliasModel.name, style: textTheme.bodySmall!.copyWith(color: DesignColors.white1)),
    );
  }
}
