import 'package:decimal/decimal.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:torii_client/data/api/interx_headers.dart';
import 'package:torii_client/data/dto/api/query_transactions/request/query_transactions_req.dart';
import 'package:torii_client/data/dto/api/query_transactions/response/query_log_txs_resp.dart';
import 'package:torii_client/data/dto/api/query_transactions/response/query_transactions_resp.dart';
import 'package:torii_client/data/dto/api_kira/query_account/request/query_account_req.dart';
import 'package:torii_client/data/dto/api_kira/query_account/response/query_account_resp.dart';
import 'package:torii_client/data/dto/api_request_model.dart';
import 'package:torii_client/domain/models/messages/a_tx_msg_model.dart';
import 'package:torii_client/domain/models/messages/msg_send_model.dart';
import 'package:torii_client/domain/models/page_data.dart';
import 'package:torii_client/domain/models/tokens/list/logs_txs.dart';
import 'package:torii_client/domain/models/tokens/list/tx_direction_type.dart';
import 'package:torii_client/domain/models/tokens/list/tx_list_item_model.dart';
import 'package:torii_client/domain/models/tokens/list/tx_sort_type.dart';
import 'package:torii_client/domain/models/tokens/list/tx_status_type.dart';
import 'package:torii_client/domain/models/tokens/prefixed_token_amount_model.dart';
import 'package:torii_client/domain/models/tokens/token_alias_model.dart';
import 'package:torii_client/domain/models/tokens/token_amount_model.dart';
import 'package:torii_client/domain/models/tokens/token_amount_status_type.dart';
import 'package:torii_client/domain/models/transaction/tx_remote_info_model.dart';
import 'package:torii_client/domain/models/wallet/address/a_wallet_address.dart';
import 'package:torii_client/domain/models/wallet/exports.dart';
import 'package:torii_client/domain/repositories/api_kira_repository.dart';
import 'package:torii_client/domain/repositories/api_torii_repository.dart';
import 'package:torii_client/presentation/network/bloc/network_module_bloc.dart';
import 'package:torii_client/utils/exports.dart';

@injectable
class ToriiLogsService {
  final ApiToriiRepository _repository;
  final NetworkModuleBloc _networkModuleBloc;

  ToriiLogsService(this._repository, this._networkModuleBloc);

  Future<LogTxs> fetchTransactionsPerAccount(AWalletAddress accountAddress) async {
    if (!(const bool.hasEnvironment('TORII_LOG_URL'))) {
      throw Exception('Torii log url is not set');
    }
    final uri = Uri.parse(const String.fromEnvironment('TORII_LOG_URL'));

    final queryTransactionsReq = QueryTransactionsReq(
      address: accountAddress.address,
      // TODO: it's not working
      limit: 2,
      offset: 0,
      sort: TxSortType.dateDESC,
      // pageSize: 20,
    );
    try {
      // TODO: test transactions
      await Future.delayed(const Duration(seconds: 1));
      // return _testData;

      final response = await _repository.fetchTransactionsPerAccount<dynamic>(
        ApiRequestModel<QueryTransactionsReq>(
          networkUri: uri,
          requestData: queryTransactionsReq,
          forceRequestBool: true,
        ),
      );

      QueryLogTxsResp queryLogTxsResp = QueryLogTxsResp.fromJson(
        response.data as Map<String, dynamic>,
        askingForKira: accountAddress is CosmosWalletAddress,
      );
      List<TxListItemModel> kiraTransactions = [];
      for (final tx in queryLogTxsResp.fromKira) {
        try {
          final transaction = TxListItemModel.fromDto(tx);
          kiraTransactions.add(transaction);
        } catch (e) {
          getIt<Logger>().w('ToriiLogsService: Skip invalid Kira transaction $tx: $e');
        }
      }
      List<TxListItemModel> ethTransactions = [];
      for (final tx in queryLogTxsResp.fromEth) {
        try {
          final transaction = TxListItemModel.fromDto(tx);
          ethTransactions.add(transaction);
        } catch (e) {
          getIt<Logger>().w('ToriiLogsService: Skip invalid Eth transaction $tx: $e');
        }
      }
      // TODO: interx headers
      // InterxHeaders interxHeaders = InterxHeaders.fromHeaders(response.headers);

      return LogTxs(
        fromKira: PageData<TxListItemModel>(
          listItems: kiraTransactions,
          // TODO: check limit
          isLastPage: true, //fromKira.length < queryTransactionsReq.limit!,
          blockDateTime: DateTime.now(), //interxHeaders.blockDateTime,
          cacheExpirationDateTime: DateTime.now(), //interxHeaders.cacheExpirationDateTime,
        ),
        fromEth: PageData<TxListItemModel>(
          listItems: ethTransactions,
          // TODO: check limit
          isLastPage: true, //fromEth.length < queryTransactionsReq.limit!,
          blockDateTime: DateTime.now(), //interxHeaders.blockDateTime,
          cacheExpirationDateTime: DateTime.now(), //interxHeaders.cacheExpirationDateTime,
        ),
      );
    } catch (e) {
      getIt<Logger>().e('ToriiLogsService: Cannot parse fetchTransactionsPerAccount() for URI $e');
      rethrow;
    }
  }
}

