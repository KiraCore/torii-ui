import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

class ErrorExplorerModel extends Equatable {
  final Uri uri;
  final String method;
  final String code;
  final String? message;
  final dynamic request;
  final dynamic response;

  const ErrorExplorerModel({
    required this.uri,
    required this.method,
    required this.code,
    this.message,
    this.request,
    this.response,
  });

  factory ErrorExplorerModel.fromDioConnectException(DioException dioException) {
    RequestOptions requestOptions = dioException.requestOptions;

    return ErrorExplorerModel(
      code: 'NETWORK_ERROR',
      message: 'Cannot reach the server. Please check your internet connection.',
      uri: requestOptions.uri,
      method: requestOptions.method,
      request: requestOptions.data,
      response: dioException.response?.data ?? dioException.message,
    );
  }

  @override
  List<Object?> get props => <Object?>[uri, method, code, message, request, response];
}
