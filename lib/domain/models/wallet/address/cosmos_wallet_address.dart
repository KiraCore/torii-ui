import 'dart:typed_data';

import 'package:torii_client/domain/exports.dart';
import 'package:torii_client/utils/exports.dart';

class CosmosWalletAddress extends AWalletAddress {
  /// The length of a wallet address, excluding the human readable part.
  static const int addressLengthWithoutHrp = 39;
  static const String defaultBech32Hrp = 'kira';

  final String _bech32Hrp;

  /// Stores raw address bytes and allows to create bech32Address based on hrp (human readable part).
  const CosmosWalletAddress({required super.addressBytes, String? bech32Hrp})
    : _bech32Hrp = bech32Hrp ?? defaultBech32Hrp;

  /// Constructs a wallet address from a public key. The address is formed by
  /// the last 20 bytes of the keccak hash of the public key.
  factory CosmosWalletAddress.fromPublicKey(Uint8List publicKey, {String bech32Hrp = defaultBech32Hrp}) {
    return CosmosWalletAddress(addressBytes: Secp256k1.publicKeyToAddress(publicKey), bech32Hrp: bech32Hrp);
  }

  // Hrp data extracted from QueryTokenAliases
  factory CosmosWalletAddress.fromBech32(String bech32Address) {
    final Bech32Pair bech32pair = Bech32.decode(bech32Address);
    return CosmosWalletAddress(addressBytes: bech32pair.data, bech32Hrp: bech32pair.hrp);
  }

  // Hrp data extracted from QueryValidators
  factory CosmosWalletAddress.fromBech32Validators(String bech32Address) {
    final Bech32Pair bech32pair = Bech32.decode(bech32Address);
    return CosmosWalletAddress(addressBytes: bech32pair.data, bech32Hrp: bech32pair.hrp);
  }

  factory CosmosWalletAddress.fromEthereum(Uint8List ethPublicKey, {String bech32Hrp = defaultBech32Hrp}) {
    String bech32Address = getIt<EthereumService>().convertPublicKeyToCosmosAddress(ethPublicKey, bech32Hrp);

    return CosmosWalletAddress.fromBech32(bech32Address);
  }

  /// Returns the associated [address] as a Bech32 string.
  @override
  String get address {
    return Bech32.encode(_bech32Hrp, addressBytes);
  }

  @override
  WalletAddressType get type => WalletAddressType.cosmos;

  @override
  List<Object?> get props => <Object?>[_bech32Hrp, ...super.props];
}
