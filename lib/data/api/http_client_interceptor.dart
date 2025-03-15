import 'package:dio/dio.dart';
import 'package:torii_client/utils/exports.dart';

class HttpClientInterceptor extends Interceptor {
  HttpClientInterceptor();

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    getIt<Logger>().i('onRequest: ${options.uri}');
    return handler.next(options);
  }

  @override
  Future<void> onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) async {
    getIt<Logger>().i('onResponse: ${response.data}');
    return handler.next(response);
  }

  /// This method is called when server responds with one of the following status codes (1XX), (3XX), (4XX) or (5XX)
  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    getIt<Logger>().e('onError: ${err.message}');
    return handler.next(err);
  }
}
