import 'package:decimal/decimal.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:torii_client/domain/exports.dart';
import 'package:torii_client/domain/models/messages/interx_msg_types.dart';
import 'package:torii_client/domain/models/messages/tx_msg_type.dart';
import 'package:torii_client/domain/models/network/network_properties_model.dart';
import 'package:torii_client/domain/models/transaction/signed_transaction_model.dart';
import 'package:torii_client/domain/models/transaction/unsigned_tx_model.dart';
import 'package:torii_client/domain/services/miro/query_account_service.dart';
import 'package:torii_client/domain/services/miro/query_execution_fee_service.dart';
import 'package:torii_client/domain/services/miro/query_network_properties_service.dart';
import 'package:torii_client/presentation/global/session/cubit/session_cubit.dart';
import 'package:torii_client/presentation/transfer/tx_form_builder_cubit/tx_form_builder_cubit.dart';
import 'package:torii_client/presentation/transfer/tx_process_cubit/a_tx_process_state.dart';
import 'package:torii_client/presentation/transfer/tx_process_cubit/states/tx_process_broadcast_state.dart';
import 'package:torii_client/presentation/transfer/tx_process_cubit/states/tx_process_confirm_state.dart';
import 'package:torii_client/presentation/transfer/tx_process_cubit/states/tx_process_error_state.dart';
import 'package:torii_client/presentation/transfer/tx_process_cubit/states/tx_process_loaded_state.dart';
import 'package:torii_client/presentation/transfer/tx_process_cubit/states/tx_process_loading_state.dart';
import 'package:torii_client/utils/exports.dart';

class TxProcessCubit<T extends AMsgFormModel> extends Cubit<ATxProcessState> {
  final SessionCubit sessionCubit = getIt<SessionCubit>();
  final QueryAccountService _queryAccountService = getIt<QueryAccountService>();
  final QueryExecutionFeeService _queryExecutionFeeService = getIt<QueryExecutionFeeService>();
  final QueryNetworkPropertiesService _queryNetworkPropertiesService = getIt<QueryNetworkPropertiesService>();

  final TxMsgType txMsgType;
  final MsgSendFormModel msgFormModel;

  TxProcessCubit({required this.txMsgType, required this.msgFormModel}) : super(const TxProcessLoadingState());

  Future<void> init({required bool sendFromKira, bool formEnabledBool = true, bool resetModel = false}) async {
    // TODO: refactor, delete msgFormModel from here
    if (resetModel) {
      msgFormModel.tokenAmountModel = null;
      msgFormModel.recipientRelativeAmount = null;
      msgFormModel.recipientTokenDenomination = null;
      msgFormModel.memo = '';
    }

    emit(const TxProcessLoadingState());

    if (sessionCubit.state.isLoggedIn == false) {
      emit(const TxProcessErrorState());
      return;
    }


    String msgTypeName = InterxMsgTypes.getName(txMsgType);

    try {
      if (sendFromKira) {
        bool txRemoteInfoAvailableBool = await _queryAccountService.isAccountRegistered(
          sessionCubit.state.kiraWallet!.address.address,
        );
        if (txRemoteInfoAvailableBool == false) {
          emit(const TxProcessErrorState(accountErrorBool: true));
          return;
        }
        TokenAmountModel feeTokenAmountModel = await _queryExecutionFeeService.getExecutionFeeForMessage(msgTypeName);
        NetworkPropertiesModel networkPropertiesModel = await _queryNetworkPropertiesService.getNetworkProperties();
        TxProcessLoadedState txProcessLoadedState = TxProcessLoadedState(
          feeTokenAmountModel: feeTokenAmountModel,
          networkPropertiesModel: networkPropertiesModel,
        );
        if (formEnabledBool) {
          emit(txProcessLoadedState);
          return;
        }
      } else {
        emit(
          TxProcessLoadedState(
            feeTokenAmountModel: TokenAmountModel(
              defaultDenominationAmount: Decimal.zero,
              tokenAliasModel: TokenAliasModel.wkex(),
            ),
            networkPropertiesModel: NetworkPropertiesModel(
              minTxFee: TokenAmountModel(
                defaultDenominationAmount: Decimal.zero,
                tokenAliasModel: TokenAliasModel.wkex(),
              ),
              minIdentityApprovalTip: TokenAmountModel(
                defaultDenominationAmount: Decimal.zero,
                tokenAliasModel: TokenAliasModel.wkex(),
              ),
            ),
          ),
        );
      }
    } catch (e) {
      getIt<Logger>().e('Failed to load transaction fee: $e');
      if (isClosed == false) {
        emit(const TxProcessErrorState());
      }
    }
  }

