import 'dart:typed_data';

import 'package:codec_utils/codec_utils.dart';
import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web3/flutter_web3.dart' hide Wallet;
import 'package:injectable/injectable.dart';
import 'package:torii_client/domain/exports.dart';
import 'package:torii_client/presentation/session/cubit/session_cubit.dart';
import 'package:torii_client/utils/exports.dart';

part 'metamask_state.dart';

const _useCacheKiraFromEth = false;

@singleton
class MetamaskCubit extends Cubit<MetamaskState> {
  // TODO(Mykyta): fix parameters once INTERX supports Eth chain for MetaMask
  static const int _kiraChainId = 1;
  static const String _kiraChainName = 'Kira Testnet';
  static const String _kiraRpcUrl = 'https://kira-rpc.kira.network';
  static const String _kiraNativeCurrencyName = 'Kira';
  static const String _kiraNativeCurrencySymbol = 'Kira';
  static const int _kiraNativeCurrencyDecimals = 18;

  final SessionCubit _sessionCubit;
  final EthereumService _ethereumService;
  final KeyValueRepository _keyValueRepository;

  MetamaskCubit(this._sessionCubit, this._ethereumService, this._keyValueRepository) : super(const MetamaskState());

  bool get isSupported => _ethereumService.isSupported;

  final Map<EthereumWalletAddress, CosmosWalletAddress> _cachedEthAddresses =
      <EthereumWalletAddress, CosmosWalletAddress>{};

  @PostConstruct(preResolve: true)
  Future<void> init() async {
    if (isSupported == false) {
      return;
    }

    _ethereumService
      ..removeAllListeners()
      ..handleConnect((ConnectInfo connectInfo) {
        getIt<Logger>().d('handleConnect: $connectInfo');

        _handleChainChanged(int.parse(connectInfo.chainId, radix: 16));
      })
      ..handleDisconnect((ProviderRpcError error) {
        getIt<Logger>().w('Metamask disconnect: $error');

        _signOut();
      })
      ..handleAccountsChanged(_handleAccountsChanged)
      ..handleChainChanged(_handleChainChanged);

    if (_keyValueRepository.wasIntroShown()) {
      await connect();
    }
  }

  Future<void> connect() async {
    if (isSupported == false) {
      return;
    }
    emit(state.copyWithBool(isLoadingBool: true));
    List<String>? accounts;
    int? chainId;
    try {
      accounts = await _ethereumService.requestAccount();
      chainId = await _ethereumService.getChainId();
    } catch (e) {
      getIt<Logger>().e('Error on metamask connect: $e');
    }

    if (accounts?.isEmpty != false || chainId == null) {
      return;
    }
    await _switchNetworkToKira();

    if (!_useCacheKiraFromEth || _keyValueRepository.readEthSignatureResult(accounts!.first) != null) {
      _signIn(address: accounts!.first, chainId: chainId);
    } else {
      emit(
        MetamaskState(
          address: accounts.first,
          chainId: chainId,
          needRequestForSignaturePermissionBool: true,
          isLoadingBool: true,
        ),
      );
    }
  }

  Future<void> resolveUserSignatureApproval({required bool isApproved}) async {
    if (state.hasData == false || state.needRequestForSignaturePermissionBool == false) {
      return;
    }
    if (isApproved) {
      emit(state.copyWithBool(isLoadingBool: true, needRequestForSignaturePermissionBool: false));
      _signIn(address: state.address!, chainId: state.chainId!);
      emit(state.copyWithBool(isLoadingBool: false));
    } else {
      emit(state.copyWithBool(isLoadingBool: false, needRequestForSignaturePermissionBool: false));
    }
  }

  Future<void> connectAfterUserSignatureApproval() async {
    if (state.hasData == false || state.needRequestForSignaturePermissionBool == false) {
      return;
    }
    emit(state.copyWithBool(isLoadingBool: true));
    _signIn(address: state.address!, chainId: state.chainId!);
    emit(state.copyWithBool(isLoadingBool: false));
  }

  void resetState() {
    _ethereumService.removeAllListeners();
    emit(const MetamaskState());
  }

  // // TODO(Mykyta): to be implemented in future task for MetaMask Pay feature with Cosmos signing
  // Future<void> pay({required AWalletAddress to, required int amount}) async {
  //   if (isSupported == false || state.hasData == false) {
  //     return;
  //   }
  //   await _switchNetworkToKira();
  //   String address;
  //   switch (to) {
  //     case EthereumWalletAddress _:
  //       address = to.address;
  //     case CosmosWalletAddress _:
  //       // address = to.toEthereumAddress();
  //       throw UnimplementedError();
  //     default:
  //       throw UnimplementedError();
  //   }
  //   try {
  //     // TODO(Mykyta): remove signer and direct usage of ethereum (`send-via-metamask` task)
  //     await Web3Provider.fromEthereum(
  //       ethereum!,
  //     ).getSigner().sendTransaction(TransactionRequest(from: state.address!, to: address, value: BigInt.from(amount)));
  //   } catch (e) {
  //     getIt<Logger>().e('Error on metamask pay: $e');
  //   }
  // }

