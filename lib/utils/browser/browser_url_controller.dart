import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:torii_client/utils/browser/browser_controller.dart';

/// Generic class responsible for controlling browser url.
/// It is used to:
/// - get current url from browser
///
/// - extract query parameters from url
///   e.g. For url: https://miro.kira.network/#/app/dashboard?rpc=http://testnet-rpc.kira.network&page=1&account=kira143q8vxpvuykt9pq50e6hng9s38vmy844n8k9wx
///   [extractQueryParameters] will return:
///   {
///      "rpc": "http://testnet-rpc.kira.network",
///      "page": "1",
///      "account": "kira143q8vxpvuykt9pq50e6hng9s38vmy844n8k9wx",
///    }
///
/// - replace query parameters in url
///   e.g. For url: https://miro.kira.network/#/app/dashboard?rpc=http://192.168.8.100:11000
///   and query parameters map:
///   {
///     "rpc": "http://testnet-rpc.kira.network",
///     "page": "1",
///     "account": "kira143q8vxpvuykt9pq50e6hng9s38vmy844n8k9wx",
///   }
///   [replaceQueryParameters] will change url to:
///   https://miro.kira.network/#/app/dashboard?rpc=http://testnet-rpc.kira.network&page=1&account=kira143q8vxpvuykt9pq50e6hng9s38vmy844n8k9wx
@injectable
class BrowserUrlController {
  const BrowserUrlController();

  Uri get uri {
    return Uri.base;
  }

  @protected
  set uri(Uri uri) {
    BrowserController.replaceUrl(uri);
  }

  Map<String, dynamic> extractQueryParameters() {
    // [queryParameters] is an unmodifiable map, so we need to copy it to a new modifiable map
    return Map<String, dynamic>.from(uri.queryParameters);
  }

  void replaceQueryParameters(Map<String, dynamic> queryParameters) {
    Uri uriWithoutHash = Uri.parse(uri.toString());
    uriWithoutHash = uriWithoutHash.replace(queryParameters: queryParameters);

    uri = uriWithoutHash;
  }
}
