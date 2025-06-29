import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:test_task_mobile/common/services/data/request_method_enum.dart';
import 'package:test_task_mobile/common/services/data/request_service_exception.model.dart';
import 'package:test_task_mobile/common/services/data/response_data.model.dart';

class RequestService {
  RequestService();

  // Dio singleton.
  final Dio _dio = Dio();

  String _url = "http://google.com";
  String get url => _url;

  /// Sets requests URL.
  void setUrl(String url) {
    _url = url;
  }

  Object? _data;
  Object? get data => _data;

  bool _shouldValidate = false;
  bool get shouldValidate => _shouldValidate;

  bool _useHttps = false;
  bool get useHttps => _useHttps;

  RequestMethod _method = RequestMethod.get;
  RequestMethod get method => _method;

  /// Sets request method.
  void setMethod(RequestMethod method) {
    _method = method;
  }

  void setData(Object? data) {
    _data = data;
  }

  /// Replaces old headers with the new ones.
  void setHeaders(Map<String, dynamic> headers) {
    _dio.options.headers = headers;
  }

  /// Adds new headers to old ones.
  void addHeaders(Map<String, dynamic> headers) {
    _dio.options.headers.addAll(headers);
  }

  /// Toggles whether to validate certificate.
  void toggleValidation() {
    _shouldValidate = !_shouldValidate;

    _updateCertificateValidation();
  }

  /// Updates the certificate validation in dio.
  /// This method replaces old [IOHttpClientAdapter] with an updated one.
  void _updateCertificateValidation() {
    _dio.httpClientAdapter.close();

    _dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();

        // Set the callback when a certificate cannot be authenticated.
        client.badCertificateCallback = (cert, host, port) {
          if (!_shouldValidate) {
            return true;
          }

          // This exception can be replaced with other handling.
          throw RequestServiceCertificateException();
        };

        return client;
      },
      // Certificate validation.
      validateCertificate: (cert, host, port) {
        if (!_shouldValidate) {
          return true;
        }

        // This exception can be replaced with other handling.
        throw RequestServiceCertificateException();
      },
    );
  }

  /// Toggles whether to use http/https.
  void toggleHttps() {
    _useHttps = !_useHttps;

    // Turning off validation when https is off.
    if (!_useHttps) {
      _shouldValidate = false;
    }
  }

  Future<ResponseDataModel?> performRequest() async {
    final uri = Uri(scheme: _useHttps ? 'https' : 'http', path: _url);
    _dio.options.method = method.name.toUpperCase();

    try {
      final response = await _dio.request<String>(uri.toString(), data: data);

      return ResponseDataModel.fromJson(response.data!);
    } on DioException catch (e) {
      // Handling connection errors.
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw RequestServiceConnectionException();
      }
    } catch (_) {
      rethrow;
    }

    return Future.value();
  }
}