  Future<void> _switchNetworkToKira() async {
    // TODO: switch network
    return;
    if (isSupported == false) {
      return;
    }
    try {
      await _ethereumService.switchWalletChain(_kiraChainId);
    } on EthereumException catch (e) {
      getIt<Logger>().e('Error on metamask switch network: $e');

      switch (e.code) {
        case 4902:
          // chain doesn't exist
          await _addKiraNetwork();
          break;
      }
    } catch (e) {
      getIt<Logger>().e('Error on metamask switch network: $e');
    }
  }

  Future<void> _addKiraNetwork() async {
    if (isSupported == false) {
      return;
    }
    try {
      await _ethereumService.addWalletChain(
        chainId: _kiraChainId,
        chainName: _kiraChainName,
        nativeCurrencyName: _kiraNativeCurrencyName,
        nativeCurrencySymbol: _kiraNativeCurrencySymbol,
        nativeCurrencyDecimals: _kiraNativeCurrencyDecimals,
        rpcUrl: _kiraRpcUrl,
      );
    } catch (e) {
      getIt<Logger>().e('Error on metamask add network: $e');
    }
  }

  Future<void> _handleAccountsChanged(List<String> accounts) async {
    getIt<Logger>().d('handleAccountsChanged: $accounts');
    if (accounts.isEmpty) {
      _signOut();
      return;
    }
    if (state.chainId != null) {
      emit(state.copyWithBool(isLoadingBool: true));
      _signIn(address: accounts.first, chainId: state.chainId!);
      emit(state.copyWithBool(isLoadingBool: false));
    }
  }

  void _handleChainChanged(int chainId) {
    getIt<Logger>().d('handleChainChanged: $chainId');
    emit(MetamaskState(chainId: chainId));
  }

  void _signIn({required String address, required int chainId}) {
    try {
      Wallet wallet = Wallet(address: EthereumWalletAddress.fromString(address));
      _sessionCubit.signIn(wallet);

      if (_useCacheKiraFromEth) {
        _cachedEthAddresses[EthereumWalletAddress.fromString(address)] = CosmosWalletAddress.fromBech32(address);
      }

      emit(MetamaskState(address: address, chainId: chainId));
    } catch (e) {
      _signOut();
      getIt<Logger>().e('Error on metamask signIn: $e');
    }
  }

  void _signOut() {
    try {
      resetState();
      _sessionCubit.signOutEthereum();
    } catch (e) {
      getIt<Logger>().e('Error on _signOut: $e');
    }
  }

  Future<CosmosWalletAddress?> _cacheCosmosAddressFromEthereum(
    EthereumWalletAddress ethereumAddress, {
    required String bech32Hrp,
    ECPrivateKey? ecPrivateKey,
  }) async {
    String? kiraAddress = _keyValueRepository.readEthSignatureResult(ethereumAddress.address)?.cosmosAddress;

    if (kiraAddress != null) {
      CosmosWalletAddress cosmosWalletAddress = CosmosWalletAddress.fromBech32(kiraAddress);
      _cachedEthAddresses[ethereumAddress] = cosmosWalletAddress;
      return cosmosWalletAddress;
    }

    // NOTE: must not be empty
    String dumbMessage = 'Signature for accessing the public key';
    try {
      String? compressedHexPublicKey;
      CosmosWalletAddress? cosmosAddress;
      if (ecPrivateKey != null) {
        // Get the public key from private key
        Uint8List ethPublicKey = ecPrivateKey.ecPublicKey.compressed;
        compressedHexPublicKey = HexCodec.encode(ethPublicKey);
        cosmosAddress = CosmosWalletAddress.fromEthereum(ethPublicKey);
      } else {
        // WARNING: Signature and decoding of that are heavy operations together and will freeze the UI if user didn't declined it
        // TODO(Mykyta): Move Signature and Decoding to web workers

        // Get the public key from Metamask's signature
        String? signature = await _ethereumService.signMessage(ethereumAddress.address, dumbMessage);
        if (signature == null) {
          throw Exception('Invalid signature for address ${ethereumAddress.address}');
        }
        EthereumSignatureDecodeResult? result = await _ethereumService.decodeEthereumSignature(
          message: dumbMessage,
          signatureHex: signature,
          ethereumAddress: ethereumAddress.address,
          bech32Hrp: bech32Hrp,
        );
        if (result == null) {
          throw Exception('Error decoding signature for address ${ethereumAddress.address}');
        }
        compressedHexPublicKey = result.compressedPublicKey;
        cosmosAddress = CosmosWalletAddress.fromBech32(result.cosmosAddress);
      }

      CosmosWalletAddress bech32Address = _cachedEthAddresses[ethereumAddress] = cosmosAddress;

      _keyValueRepository.writeEthSignatureResult(
        EthereumSignatureDecodeResult(
          compressedPublicKey: compressedHexPublicKey,
          ethAddress: ethereumAddress.address,
          cosmosAddress: bech32Address.address,
        ),
      );

      getIt<Logger>().d('Converted Cosmos Address: ${bech32Address.address}');
      return bech32Address;
    } catch (e) {
      getIt<Logger>().e('_cacheCosmosAddressFromEthereum - $e');
    }
    return null;
  }

  @override
  Future<void> close() {
    _ethereumService.removeAllListeners();
    return super.close();
  }
}
