import 'package:frontend/core/utils/log_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpService {
  const SpService();
  static const String _keyToken = "x-token";
  Future<void> setToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_keyToken, token);
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  Future<void> removeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(_keyToken);
    String? token = await getToken();
    LogService.d("TOKEN: $token");
  }
}
