import 'package:shared_preferences/shared_preferences.dart';
import 'package:wortschatzchen_quiz/utils/constants.dart';

class SettingsService {
  static const String _baseUrl = '';
  static const String _authToken = '';

  Future<String> getBaseUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(baseUrlSettingsName) ?? '';
  }

  Future<void> setBaseUrl(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(baseUrlSettingsName, value);
  }

  Future<String> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(authTokenSettingsName) ?? '';
  }

  Future<void> setAuthToken(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(authTokenSettingsName, value);
  }
}
