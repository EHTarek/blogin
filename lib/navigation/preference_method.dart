import 'package:blogin/navigation/preference_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceMethod {
  late SharedPreferences prefs;

  Future<void> setTokenAccess(String key) async {
    prefs = await SharedPreferences.getInstance();
    await prefs.setString(PreferenceKey.tokenAccess, key);
  }

  Future<String?> getTokenAccess() async {
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

  Future<void> removeData(String key) async{
    prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}
