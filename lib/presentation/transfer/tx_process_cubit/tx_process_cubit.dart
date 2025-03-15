import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:torii_client/domain/exports.dart';
import 'package:torii_client/domain/models/messages/interx_msg_types.dart';
import 'package:torii_client/domain/models/messages/tx_msg_type.dart';
import 'package:torii_client/domain/models/network/network_properties_model.dart';
import 'package:torii_client/domain/models/tokens/a_msg_form_model.dart';
import 'package:torii_client/domain/models/tokens/token_amount_model.dart';
import 'package:torii_client/domain/models/transaction/signed_transaction_model.dart';
import 'package:torii_client/domain/models/transaction/unsigned_tx_model.dart';
import 'package:torii_client/domain/services/miro/query_account_service.dart';
import 'package:torii_client/domain/services/miro/query_execution_fee_service.dart';
import 'package:torii_client/domain/services/miro/query_network_properties_service.dart';
import 'package:torii_client/presentation/session/cubit/session_cubit.dart';
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
  final T msgFormModel;

  TxProcessCubit({required this.txMsgType, required this.msgFormModel}) : super(const TxProcessLoadingState());

  Future<void> init({bool formEnabledBool = true}) async {
    emit(const TxProcessLoadingState());

    if (sessionCubit.state.isLoggedIn == false) {
      emit(const TxProcessErrorState());
      return;
    }

    String msgTypeName = InterxMsgTypes.getName(txMsgType);

    try {
      if (sessionCubit.state.kiraWallet == null) {
        emit(const TxProcessErrorState(accountErrorBool: true));
        return;
      }
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

      SignedTxModel signedTxModel = await _buildSignedTransaction(feeTokenAmountModel);
      if (isClosed == false) {
        emit(TxProcessConfirmState(txProcessLoadedState: txProcessLoadedState, signedTxModel: signedTxModel));
      }
    } catch (e) {
      if (isClosed == false) {
        getIt<Logger>().e('Failed to load transaction fee: $e');
        emit(const TxProcessErrorState());
      }
    }
  }

  void submitTransactionForm(SignedTxModel signedTxModel) {
    if (state is TxProcessLoadedState) {
      emit(TxProcessConfirmState(txProcessLoadedState: state as TxProcessLoadedState, signedTxModel: signedTxModel));
    }
  }

  Future<void> confirmTransactionForm() async {
    if (state is TxProcessConfirmState == false) {
      return;
    }
    TxProcessConfirmState txProcessConfirmState = state as TxProcessConfirmState;
    emit(
      TxProcessBroadcastState(
        txProcessLoadedState: txProcessConfirmState.txProcessLoadedState,
        signedTxModel: txProcessConfirmState.signedTxModel,
      ),
    );
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

  Future<SignedTxModel> _buildSignedTransaction(TokenAmountModel feeTokenAmountModel) async {
    TxFormBuilderCubit txFormBuilderCubit = TxFormBuilderCubit(
      feeTokenAmountModel: feeTokenAmountModel,
      msgFormModel: msgFormModel,
    );

    UnsignedTxModel unsignedTxModel = await txFormBuilderCubit.buildUnsignedTx();
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
