import 'package:decimal/decimal.dart';
import 'package:equatable/equatable.dart';
import 'package:torii_client/data/dto/api_kira/query_network_properties/response/properties.dart';
import 'package:torii_client/domain/exports.dart';
import 'package:torii_client/presentation/network/bloc/network_module_bloc.dart';
import 'package:torii_client/utils/exports.dart';

class NetworkPropertiesModel extends Equatable {
  final TokenAmountModel minTxFee;
  final TokenAmountModel minIdentityApprovalTip;

  const NetworkPropertiesModel({required this.minTxFee, required this.minIdentityApprovalTip});

  factory NetworkPropertiesModel.fromDto(Properties properties) {
    final TokenAliasModel defaultTokenAliasModel =
        getIt<NetworkModuleBloc>().tokenDefaultDenomModel.defaultTokenAliasModel!;

    return NetworkPropertiesModel(
      minTxFee: TokenAmountModel(
        defaultDenominationAmount: Decimal.parse(properties.minTxFee),
        tokenAliasModel: defaultTokenAliasModel,
      ),
      minIdentityApprovalTip: TokenAmountModel(
        defaultDenominationAmount: Decimal.parse(properties.minIdentityApprovalTip),
        tokenAliasModel: defaultTokenAliasModel,
      ),
    );
  }

  @override
  List<Object?> get props => <Object>[minTxFee, minIdentityApprovalTip];
}
