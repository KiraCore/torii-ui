import 'package:decimal/decimal.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web3/flutter_web3.dart';
import 'package:injectable/injectable.dart';
import 'package:torii_client/domain/exports.dart';
import 'package:torii_client/domain/models/network/error_explorer_model.dart';
import 'package:torii_client/domain/models/transaction/broadcast_resp_model.dart';
import 'package:torii_client/domain/models/transaction/signed_transaction_model.dart';
import 'package:torii_client/domain/services/miro/broadcast_service.dart';
import 'package:torii_client/presentation/global/logs/torii_logs_cubit.dart';
import 'package:torii_client/presentation/global/session/cubit/session_cubit.dart';
import 'package:torii_client/presentation/transfer/tx_broadcast/cubit/a_tx_broadcast_state.dart';
import 'package:torii_client/presentation/transfer/tx_broadcast/cubit/states/tx_broadcast_completed_state.dart';
import 'package:torii_client/presentation/transfer/tx_broadcast/cubit/states/tx_broadcast_error_state.dart';
import 'package:torii_client/presentation/transfer/tx_broadcast/cubit/states/tx_broadcast_loading_state.dart';
import 'package:torii_client/utils/exports.dart';

@injectable
class TxBroadcastCubit extends Cubit<ATxBroadcastState> {
  TxBroadcastCubit(this._broadcastService, this._ethereumService, this._toriiLogsCubit, this._sessionCubit)
    : super(TxBroadcastLoadingState());

  final BroadcastService _broadcastService;
  final EthereumService _ethereumService;
  final ToriiLogsCubit _toriiLogsCubit;
  final SessionCubit _sessionCubit;

  // TODO: test error explorer
  Future<void> broadcastFromEth({
    required String passphrase,
    required String kiraRecipient,
    required Decimal ukexAmount,
  }) async {
    emit(TxBroadcastLoadingState());
    try {
      final TransactionResponse? tx = await _ethereumService.exportContractTokens(
        passphrase: passphrase,
        kiraAddress: kiraRecipient,
        ukexAmount: ukexAmount,
      );
      if (tx != null) {
        final BroadcastRespModel broadcastRespModel = BroadcastRespModel(hash: tx.hash);
        emit(TxBroadcastCompletedState(broadcastRespModel: broadcastRespModel, isEthRecipient: false));
      } else {
        emit(
          TxBroadcastErrorState(
            errorExplorerModel: ErrorExplorerModel.fromEthereumException(
              uri: Uri.parse('exportContractTokens'),
              method: 'POST',
              request: kiraRecipient,
              response: 'Connection error',
            ),
          ),
        );
      }
    } catch (e) {
      getIt<Logger>().e('Error broadcasting from Ethereum: $e');
      emit(
        TxBroadcastErrorState(
          errorExplorerModel: ErrorExplorerModel.fromEthereumException(
            uri: Uri.parse('exportContractTokens'),
            method: 'POST',
            request: kiraRecipient,
            response: e.toString(),
          ),
        ),
      );
    }
  }

  Future<void> broadcastFromKira({required SignedTxModel signedTxModel}) async {
    emit(TxBroadcastLoadingState());
    try {
      BroadcastRespModel broadcastRespModel = await _broadcastService.broadcastTx(signedTxModel);
      emit(TxBroadcastCompletedState(broadcastRespModel: broadcastRespModel, isEthRecipient: true));

      if (signedTxModel.txLocalInfoModel.txMsgModel.toWalletAddress == _sessionCubit.state.ethereumWallet?.address) {
        await _toriiLogsCubit.triggerLongPolling();
      }
    } on DioException catch (e) {
      getIt<Logger>().e('Error broadcasting from Kira: $e');
      ErrorExplorerModel errorExplorerModel = ErrorExplorerModel.fromDioConnectException(e);
      emit(TxBroadcastErrorState(errorExplorerModel: errorExplorerModel));
    } catch (e) {
      getIt<Logger>().e('Error broadcasting from Kira: $e');
      ErrorExplorerModel errorExplorerModel = ErrorExplorerModel.unknown(
        // TODO: add correct uri
        uri: Uri.parse('/kira/txs'),
        method: 'POST',
        request: signedTxModel.signedCosmosTx.toProtoJson(),
        response: e.toString(),
      );
      emit(TxBroadcastErrorState(errorExplorerModel: errorExplorerModel));
    }

    // TODO:
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
