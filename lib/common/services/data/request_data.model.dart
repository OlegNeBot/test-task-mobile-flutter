import 'dart:convert';

class RequestDataModel {
  const RequestDataModel({required this.action, this.data});

  final String action;
  final Object? data;

  // TODO(Oleg): Add methods to check the types.
  String toJson() => jsonEncode({"__ACTION__": action, "__DATA__": data});
}
