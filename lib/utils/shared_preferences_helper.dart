import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static Future<String> getUserToken() async {
    final SharedPreferences localStorage =
        await SharedPreferences.getInstance();
    var userToken = localStorage.getString('userToken');
    if (userToken?.isEmpty ?? true) {
      userToken =
          '458eb0aedc4e38901255246a9352ba7b1aab2eee3d1537ecb23f2539b7a3efdf';
    }
    return userToken;
  }

  static Future<String> getAppData() async {
    final SharedPreferences localStorage =
        await SharedPreferences.getInstance();
    return localStorage.getString('appData');
  }

  static Future<bool> saveAppData(String appData) async {
    final SharedPreferences localStorage =
        await SharedPreferences.getInstance();
    await localStorage.setString('appData', appData.replaceAll('"', '&quote;'));
    return true;
  }

  static Future<bool> saveUserToken(String userToken) async {
    final SharedPreferences localStorage =
        await SharedPreferences.getInstance();
    await localStorage.setString('userToken', userToken.replaceAll('"', ''));
    return true;
  }
}