PageData<TxListItemModel> _testData = PageData<TxListItemModel>(
  blockDateTime: DateTime.parse('2022-08-26 22:08:27.607Z'),
  cacheExpirationDateTime: DateTime.parse('2022-08-26 22:08:27.607Z'),
  listItems: <TxListItemModel>[
    // MsgSend inbound
    TxListItemModel(
      hash: '0x3BD165E428985C8FE60A93A9AF0B502F6735F54892FE27425465FAAA04B42BDA',
      time: DateTime.parse('2025-01-30 15:48:28.000Z'),
      txDirectionType: TxDirectionType.outbound,
      txStatusType: TxStatusType.confirmed,
      fees: <TokenAmountModel>[
        TokenAmountModel(
          defaultDenominationAmount: Decimal.fromInt(100),
          tokenAliasModel: TokenAliasModel.local('ukex'),
        ),
      ],
      prefixedTokenAmounts: <PrefixedTokenAmountModel>[
        PrefixedTokenAmountModel(
          tokenAmountPrefixType: TokenAmountPrefixType.subtract,
          tokenAmountModel: TokenAmountModel(
            defaultDenominationAmount: Decimal.fromInt(100),
            tokenAliasModel: TokenAliasModel.local('KEX'),
          ),
        ),
      ],
      txMsgModels: <MsgSendModel>[
        MsgSendModel(
          fromWalletAddress: AWalletAddress.fromAddress('kira143q8vxpvuykt9pq50e6hng9s38vmy844n8k9wx'),
          toWalletAddress: AWalletAddress.fromAddress('0xb83DF76e62980BDb0E324FC9Ce3e7bAF6309E7b5'),
          tokenAmountModel: TokenAmountModel(
            defaultDenominationAmount: Decimal.fromInt(100),
            tokenAliasModel: TokenAliasModel.local('KEX'),
          ),
          passphrase: '123',
        ),
      ],
      memo: 'Memo test',
    ),
    // MsgSend outbound
    TxListItemModel(
      hash: '0x5372F94173105AE3DE4A19CA30A02F1590437F823D45E43EAFC589199C2BC2A2',
      time: DateTime.parse('2024-12-27 12:11:46.000Z'),
      txDirectionType: TxDirectionType.inbound,
      txStatusType: TxStatusType.confirmed,
      fees: <TokenAmountModel>[
        TokenAmountModel(
          defaultDenominationAmount: Decimal.fromInt(500),
          tokenAliasModel: TokenAliasModel.local('ukex'),
        ),
      ],
      prefixedTokenAmounts: <PrefixedTokenAmountModel>[
        PrefixedTokenAmountModel(
          tokenAmountPrefixType: TokenAmountPrefixType.add,
          tokenAmountModel: TokenAmountModel.zero(tokenAliasModel: TokenAliasModel.local('WKEX')),
        ),
      ],
      txMsgModels: <MsgSendModel>[
        MsgSendModel(
          fromWalletAddress: AWalletAddress.fromAddress('0xb83DF76e62980BDb0E324FC9Ce3e7bAF6309E7b5'),
          toWalletAddress: AWalletAddress.fromAddress('kira143q8vxpvuykt9pq50e6hng9s38vmy844n8k9wx'),
          tokenAmountModel: TokenAmountModel(
            defaultDenominationAmount: Decimal.fromInt(200),
            tokenAliasModel: TokenAliasModel.local('WKEX'),
          ),
          passphrase: '123',
        ),
      ],
      memo: 'Memo test',
    ),
  ],
);
