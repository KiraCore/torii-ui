import 'dart:convert';
import 'dart:math' show pow;
import 'dart:typed_data';

import 'package:codec_utils/codec_utils.dart';
import 'package:crypto/crypto.dart';
import 'package:decimal/decimal.dart';
import 'package:eth_sig_util/eth_sig_util.dart';
import 'package:eth_sig_util/model/ecdsa_signature.dart';
import 'package:flutter_web3/flutter_web3.dart';
import 'package:injectable/injectable.dart';
import 'package:pointycastle/digests/ripemd160.dart';
import 'package:secp256k1/secp256k1.dart';
import 'package:torii_client/domain/exports.dart';
import 'package:torii_client/utils/exports.dart';
// import 'package:webthree/browser.dart' as three;
// import 'dart:convert';
// import 'dart:html' as html;
// import 'dart:typed_data';
//
// import 'package:webthree/webthree.dart';
// import 'package:flutter_web3/flutter_web3.dart';

class EthereumSignatureDecodeResult {
  final String compressedPublicKey;
  final String ethAddress;
  final String cosmosAddress;

  const EthereumSignatureDecodeResult({
    required this.compressedPublicKey,
    required this.ethAddress,
    required this.cosmosAddress,
  });

  factory EthereumSignatureDecodeResult.fromDataJson(Map<String, Object?> dataJson, {required String ethAddress}) =>
      EthereumSignatureDecodeResult(
        compressedPublicKey: dataJson['compressed_hex_public_key'] as String,
        cosmosAddress: dataJson['kira_address'] as String,
        ethAddress: ethAddress,
      );

  Map<String, Object?> toDataJson() => <String, Object?>{
    'compressed_hex_public_key': compressedPublicKey,
    'kira_address': cosmosAddress,
  };
}

@injectable
class EthereumService {
  EthereumService();
  //
  // three.Ethereum? get threeEthereum => html.window.ethereum;
  //
  // Future<void> metamaskThree() async {
  //   if (threeEthereum == null) {
  //     return;
  //   }
  //
  //   final EthereumAddress ownAddress =
  //   EthereumAddress.fromHex('0xCa27b75E10154814663b7Eb254317FA16c5F940A');
  //   final EthereumAddress contractAddr =
  //   EthereumAddress.fromHex('0xeE9312C22890e0Bd9a9bB37Fd17572180F4Fc68a');
  //   final EthereumAddress receiver =
  //   EthereumAddress.fromHex('0x6c87E1a114C3379BEc929f6356c5263d62542C13');
  //
  //   final client = Web3Client.custom(threeEthereum!.asRpcService());
  //   final credentials = await threeEthereum!.requestAccounts();
  //
  //   print('Using ${credentials[0].address}');
  //   print('Client is listening: ${await client.isListeningForNetwork()}');
  //
  //   final message = Uint8List.fromList(utf8.encode('Hello from webthree'));
  //   final signature = await credentials[0].signPersonalMessage(message);
  //   print('Signature: ${base64.encode(signature)}');
  //
  //   // read the contract abi and tell webthree where it's deployed (contractAddr)
  //   final token = Token(address: contractAddr, client: client);
  //
  //   // listen for the Transfer event when it's emitted by the contract above
  //   final subscription = token.transferEvents().take(1).listen((event) {
  //     print('${event.from} sent ${event.value} MetaCoins to ${event.to}!');
  //   });
  //
  //   // check our balance in MetaCoins by calling the appropriate function
  //   final balance = await token.getBalance(ownAddress);
  //   print('We have $balance MetaCoins');
  //
  //   // send all our MetaCoins to the other address by calling the sendCoin
  //   // function
  //   await token.sendCoin(receiver, balance, credentials: credentials);
  //
  //   await subscription.asFuture();
  //   await subscription.cancel();
  //
  //   await client.dispose();
  // }

  bool get isSupported => ethereum != null;

  Contract? _contract;

