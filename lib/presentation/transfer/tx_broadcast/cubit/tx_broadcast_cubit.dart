import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:torii_client/domain/models/network/error_explorer_model.dart';
import 'package:torii_client/domain/models/transaction/broadcast_resp_model.dart';
import 'package:torii_client/domain/models/transaction/signed_transaction_model.dart';
import 'package:torii_client/domain/services/miro/broadcast_service.dart';
import 'package:torii_client/presentation/transfer/tx_broadcast/cubit/a_tx_broadcast_state.dart';
import 'package:torii_client/presentation/transfer/tx_broadcast/cubit/states/tx_broadcast_completed_state.dart';
import 'package:torii_client/presentation/transfer/tx_broadcast/cubit/states/tx_broadcast_error_state.dart';
import 'package:torii_client/presentation/transfer/tx_broadcast/cubit/states/tx_broadcast_loading_state.dart';
import 'package:torii_client/utils/exports.dart';

class TxBroadcastCubit extends Cubit<ATxBroadcastState> {
  final BroadcastService broadcastService = getIt<BroadcastService>();

  TxBroadcastCubit() : super(TxBroadcastLoadingState());

  Future<void> broadcast(SignedTxModel signedTxModel) async {
    emit(TxBroadcastLoadingState());
    try {
      BroadcastRespModel broadcastRespModel = await broadcastService.broadcastTx(signedTxModel);
      emit(TxBroadcastCompletedState(broadcastRespModel: broadcastRespModel));
    } on DioException catch (e) {
      ErrorExplorerModel errorExplorerModel = ErrorExplorerModel.fromDioConnectException(e);
      emit(TxBroadcastErrorState(errorExplorerModel: errorExplorerModel));
    }
    // on DioParseException catch (dioParseException) {
    //   ErrorExplorerModel errorExplorerModel = ErrorExplorerModel.fromDioParseException(dioParseException);
    //   emit(TxBroadcastErrorState(errorExplorerModel: errorExplorerModel));
    // } on TxBroadcastException catch (txBroadcastException) {
    //   RequestOptions requestOptions = txBroadcastException.response.requestOptions;

    //   ErrorExplorerModel errorExplorerModel = ErrorExplorerModel(
    //     code: txBroadcastException.broadcastErrorLogModel.code,
    //     message: txBroadcastException.broadcastErrorLogModel.message,
    //     uri: requestOptions.uri,
    //     method: requestOptions.method,
    //     request: requestOptions.data,
    //     response: txBroadcastException.response.data,
    //   );
    //   emit(TxBroadcastErrorState(errorExplorerModel: errorExplorerModel));
    // }
  }
}
