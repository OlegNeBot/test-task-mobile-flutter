import 'package:dio/dio.dart';
import 'package:test_task_mobile/common/services/data/request_method_enum.dart';
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

  void setData(Object? data) {
    _data = data;
  }

  /// Sets request method.
  void setMethod(RequestMethod method) {
    _dio.options.method = method.name.toUpperCase();
  }

  /// Replaces old headers with the new ones.
  void setHeaders(Map<String, dynamic> headers) {
    _dio.options.headers = headers;
  }

  /// Adds new headers to old ones.
  void addHeaders(Map<String, dynamic> headers) {
    _dio.options.headers.addAll(headers);
  }

  // TODO(Oleg): Add validation control to https requests.

  Future<ResponseDataModel> performRequest() async {
    final response = await _dio.request<String>(url, data: data);

    if (response.data == null) {
      // TODO(Oleg): Add reaction.
    }

    return ResponseDataModel.fromJson(response.data!);
  }
}
