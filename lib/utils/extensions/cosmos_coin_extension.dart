import 'package:cryptography_utils/cryptography_utils.dart';

extension CosmosCoinExtension on CosmosCoin {
  /// Sekai accepts only ukex
  CosmosCoin withRemoteDenomFormat() {
    if (denom.toLowerCase() == 'ukex') {
      return CosmosCoin(amount: amount, denom: denom.toLowerCase());
    }
    return this;
  }
}

extension CosmosCoinListExtension on List<CosmosCoin> {
  /// Sekai accepts only ukex
  List<CosmosCoin> withRemoteDenomFormat() {
    return map((e) => e.withRemoteDenomFormat()).toList();
  }
}
