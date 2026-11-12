import 'dart:convert';

/// Conversions used at the API boundary. Invalid values remain nullable.
class JsonHelper {
  static int? toInt(dynamic value) {
    if (value is bool) return value ? 1 : 0;
    if (value is int) return value;
    final number = toDouble(value);
    if (number == null || number.truncateToDouble() != number) return null;
    return number.toInt();
  }

  static double? toDouble(dynamic value) {
    final number = value is num
        ? value.toDouble()
        : value is String
            ? double.tryParse(value.trim())
            : null;
    return number != null && number.isFinite ? number : null;
  }

  static String? toStringValue(dynamic value) {
    if (value is String || value is num || value is bool) {
      return value.toString();
    }
    return null;
  }

  static bool? toNullableBool(dynamic value) {
    if (value is bool) return value;
    final text = toStringValue(value)?.trim().toLowerCase();
    if (text == 'true' || text == '1' || text == '1.0' || text == 'yes')
      return true;
    if (text == 'false' || text == '0' || text == '0.0' || text == 'no')
      return false;
    return null;
  }

  static bool toBool(dynamic value) => toNullableBool(value) ?? false;

  static Map<String, dynamic> toMap(dynamic value) {
    if (value is String) value = jsonDecode(value);
    if (value is Map<String, dynamic>) return value;
    if (value is Map)
      return value.map((key, item) => MapEntry(key.toString(), item));
    throw const FormatException('Expected a JSON object');
  }

  static List<Map<String, dynamic>> objectList(dynamic value) =>
      value is List ? value.whereType<Map>().map(toMap).toList() : [];

  static List<String> stringList(dynamic value) => value is List
      ? value.map(toStringValue).whereType<String>().toList()
      : [];
}
