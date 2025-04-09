import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:torii_client/domain/models/messages/msg_send_model.dart';
import 'package:torii_client/domain/models/tokens/msg_send_form_model.dart';
import 'package:torii_client/domain/models/tokens/token_alias_model.dart';
import 'package:torii_client/domain/models/tokens/token_amount_model.dart';
import 'package:torii_client/domain/models/tokens/token_denomination_model.dart';
import 'package:torii_client/domain/models/transaction/tx_local_info_model.dart';
import 'package:torii_client/presentation/transfer/tx_process_cubit/tx_process_cubit.dart';
import 'package:torii_client/presentation/transfer/widgets/token_form/token_denomination_list.dart';
import 'package:torii_client/presentation/transfer/widgets/tx_input_preview.dart';
import 'package:torii_client/presentation/widgets/avatar/kira_identity_avatar.dart';
import 'package:torii_client/presentation/widgets/avatar/token_avatar.dart';
import 'package:torii_client/utils/exports.dart';
import 'package:torii_client/utils/extensions/tx_utils.dart';

class MsgSendFormPreview extends StatefulWidget {
  final TxLocalInfoModel? txLocalInfoModel;

  MsgSendFormPreview({required this.txLocalInfoModel, Key? key})
    : assert(txLocalInfoModel?.txMsgModel is MsgSendModel?, 'ITxMsgModel must be an instance of MsgSendModel'),
      super(key: key);

  @override
  State<StatefulWidget> createState() => _MsgSendFormPreview();
}

class _MsgSendFormPreview extends State<MsgSendFormPreview> {
  late TokenDenominationModel selectedTokenDenominationModel;

  MsgSendFormModel get msgSendFormModel => context.read<TxProcessCubit<MsgSendFormModel>>().msgFormModel;

  @override
  Widget build(BuildContext context) {
    selectedTokenDenominationModel = msgSendFormModel.tokenDenominationModel!;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TxInputPreview(
          label: S.of(context).txHintSendFrom,
          value: msgSendFormModel.senderWalletAddress!.address,
          icon: KiraIdentityAvatar(address: msgSendFormModel.senderWalletAddress!.address, size: 45),
        ),
        const SizedBox(height: 28),
        TxInputPreview(
          label: S.of(context).txHintSendTo,
          value: msgSendFormModel.recipientWalletAddress!.address,
          icon: KiraIdentityAvatar(address: msgSendFormModel.recipientWalletAddress!.address, size: 45),
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
          tokenAliasModel: msgSendFormModel.tokenAmountModel!.tokenAliasModel,
          defaultTokenDenominationModel: selectedTokenDenominationModel,
          onChanged: _handleTokenDenominationChanged,
        ),
        const SizedBox(height: 15),
        TxInputPreview(label: S.of(context).txHintMemo, value: msgSendFormModel.memo),
      ],
    );
  }

  String get _totalAmountText {
    TokenAmountModel totalTokenAmountModel =
        msgSendFormModel.tokenAmountModel! +
        (widget.txLocalInfoModel?.feeTokenAmountModel ??
            TokenAmountModel.zero(tokenAliasModel: msgSendFormModel.tokenAmountModel!.tokenAliasModel));
    Decimal totalAmount = totalTokenAmountModel.getAmountInDenomination(selectedTokenDenominationModel);
    String denominationText = selectedTokenDenominationModel.name;
    return '$totalAmount $denominationText';
  }

  String get _netAmountText {
    TokenAmountModel netTokenAmountModel = msgSendFormModel.tokenAmountModel!;
    Decimal netAmount = netTokenAmountModel.getAmountInDenomination(selectedTokenDenominationModel);
    String denominationText = selectedTokenDenominationModel.name;

    String displayedAmount = TxUtils.buildAmountString(netAmount.toString(), selectedTokenDenominationModel);
    return '$displayedAmount $denominationText';
  }

  String? get _iconUrl {
    TokenAmountModel netTokenAmountModel = msgSendFormModel.tokenAmountModel!;
    return netTokenAmountModel.tokenAliasModel.icon;
  }

  String get _feeAmountText {
    return widget.txLocalInfoModel?.feeTokenAmountModel.toString() ?? '0';
  }

  void _handleTokenDenominationChanged(TokenDenominationModel tokenDenominationModel) {
    msgSendFormModel.tokenDenominationModel = tokenDenominationModel;
    selectedTokenDenominationModel = tokenDenominationModel;
    setState(() {});
  }
}
