import 'package:shared_preferences/shared_preferences.dart';

mixin SharedPreferencesManager {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<bool> sharedPreferencesSave(
      SharedPreferencesKey key, dynamic data) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString(key.toString(), data);
    return true;
  }

  dynamic sharedPreferencesGet(SharedPreferencesKey key) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.get(key.toString()).toString();
  }

  Future<void> sharedPreferencesRemove(SharedPreferencesKey key) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.remove(key.toString());
  }
}

enum SharedPreferencesKey { EMAIL, PASSWORD, INFO }
