import 'dart:convert';

import 'package:test_task_mobile/common/services/data/request_service_exception.model.dart';
import 'package:test_task_mobile/common/utils/json_utils.dart';

class ResponseDataModel {
  const ResponseDataModel({required this.status, this.message, this.data});

  final bool status;
  final String? message;
  final Object? data;

  static const String _statusField = '__STATUS__';
  static const String _messageField = '__MESSAGE__';
  static const String _dataField = '__DATA__';

  static bool _hasValidFields(Map<String, dynamic> json) =>
      json.containsKey(_statusField) &&
      json.containsKey(_messageField) &&
      json.containsKey(_dataField);

  factory ResponseDataModel.fromJson(String json) {
    final jsonData = jsonDecode(json) as Map<String, dynamic>;

    if (!_hasValidFields(jsonData)) {
      throw RequestServiceInvalidResponseException();
    }

    final status = jsonData[_statusField];
    final message = jsonData[_messageField];
    final data = jsonData[_dataField];

    if (!(JsonUtils.isBool(status) &&
        (JsonUtils.isString(message) || message == null) &&
        JsonUtils.isValidType(data))) {
      throw RequestServiceInvalidResponseException();
    }

    return ResponseDataModel(status: status, message: message, data: data);
  }

  factory ResponseDataModel.fake() => ResponseDataModel(
    status: true,
    message: 'Fake message',
    data: 'Fake string data',
  );

  factory ResponseDataModel.invalidResponseError() =>
      ResponseDataModel.fromJson(
        '{"__STATUS__": true, "__FAKEMSG__": "fake message", "__DATA__": 1}',
      );

  factory ResponseDataModel.certificateError() =>
      throw RequestServiceCertificateException();

  factory ResponseDataModel.connectionError() =>
      throw RequestServiceConnectionException();
}
