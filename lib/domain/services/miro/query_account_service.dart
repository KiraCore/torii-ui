import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:torii_client/data/api/interx_headers.dart';
import 'package:torii_client/data/dto/api_kira/query_account/request/query_account_req.dart';
import 'package:torii_client/data/dto/api_kira/query_account/response/query_account_resp.dart';
import 'package:torii_client/data/dto/api_request_model.dart';
import 'package:torii_client/domain/models/transaction/tx_remote_info_model.dart';
import 'package:torii_client/domain/repositories/api_kira_repository.dart';
import 'package:torii_client/presentation/network/bloc/network_module_bloc.dart';
import 'package:torii_client/utils/exports.dart';

@injectable
class QueryAccountService {
  final IApiKiraRepository _apiKiraRepository;

  QueryAccountService(this._apiKiraRepository);

  Future<TxRemoteInfoModel> getTxRemoteInfo(String accountAddress) async {
    Uri networkUri = getIt<NetworkModuleBloc>().state.networkUri;
    Response<dynamic> response = await _apiKiraRepository.fetchQueryAccount<dynamic>(
      ApiRequestModel<QueryAccountReq>(networkUri: networkUri, requestData: QueryAccountReq(address: accountAddress)),
    );

    try {
      QueryAccountResp queryAccountResp = QueryAccountResp.fromJson(response.data as Map<String, dynamic>);
      InterxHeaders interxHeaders = InterxHeaders.fromHeaders(response.headers);

      TxRemoteInfoModel txRemoteInfoModel = TxRemoteInfoModel(
        accountNumber: queryAccountResp.accountNumber,
        chainId: interxHeaders.chainId,
        sequence: queryAccountResp.sequence,
      );
      return txRemoteInfoModel;
    } catch (e) {
      getIt<Logger>().e('QueryAccountService: Cannot parse getTxRemoteInfo() for URI $networkUri $e');
      rethrow;
    }
  }

  Future<bool> isAccountRegistered(String accountAddress) async {
    Uri networkUri = getIt<NetworkModuleBloc>().state.networkUri;
    Response<dynamic> response = await _apiKiraRepository.fetchQueryAccount<dynamic>(
      ApiRequestModel<QueryAccountReq>(networkUri: networkUri, requestData: QueryAccountReq(address: accountAddress)),
    );
    return response.statusCode == 200;
  }
}
