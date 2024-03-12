import 'package:shared_preferences/shared_preferences.dart';

class LocalDb {
  late final SharedPreferences _prefs;

  static LocalDb? _instance;

  LocalDb._();

  factory LocalDb() {
    return _instance ??= LocalDb._();
  }

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  double? getDouble(String key) {
    return _prefs.getDouble(key);
  }

  Future<bool> setDouble(String key, double value) {
    return _prefs.setDouble(key, value);
  }
}
