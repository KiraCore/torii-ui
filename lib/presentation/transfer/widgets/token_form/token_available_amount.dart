import 'package:flutter/material.dart';
import 'package:torii_client/domain/models/exports.dart';
import 'package:torii_client/utils/exports.dart';

class TokenAvailableAmount extends StatelessWidget {
  final TokenAmountModel feeTokenAmountModel;
  final FormFieldState<TokenAmountModel> formFieldState;
  final TokenAmountModel? balance;
  final TokenDenominationModel? tokenDenominationModel;

  const TokenAvailableAmount({
    required this.feeTokenAmountModel,
    required this.formFieldState,
    this.balance,
    this.tokenDenominationModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    if (tokenDenominationModel == null || balance == null) {
      return const SizedBox();
    }
    TokenAmountModel availableTokenAmountModel = balance! - feeTokenAmountModel;
    String availableAmountText = availableTokenAmountModel.getAmountInDenomination(tokenDenominationModel!).toString();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 7),
        if (formFieldState.hasError) ...<Widget>[
          Text(formFieldState.errorText!, style: textTheme.bodySmall!.copyWith(color: DesignColors.redStatus1)),
        ],
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 7),
            Text(
              S.of(context).txAvailableBalances(availableAmountText, tokenDenominationModel!.name),
              style: textTheme.bodySmall!.copyWith(
                color: formFieldState.hasError ? DesignColors.redStatus1 : DesignColors.white2,
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ],
    );
  }
}
