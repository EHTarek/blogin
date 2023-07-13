import 'package:blogin/navigation/preference_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceMethod {
  late SharedPreferences prefs;

  Future<void> setTokenAccess(String key) async {
    prefs = await SharedPreferences.getInstance();
    await prefs.setString(PreferenceKey.tokenAccess, key);
  }

  getTokenAccess() async {
    prefs = await SharedPreferences.getInstance();
    return prefs.getString(PreferenceKey.tokenAccess);
  }

  Future<void> setTokenRefresh(String key) async {
    prefs = await SharedPreferences.getInstance();
    await prefs.setString(PreferenceKey.tokenRefresh, key);
  }

  Future<String> getTokenRefresh() async {
    prefs = await SharedPreferences.getInstance();
    return prefs.getString(PreferenceKey.tokenRefresh) ?? '';
  }
}
