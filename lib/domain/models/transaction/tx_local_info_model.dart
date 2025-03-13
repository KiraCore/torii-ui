import 'package:equatable/equatable.dart';
import 'package:torii_client/domain/models/messages/a_tx_msg_model.dart';
import 'package:torii_client/domain/models/tokens/token_amount_model.dart';
import 'package:torii_client/utils/extensions/tx_utils.dart';

class TxLocalInfoModel extends Equatable {
  final String memo;
  final TokenAmountModel feeTokenAmountModel;
  final ATxMsgModel txMsgModel;

  const TxLocalInfoModel({required this.memo, required this.feeTokenAmountModel, required this.txMsgModel});

  String get replacedMemo => TxUtils.replaceMemoRestrictedChars(memo);

  @override
  List<Object?> get props => <Object>[memo, feeTokenAmountModel, txMsgModel];
}