  Future<void> signSubmitTransactionFromKira(
    TxFormBuilderCubit txFormBuilderCubit, {
    required String passphrase,
  }) async {
    try {
      if (state is TxProcessLoadedState) {
        SignedTxModel signedTxModel = await _buildSignedTransaction(txFormBuilderCubit, passphrase: passphrase);
        emit(
          TxProcessConfirmFromKiraState(
            txProcessLoadedState: state as TxProcessLoadedState,
            signedTxModel: signedTxModel,
          ),
        );
      }
    } catch (e) {
      getIt<Logger>().e('Failed to build signed transaction: $e');
      if (isClosed == false) {
        emit(const TxProcessErrorState());
      }
    }
  }

  void submitTransactionFromEth({required String passphrase}) {
    if (state is TxProcessLoadedState) {
      emit(
        TxProcessConfirmFromEthState(
          txProcessLoadedState: state as TxProcessLoadedState,
          kiraRecipient: msgFormModel.recipientWalletAddress!.address,
          ukexAmount: msgFormModel.tokenAmountModel!.getAmountInDefaultDenomination(),
          passphrase: passphrase,
        ),
      );
    }
  }

  Future<void> confirmTransaction() async {
    if (state is TxProcessConfirmFromKiraState) {
      await confirmTransactionFromKira();
    } else if (state is TxProcessConfirmFromEthState) {
      await confirmTransactionFromEth(passphrase: (state as TxProcessConfirmFromEthState).passphrase);
    }
  }

  Future<void> confirmTransactionFromKira() async {
    if (state is TxProcessConfirmFromKiraState) {
      emit(
        TxProcessBroadcastFromKiraState(
          txProcessLoadedState: (state as TxProcessConfirmFromKiraState).txProcessLoadedState,
          signedTxModel: (state as TxProcessConfirmFromKiraState).signedTxModel,
        ),
      );
    }
  }

  // TODO: remove pass param
  Future<void> confirmTransactionFromEth({required String passphrase}) async {
    if (state is TxProcessConfirmFromEthState) {
      emit(
        TxProcessBroadcastFromEthState(
          txProcessLoadedState: (state as TxProcessConfirmFromEthState).txProcessLoadedState,
          passphrase: passphrase,
          kiraRecipient: (state as TxProcessConfirmFromEthState).kiraRecipient,
          ukexAmount: (state as TxProcessConfirmFromEthState).ukexAmount,
        ),
      );
    }
  }

  Future<void> editTransactionForm() async {
    TxProcessLoadedState? txProcessLoadedState;
    if (state is TxProcessBroadcastState) {
      txProcessLoadedState = (state as TxProcessBroadcastState).txProcessLoadedState;
    } else if (state is TxProcessConfirmState) {
      txProcessLoadedState = (state as TxProcessConfirmState).txProcessLoadedState;
    } else if (state is TxProcessLoadedState) {
      txProcessLoadedState = state as TxProcessLoadedState;
    }
    if (txProcessLoadedState != null) {
      emit(txProcessLoadedState);
    }
  }

  // TODO: remove spaghetti of 2 cubits
  Future<SignedTxModel> _buildSignedTransaction(
    TxFormBuilderCubit txFormBuilderCubit, {
    required String passphrase,
  }) async {
    UnsignedTxModel unsignedTxModel = await txFormBuilderCubit.buildUnsignedTx(passphrase: passphrase);
    SignedTxModel signedTxModel = await _signTransaction(unsignedTxModel);
    return signedTxModel;
  }

  Future<SignedTxModel> _signTransaction(UnsignedTxModel unsignedTxModel) async {
    // TODO: dynamic wallet
    Wallet? wallet = sessionCubit.state.kiraWallet;
    if (wallet == null) {
      throw Exception('Wallet cannot be null when signing transaction');
    }
    return unsignedTxModel.sign(wallet);
  }
}
