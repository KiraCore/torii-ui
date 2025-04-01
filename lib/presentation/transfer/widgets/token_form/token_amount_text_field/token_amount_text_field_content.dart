import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:torii_client/domain/exports.dart';
import 'package:torii_client/presentation/transfer/widgets/token_form/token_amount_text_field/token_amount_text_input_formatter.dart';
import 'package:torii_client/presentation/transfer/widgets/tx_text_field.dart';
import 'package:torii_client/presentation/widgets/buttons/kira_chip_button.dart';
import 'package:torii_client/utils/extensions/tx_utils.dart';

class TokenAmountTextFieldContent extends StatefulWidget {
  final bool disabledBool;
  final String label;
  final TextEditingController textEditingController;
  final TokenDenominationModel? selectedTokenDenomination;
  final List<TokenDenominationModel> tokenDenominations;
  final FocusNode focusNode;
  final bool errorExistsBool;
  final void Function(String text) onChanged;
  final void Function(TokenDenominationModel tokenDenominationModel) onChangedDenomination;

  const TokenAmountTextFieldContent({
    required this.disabledBool,
    required this.label,
    required this.textEditingController,
    required this.selectedTokenDenomination,
    required this.tokenDenominations,
    required this.focusNode,
    required this.onChanged,
    required this.onChangedDenomination,
    this.errorExistsBool = false,
    super.key,
  });

  @override
  State<TokenAmountTextFieldContent> createState() => _TokenAmountTextFieldContentState();
}

class _TokenAmountTextFieldContentState extends State<TokenAmountTextFieldContent> {
  TokenDenominationModel? selectedTokenDenomination;

  @override
  void initState() {
    super.initState();
    selectedTokenDenomination = widget.selectedTokenDenomination;
    widget.focusNode.addListener(_handleFocusChanged);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_handleFocusChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TxTextField(
      maxLines: 1,
      focusNode: widget.focusNode,
      hasErrors: widget.errorExistsBool,
      disabled: widget.disabledBool,
      textEditingController: widget.textEditingController,
      inputFormatters: <TextInputFormatter>[
        TokenAmountTextInputFormatter(tokenDenominationModel: selectedTokenDenomination),
      ],
      suffix: Row(
        mainAxisSize: MainAxisSize.min,
        children:
            widget.tokenDenominations.map((TokenDenominationModel tokenDenominationModel) {
              return KiraChipButton(
                label: tokenDenominationModel.name,
                margin: const EdgeInsets.only(right: 8),
                selected: selectedTokenDenomination == tokenDenominationModel,
                onTap: () => _handleTokenDenominationModelChanged(tokenDenominationModel),
              );
            }).toList(),
      ),
      onChanged: widget.onChanged,
    );
  }

  void _handleTokenDenominationModelChanged(TokenDenominationModel tokenDenominationModel) {
    selectedTokenDenomination = tokenDenominationModel;
    widget.onChangedDenomination(tokenDenominationModel);
    // setState(() {});
  }

  void _handleFocusChanged() {
    bool focusedBool = widget.focusNode.hasFocus;
    String text = widget.textEditingController.text;
    String displayedAmount = TxUtils.buildAmountString(text, selectedTokenDenomination);
    if (focusedBool == false && text.isEmpty) {
      widget.textEditingController.text = '0';
    } else if (focusedBool == false) {
      widget.textEditingController.text = displayedAmount;
    } else if (focusedBool && text == '0') {
      widget.textEditingController.text = '';
    }
  }
}
