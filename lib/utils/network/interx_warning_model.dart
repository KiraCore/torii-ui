import 'package:equatable/equatable.dart';
import 'package:torii_client/domain/models/tokens/token_default_denom_model.dart';
import 'package:torii_client/utils/exports.dart';
import 'package:torii_client/utils/network/app_config.dart';
import 'package:torii_client/utils/network/block_time_model.dart';
import 'package:torii_client/utils/network/network_info_model.dart';

class InterxWarningModel extends Equatable {
  final List<InterxWarningType> interxWarningTypes;

  const InterxWarningModel(this.interxWarningTypes);

  factory InterxWarningModel.selectWarningType(
    NetworkInfoModel networkInfoModel,
    TokenDefaultDenomModel tokenDefaultDenomModel,
  ) {
    AppConfig appConfig = getIt<AppConfig>();
    bool missingTokenDefaultDenomModelBool = tokenDefaultDenomModel.valuesFromNetworkExistBool == false;
    bool versionOutdatedBool = appConfig.isInterxVersionOutdated(networkInfoModel.interxVersion);
    bool blockTimeOutdatedBool = BlockTimeModel(networkInfoModel.latestBlockTime).isOutdated();

    List<InterxWarningType> interxWarningTypes = <InterxWarningType>[
      if (missingTokenDefaultDenomModelBool) InterxWarningType.missingDefaultTokenDenomModel,
      if (versionOutdatedBool) InterxWarningType.versionOutdated,
      if (blockTimeOutdatedBool) InterxWarningType.blockTimeOutdated,
    ];

    return InterxWarningModel(interxWarningTypes);
  }

  bool get hasErrors => interxWarningTypes.isNotEmpty;

  @override
  List<Object?> get props => <Object>[interxWarningTypes];
}

enum InterxWarningType { blockTimeOutdated, versionOutdated, missingDefaultTokenDenomModel }
