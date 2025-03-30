import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:torii_client/domain/models/tokens/token_denomination_model.dart';
import 'package:torii_client/presentation/transfer/widgets/token_form/cubit/token_form_cubit.dart';
import 'package:torii_client/presentation/transfer/widgets/token_form/token_amount_text_field/token_amount_text_field_actions.dart';
import 'package:torii_client/presentation/transfer/widgets/token_form/token_amount_text_field/token_amount_text_field_content.dart';
import 'package:torii_client/presentation/transfer/widgets/token_form/tx_input_static_label.dart';
import 'package:torii_client/presentation/transfer/widgets/tx_input_wrapper.dart';

class TokenAmountTextField extends StatelessWidget {
  final bool disabledBool;
  final bool errorExistsBool;
  final String label;
  final TextEditingController textEditingController;
  final TokenDenominationModel? tokenDenominationModel;

  const TokenAmountTextField({
    required this.disabledBool,
    required this.label,
    required this.textEditingController,
    required this.tokenDenominationModel,
    this.errorExistsBool = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    bool correctDisabledBool = disabledBool || tokenDenominationModel == null;

    return Column(
      children: <Widget>[
        TxInputWrapper(
          disabled: correctDisabledBool,
          height: 80,
          hasErrors: errorExistsBool,
          builderWithFocus:
              (FocusNode focusNode) => SizedBox(
                height: double.infinity,
                child: Center(
                  child: TxInputStaticLabel(
                    label: label,
                    contentPadding: const EdgeInsets.only(top: 8, bottom: 4),
                    child: TokenAmountTextFieldContent(
                      disabledBool: correctDisabledBool,
                      label: label,
                      textEditingController: textEditingController,
                      tokenDenominationModel: tokenDenominationModel,
                      focusNode: focusNode,
                      errorExistsBool: errorExistsBool,
                      onChanged:
                          (String text) => BlocProvider.of<TokenFormCubit>(context).notifyTokenAmountTextChanged(text),
                    ),
                  ),
                ),
              ),
        ),
        TokenAmountTextFieldActions(disabled: correctDisabledBool),
      ],
    );
  }
}
