import 'package:careerwill/utitlity/constants.dart';
import 'package:dio/dio.dart';

class DioService {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: MAIN_URL,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      validateStatus: (status) {
        return status != null && status < 500; // Handle 4xx errors gracefully
      },
    ),
  );

  DioService() {
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );
  }


  Future<Response> getItems({
    required String endpointUrl,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.get(
        endpointUrl,
        queryParameters: queryParameters,
      );
      return response;
    } on DioException catch (e) {
      throw Exception(_getDioErrorMessage(e));
    }
  }


  Future<Response> postItems({
    required String endpointUrl,
    required dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.post(
        endpointUrl,
        data: data,
        queryParameters: queryParameters,
      );
      return response;
    } on DioException catch (e) {
      throw Exception(_getDioErrorMessage(e));
    }
  }


  /// Private method to extract error messages
  String _getDioErrorMessage(DioException e) {
    if (e.response != null) {
      return "Error: ${e.response!.statusCode} - ${e.response!.statusMessage}";
    } else if (e.type == DioExceptionType.connectionTimeout) {
      return "Connection timeout. Please check your internet.";
    } else if (e.type == DioExceptionType.receiveTimeout) {
      return "Receive timeout. Server is taking too long.";
    } else if (e.type == DioExceptionType.badResponse) {
      return "Bad response from server.";
    } else if (e.type == DioExceptionType.cancel) {
      return "Request was cancelled.";
    } else {
      return "Unexpected error: ${e.message}";
    }
  }
}
