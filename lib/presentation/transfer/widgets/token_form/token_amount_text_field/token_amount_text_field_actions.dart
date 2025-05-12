import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:torii_client/domain/models/tokens/token_amount_model.dart';
import 'package:torii_client/domain/models/tokens/token_denomination_model.dart';
import 'package:torii_client/presentation/transfer/widgets/token_form/cubit/token_form_cubit.dart';
import 'package:torii_client/presentation/transfer/widgets/token_form/cubit/token_form_state.dart';
import 'package:torii_client/utils/exports.dart';

class TokenAmountTextFieldActions extends StatefulWidget {
  final bool disabled;
  final TokenFormState tokenFormState;
  final bool hasError;

  const TokenAmountTextFieldActions({
    required this.disabled,
    required this.tokenFormState,
    required this.hasError,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _TokenAmountTextFieldActions();
}

class _TokenAmountTextFieldActions extends State<TokenAmountTextFieldActions> {
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    // TODO: refactor available amount ?? why did we need to extract the fees from the balance ????????
    TokenAmountModel? availableTokenAmount =
        widget.tokenFormState.balance; // - widget.tokenFormState.feeTokenAmountModel;
    TokenDenominationModel? tokenDenomination = widget.tokenFormState.tokenDenominationModel;
    String availableAmountText = '';
    if (availableTokenAmount != null && tokenDenomination != null) {
      availableAmountText = S
          .of(context)
          .txAvailableBalances(
            availableTokenAmount.getAmountInDenomination(tokenDenomination).toString(),
            tokenDenomination.name,
          );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: Text(
            availableAmountText,
            style: textTheme.bodySmall!.copyWith(
              color: widget.hasError ? DesignColors.redStatus1 : DesignColors.white2,
            ),
          ),
        ),
        TextButton(
          onPressed: widget.disabled ? null : _handleSendAllPressed,
          style: ButtonStyle(padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero)),
          child: Text(S.of(context).txButtonSendAll),
        ),
        const SizedBox(width: 10),
        TextButton(
          onPressed: widget.disabled ? null : _handleClearPressed,
          style: ButtonStyle(padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero)),
          child: Text(S.of(context).txButtonClear),
        ),
      ],
    );
  }

  void _handleSendAllPressed() {
    BlocProvider.of<TokenFormCubit>(context).setAllAvailableAmount();
  }

  void _handleClearPressed() {
    BlocProvider.of<TokenFormCubit>(context).clearTokenAmount();
  }
}
