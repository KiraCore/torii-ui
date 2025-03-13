import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:torii_client/domain/models/transaction/tx_local_info_model.dart';
import 'package:torii_client/domain/models/transaction/tx_remote_info_model.dart';

class SignedTxModel extends Equatable {
  final TxLocalInfoModel txLocalInfoModel;
  final TxRemoteInfoModel txRemoteInfoModel;
  final CosmosTx signedCosmosTx;

  const SignedTxModel({required this.txLocalInfoModel, required this.txRemoteInfoModel, required this.signedCosmosTx});

  @override
  List<Object?> get props => <Object>[txLocalInfoModel, txRemoteInfoModel, signedCosmosTx];
}