  Contract get contract =>
      _contract ??= Contract(
        '0x719CAe5e3d135364e5Ef5AAd386985D86A0E7813',
        jsonEncode([
          {
            "inputs": [
              {"internalType": "address", "name": "oracleAddress", "type": "address"},
              {"internalType": "address", "name": "tokenAddress", "type": "address"},
            ],
            "stateMutability": "nonpayable",
            "type": "constructor",
          },
          {
            "anonymous": false,
            "inputs": [
              {"indexed": true, "internalType": "string", "name": "cyclAddres", "type": "string"},
              {"indexed": false, "internalType": "uint256", "name": "amount", "type": "uint256"},
            ],
            "name": "TokensExported",
            "type": "event",
          },
          {
            "anonymous": false,
            "inputs": [
              {"indexed": true, "internalType": "address", "name": "ethAddress", "type": "address"},
              {"indexed": false, "internalType": "uint256", "name": "amount", "type": "uint256"},
            ],
            "name": "TokensImported",
            "type": "event",
          },
          {
            "inputs": [
              {"internalType": "string", "name": "passphrase", "type": "string"},
              {"internalType": "address", "name": "sender", "type": "address"},
            ],
            "name": "computeHash",
            "outputs": [
              {"internalType": "string", "name": "", "type": "string"},
            ],
            "stateMutability": "pure",
            "type": "function",
          },
          {
            "inputs": [
              {"internalType": "string", "name": "cyclAddress", "type": "string"},
              {"internalType": "string", "name": "hash", "type": "string"},
              {"internalType": "uint256", "name": "amount", "type": "uint256"},
            ],
            "name": "exportTokens",
            "outputs": [],
            "stateMutability": "nonpayable",
            "type": "function",
          },
          {
            "inputs": [
              {"internalType": "string", "name": "passphrase", "type": "string"},
            ],
            "name": "importTokens",
            "outputs": [],
            "stateMutability": "nonpayable",
            "type": "function",
          },
          {
            "inputs": [],
            "name": "oracle",
            "outputs": [
              {"internalType": "contract Oracle", "name": "", "type": "address"},
            ],
            "stateMutability": "view",
            "type": "function",
          },
          {
            "inputs": [],
            "name": "token",
            "outputs": [
              {"internalType": "contract Token", "name": "", "type": "address"},
            ],
            "stateMutability": "view",
            "type": "function",
          },
        ]),
        provider!.getSigner(),
      );

  void removeAllListeners() => ethereum?.removeAllListeners();

  void handleConnect(void Function(ConnectInfo) listener) => ethereum?.onConnect(listener);
  void handleDisconnect(void Function(ProviderRpcError) listener) => ethereum?.onDisconnect(listener);

  void handleAccountsChanged(void Function(List<String>) listener) => ethereum?.onAccountsChanged(listener);
  void handleChainChanged(void Function(int) listener) => ethereum?.onChainChanged(listener);

  Future<List<String>?> requestAccount() async => ethereum?.requestAccount();

  Future<TransactionResponse?> exportContractTokens({
    required String passphrase,
    required String kiraAddress,
    required Decimal ukexAmount,
  }) async {
    if (!isSupported) {
      getIt<Logger>().e('MetaMask is not connected');
      return null;
    }

    try {
      final tx = await contract.send('exportTokens', [
        kiraAddress, //'kira143q8vxpvuykt9pq50e6hng9s38vmy844n8k9wx', //(await requestAccount())!.first,
        Sha256.encrypt(passphrase), //'8a8620565a42cfb1acf8d6b9b84d6179fa18050c6fcb305af7dad777804fa047',
        ukexAmount.toBigInt(), // Amount in Wei
      ]);
      getIt<Logger>().d('Transaction hash: ${tx.hash}');
      return tx;
    } catch (e) {
      getIt<Logger>().e('Error sending transaction: $e');
      rethrow;
    }
  }

  Future<TransactionResponse?> importContractTokens({required String passphrase}) async {
    if (!isSupported) {
      getIt<Logger>().e('MetaMask is not connected');
      return null;
    }

    try {
      final tx = await contract.send('importTokens', [
        passphrase, //'kirakira11111',
      ]);
      getIt<Logger>().d('Transaction hash: ${tx.hash}');
      return tx;
    } catch (e) {
      getIt<Logger>().e('Error sending transaction: $e');
      return null;
    }
  }

  Future<int?> getChainId() async => ethereum?.getChainId();

  Future<Decimal?> getBalance(String address) async {
    try {
      // First, get the token contract address
      final tokenAddress = await contract.call<String>('token', []);

      // Create a new contract for the token
      final tokenContract = Contract(
        tokenAddress,
        // Standard ERC20 ABI for balanceOf function
        jsonEncode([
          {
            "constant": true,
            "inputs": [
              {"name": "_owner", "type": "address"},
            ],
            "name": "balanceOf",
            "outputs": [
              {"name": "balance", "type": "uint256"},
            ],
            "type": "function",
          },
        ]),
        provider!,
      );

      // Now call balanceOf on the token contract
      final balance = await tokenContract.call<dynamic>('balanceOf', [address]);
      getIt<Logger>().d('Balance: $balance');
      return balance == null ? null : Decimal.fromBigInt(BigInt.parse(balance.toString()));
    } catch (e) {
      getIt<Logger>().e('Error getting balance: $e');
      return null;
    }
  }

  Future<String?> getPublicKey(String address) async =>
      ethereum?.request('eth_getEncryptionPublicKey', <String>[address]);

