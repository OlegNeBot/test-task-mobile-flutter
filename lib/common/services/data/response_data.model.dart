import 'dart:convert';

class ResponseDataModel {
  const ResponseDataModel({required this.status, this.message, this.data});

  final bool status;
  final String? message;
  final Object? data;

  factory ResponseDataModel.fromJson(String json) {
    final jsonData = jsonDecode(json) as Map<String, dynamic>;

    // TODO(Oleg): Add methods to check the types.
    return ResponseDataModel(
      status: jsonData['__STATUS__'] as bool,
      message: jsonData['__MESSAGE__'] as String?,
      data: jsonData['__DATA__'] as Object?,
    );
  }
}
