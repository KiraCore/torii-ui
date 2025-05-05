import 'package:equatable/equatable.dart';
import 'package:torii_client/data/dto/api_kira/broadcast/response/broadcast_resp.dart';
import 'package:torii_client/domain/models/transaction/broadcast_error_log_model.dart';

class BroadcastRespModel extends Equatable {
  final String hash;

  const BroadcastRespModel({required this.hash});

  factory BroadcastRespModel.fromDto(BroadcastResp broadcastResp) {
    // TODO: errors
    // BroadcastErrorLogModel? checkTxBroadcastErrorLogModel = BroadcastErrorLogModel.fromDto(broadcastResp.checkTx);
    // BroadcastErrorLogModel? deliverTxBroadcastErrorLogModel = BroadcastErrorLogModel.fromDto(broadcastResp.deliverTx);

    return BroadcastRespModel(
      hash: broadcastResp.hash,
      // broadcastErrorLogModel: checkTxBroadcastErrorLogModel ?? deliverTxBroadcastErrorLogModel,
    );
  }

  @override
  List<Object?> get props => <Object>[hash];
}
