import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

class AppError extends Equatable implements Exception {
  final int? statusCode;
  final String? code;
  final String? title;
  final String? message;

  const AppError({this.statusCode, this.code, this.title, this.message});

  @override
  List<Object?> get props => [code, title, message, statusCode];

  factory AppError.from(Object error) {
    if (error is AppError) {
      return error;
    }

    if (error is DioException) {
      return _fromDioException(error);
    }

    return AppError(message: error.toString());
  }

  static AppError _fromDioException(DioException error) {
    String? code;
    String? title;
    String? message = error.message;

    switch (error.type) {
      case DioExceptionType.badResponse:
      // final data = error.response?.data;
      // if (data != null) {
      //   code = data['code'];
      //   title = data['title'];
      //   final dataMessage = data['message'];
      //   if (dataMessage != null) {
      //     message = dataMessage;
      //   }
      // }

      case DioExceptionType.unknown:
        if (message?.contains('SocketException') ?? false) {
          message = 'No Internet';
        }

      default:
        break;
    }

    final statusCode = error.response?.statusCode;

    return AppError(statusCode: statusCode, code: code, title: title, message: message);
  }
}
