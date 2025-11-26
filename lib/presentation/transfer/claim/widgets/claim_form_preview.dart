import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:torii_client/domain/models/tokens/list/tx_list_item_model.dart';
import 'package:torii_client/domain/models/tokens/token_amount_model.dart';
import 'package:torii_client/domain/models/tokens/token_denomination_model.dart';
import 'package:torii_client/presentation/transfer/widgets/token_form/token_denomination_list.dart';
import 'package:torii_client/presentation/transfer/widgets/tx_input_preview.dart';
import 'package:torii_client/presentation/widgets/avatar/kira_identity_avatar.dart';
import 'package:torii_client/presentation/widgets/avatar/token_avatar.dart';
import 'package:torii_client/utils/exports.dart';
import 'package:torii_client/utils/extensions/tx_utils.dart';

class ClaimFormPreview extends StatefulWidget {
  final TxListItemModel txListItemModel;

  const ClaimFormPreview({required this.txListItemModel, super.key});

  @override
  State<StatefulWidget> createState() => _ClaimFormPreview();
}

class _ClaimFormPreview extends State<ClaimFormPreview> {
  late TextTheme textTheme;
  late TokenDenominationModel selectedTokenDenominationModel;

  @override
  void initState() {
    super.initState();
    selectedTokenDenominationModel =
        widget.txListItemModel.txMsgModels.firstOrNull!.tokenAmountModel.tokenAliasModel.baseTokenDenominationModel;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    textTheme = Theme.of(context).textTheme;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TxInputPreview(
          label: 'Hash',
          value: widget.txListItemModel.hash.toLowerCase(),
          copyable: true,
          fitInOneLine: true,
        ),
        const SizedBox(height: 16),
        TxInputPreview(
          label: 'Timestamp',
          value: DateFormat('dd/MM/yyyy, HH:mm').format(widget.txListItemModel.time.toLocal()),
        ),
        const SizedBox(height: 28),
        TxInputPreview(
          label: S.of(context).txHintSendFrom,
          value: widget.txListItemModel.txMsgModels.firstOrNull!.fromWalletAddress.address,
          icon: KiraIdentityAvatar(
            address: widget.txListItemModel.txMsgModels.firstOrNull!.fromWalletAddress.address,
            size: 45,
          ),
          copyable: true,
          fitInOneLine: true,
        ),
        const SizedBox(height: 28),
        TxInputPreview(
          label: S.of(context).txHintSendTo,
          value: widget.txListItemModel.txMsgModels.firstOrNull!.toWalletAddress.address,
          icon: KiraIdentityAvatar(
            address: widget.txListItemModel.txMsgModels.firstOrNull!.toWalletAddress.address,
            size: 45,
          ),
          copyable: true,
          fitInOneLine: true,
        ),
        const SizedBox(height: 28),
        TxInputPreview(
          label: S.of(context).txTotalAmount,
          value: _totalAmountText,
          icon: TokenAvatar(iconUrl: _iconUrl, size: 45),
        ),
        const SizedBox(height: 15),
        const Divider(color: DesignColors.grey2),
        const SizedBox(height: 15),
        TxInputPreview(label: S.of(context).txRecipientWillGet, value: _netAmountText, large: true),
        const SizedBox(height: 15),
        Text(
          S.of(context).txNoticeFee(_feeAmountText),
          style: textTheme.bodySmall!.copyWith(color: DesignColors.white1),
        ),
        const SizedBox(height: 15),
        TokenDenominationList(
          tokenAliasModel: widget.txListItemModel.txMsgModels.firstOrNull!.tokenAmountModel.tokenAliasModel,
          defaultTokenDenominationModel: selectedTokenDenominationModel,
          onChanged: _handleTokenDenominationChanged,
        ),
        const SizedBox(height: 15),
        TxInputPreview(label: S.of(context).txHintMemo, value: widget.txListItemModel.memo),
      ],
    );
  }

  String get _totalAmountText {
    TokenAmountModel totalTokenAmountModel =
        widget.txListItemModel.txMsgModels.firstOrNull!.tokenAmountModel + widget.txListItemModel.totalFees;
    Decimal totalAmount = totalTokenAmountModel.getAmountInDenomination(selectedTokenDenominationModel);
    String denominationText = selectedTokenDenominationModel.name;
    return '$totalAmount $denominationText';
  }

  String get _netAmountText {
    TokenAmountModel netTokenAmountModel = widget.txListItemModel.txMsgModels.firstOrNull!.tokenAmountModel;
    Decimal netAmount = netTokenAmountModel.getAmountInDenomination(selectedTokenDenominationModel);
    String denominationText = selectedTokenDenominationModel.name;

    String displayedAmount = TxUtils.buildAmountString(netAmount.toString(), selectedTokenDenominationModel);
    return '$displayedAmount $denominationText';
  }

  String? get _iconUrl {
    TokenAmountModel netTokenAmountModel = widget.txListItemModel.txMsgModels.firstOrNull!.tokenAmountModel;
    return netTokenAmountModel.tokenAliasModel.icon;
  }

  String get _feeAmountText {
    return widget.txListItemModel.totalFees.toString();
  }

  void _handleTokenDenominationChanged(TokenDenominationModel tokenDenominationModel) {
    selectedTokenDenominationModel = tokenDenominationModel;
    setState(() {});
  }
}
