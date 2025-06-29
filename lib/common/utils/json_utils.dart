/// Contains methods to check the type of JSON data.
final class JsonUtils {
  static bool isString(Object? value) => value is String;

  static bool isInt(Object? value) => value is int;

  static bool isBool(Object? value) => value is bool;

  static bool isList(Object? value) => value is List;

  static bool isJsonMap(Object? value) => value is Map<String, dynamic>;

  static bool isValidType(Object? value) =>
      value == null ||
      isString(value) ||
      isInt(value) ||
      isList(value) ||
      isJsonMap(value);

  static bool isType<T>(Object? value) => value is T;
}
