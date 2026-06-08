class AppData {
  // Private constructor
  AppData._internal();

  // Single instance
  static final AppData _instance = AppData._internal();

  // Factory constructor
  factory AppData() {
    return _instance;
  }

  // Variables to store data
  String? userName;
  int? userId;
  List<String>? units;
}
