import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:torii_client/data/dto/api_kira/broadcast/request/broadcast_req.dart';
import 'package:torii_client/data/dto/api_kira/broadcast/response/broadcast_resp.dart';
import 'package:torii_client/data/dto/api_request_model.dart';
import 'package:torii_client/domain/models/transaction/broadcast_resp_model.dart';
import 'package:torii_client/domain/models/transaction/signed_transaction_model.dart';
import 'package:torii_client/domain/repositories/api_kira_repository.dart';
import 'package:torii_client/presentation/network/bloc/network_module_bloc.dart';
import 'package:torii_client/utils/exports.dart';

@injectable
class BroadcastService {
  final IApiKiraRepository _apiKiraRepository;

  BroadcastService(this._apiKiraRepository);

  Future<BroadcastRespModel> broadcastTx(SignedTxModel signedTransactionModel) async {
    Uri? networkUri = getIt<NetworkModuleBloc>().state.networkUri;
    if (networkUri == null) {
      throw Exception('Network URI is null');
    }
    Response<dynamic> response = await _apiKiraRepository.broadcast<dynamic>(
      ApiRequestModel<BroadcastReq>(
        networkUri: networkUri,
        requestData: BroadcastReq(tx: signedTransactionModel.signedCosmosTx),
      ),
    );

    late BroadcastRespModel broadcastRespModel;
    try {
      BroadcastResp broadcastResp = BroadcastResp.fromJson(response.data as Map<String, dynamic>);
      broadcastRespModel = BroadcastRespModel.fromDto(broadcastResp);
    } catch (e) {
      getIt<Logger>().e('BroadcastService: Cannot parse broadcastTx for URI $networkUri: ${e}');
      rethrow;
    }

    // if (broadcastRespModel.hasErrors) {
    //   throw TxBroadcastException(
    //     broadcastErrorLogModel: broadcastRespModel.broadcastErrorLogModel!,
    //     response: response,
    //   );
    // }

    return broadcastRespModel;
  }
}
