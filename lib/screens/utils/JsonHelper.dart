class JsonHelper {
  static int? toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  static double? toDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString());
  }

  static String? toStringValue(dynamic value) {
    return value?.toString();
  }

  static bool toBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;

    final v = value.toString().toLowerCase();
    return v == 'true' || v == '1' || v == 'yes';
  }
}
