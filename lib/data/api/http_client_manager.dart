import 'package:dio/browser.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:torii_client/data/api/http_client_interceptor.dart';
import 'package:torii_client/utils/browser/browser_url_controller.dart';
import 'package:torii_client/utils/network/app_config.dart';
import 'package:torii_client/utils/network/network_utils.dart';

@injectable
class HttpClientManager {
  final AppConfig _appConfig;

  HttpClientManager(this._appConfig);

  Future<Response<T>> get<T>({
    required Uri networkUri,
    required String path,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      Dio httpClientDio = _buildHttpClient(networkUri);
      return await httpClientDio.get<T>(
        path,
        queryParameters: _removeEmptyQueryParameters(queryParameters),
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException {
      rethrow;
    }
  }

  Future<Response<T>> post<T>({
    required Uri networkUri,
    required String path,
    required Map<String, dynamic> body,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      Dio httpClientDio = _buildHttpClient(networkUri);
      return await httpClientDio.post<T>(
        path,
        data: body,
        queryParameters: _removeEmptyQueryParameters(queryParameters),
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException {
      rethrow;
    }
  }

  Dio _buildHttpClient(Uri uri) {
    String uriAsString = uri.toString();
    bool proxyActiveBool = NetworkUtils.shouldUseProxy(
      serverUri: uri,
      proxyServerUri: _appConfig.proxyServerUri,
      appUri: const BrowserUrlController().uri,
    );
    Dio httpClientDio;
    if (proxyActiveBool) {
      uriAsString = '${_appConfig.proxyServerUri}/${uri.toString()}';
      httpClientDio = DioForBrowser(BaseOptions(baseUrl: uriAsString, headers: <String, dynamic>{'Origin': uri.host}));
    } else {
      httpClientDio = DioForBrowser(BaseOptions(baseUrl: uriAsString));
    }
    httpClientDio.interceptors.add(HttpClientInterceptor());
    return httpClientDio;
  }

  Map<String, dynamic>? _removeEmptyQueryParameters(Map<String, dynamic>? queryParameters) {
    if (queryParameters == null) {
      return null;
    }
    queryParameters.removeWhere((String key, dynamic value) => value == null);
    return queryParameters;
  }
}