  Future<String?> signMessage(String address, String message) async {
    final String hexMessage = HexCodec.encode(utf8.encode(message));
    return ethereum?.request('personal_sign', <String>[hexMessage, address]);
  }

  Future<EthereumSignatureDecodeResult?> decodeEthereumSignature({
    required String message,
    required String signatureHex,
    required String ethereumAddress,
    required String bech32Hrp,
  }) async {
    try {
      Uint8List? uncompressedPublicKey = _recoverPublicKey(message, signatureHex);

      String ethAddress = EthereumWalletAddress.fromUncompressedPublicKey(uncompressedPublicKey).address;
      if (ethAddress.toLowerCase() != ethereumAddress.toLowerCase()) {
        throw Exception('Ethereum address from the signature $ethAddress does not match the address $ethereumAddress');
      }

      Uint8List? compressedPublicKey = compressPublicKey(uncompressedPublicKey);
      String cosmosAddress = convertPublicKeyToCosmosAddress(compressedPublicKey, bech32Hrp);

      String publicKeyString = HexCodec.encode(compressedPublicKey);

      getIt<Logger>().d('Decoded public key: $publicKeyString');
      getIt<Logger>().d('Decoded Ethereum address: $ethAddress');
      getIt<Logger>().d('Decoded Cosmos address: $cosmosAddress');

      return EthereumSignatureDecodeResult(
        compressedPublicKey: publicKeyString,
        ethAddress: ethAddress,
        cosmosAddress: cosmosAddress,
      );
    } catch (error) {
      getIt<Logger>().e('Error decoding message: $error');
      return null;
    }
  }

  Uint8List compressPublicKey(Uint8List uncompressedPublicKey) {
    PublicKey publicKey = PublicKey.fromHex('04${HexCodec.encode(uncompressedPublicKey)}');

    String compressedPublicKey = publicKey.toCompressedHex();
    return HexCodec.decode(compressedPublicKey);
  }

  String convertPublicKeyToCosmosAddress(Uint8List publicKey, String humanReadablePart) {
    // Hash the public key with SHA-256
    Digest sha256Hash = sha256.convert(publicKey);

    // Hash the SHA-256 output with RIPEMD-160
    Uint8List ripemd160Hash = RIPEMD160Digest().process(Uint8List.fromList(sha256Hash.bytes));

    return Bech32.encode(humanReadablePart, ripemd160Hash);
  }

  Future<void> watchWkexAsset() async => ethereum?.walletWatchAssets(
    address: contract.address,
    symbol: 'wKEX',
    decimals: 9,
    // image: 'https://kira.network/images/kira-logo.png',
  );

  Future<void> switchWalletChain(int chainId) async => ethereum?.walletSwitchChain(chainId);
  Future<void> addWalletChain({
    required int chainId,
    required String rpcUrl,
    required String chainName,
    required String nativeCurrencyName,
    required String nativeCurrencySymbol,
    required int nativeCurrencyDecimals,
  }) async => ethereum?.walletAddChain(
    chainId: chainId,
    rpcUrls: <String>[rpcUrl],
    chainName: chainName,
    nativeCurrency: CurrencyParams(
      name: nativeCurrencyName,
      symbol: nativeCurrencySymbol,
      decimals: nativeCurrencyDecimals,
    ),
  );

  Uint8List _recoverPublicKey(String message, String signatureHex) {
    // Decode the signature
    Uint8List signature = HexCodec.decode(signatureHex);

    // Extract r, s, and v from the signature
    BigInt r = _bytesToBigInt(signature.sublist(0, 32));
    BigInt s = _bytesToBigInt(signature.sublist(32, 64));
    int v = signature[64];
    // NOTE: No need to adjust v value (-27), it will be done in ECDSASignature object
    // if (v >= 27) {
    //   v -= 27;
    // }

    ECDSASignature ecSignature = ECDSASignature(r, s, v);

    // Hash the message
    Uint8List messageBytes = utf8.encode(message);
    String prefix = '\x19Ethereum Signed Message:\n${messageBytes.length}';
    Uint8List prefixBytes = utf8.encode(prefix);
    Uint8List prefixedMessage = Uint8List.fromList(prefixBytes + messageBytes);
    Uint8List messageHash = Keccak256.encode(prefixedMessage);

    // Recover the public key
    Uint8List? uncompressedPublicKey = SignatureUtil.recoverPublicKeyFromSignature(ecSignature, messageHash);

    if (uncompressedPublicKey == null) {
      throw Exception('Failed to recover public key from signature.');
    }
    return uncompressedPublicKey;
  }

  BigInt _bytesToBigInt(Uint8List bytes) {
    return BigInt.parse(HexCodec.encode(bytes), radix: 16);
  }
}
