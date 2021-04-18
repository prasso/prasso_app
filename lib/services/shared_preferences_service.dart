// Package imports:
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  SharedPreferencesService(this.sharedPreferences);
  final SharedPreferences sharedPreferences;

  static const userTokenKey = 'userToken';
  static const appDataKey = 'appData';

  String getUserToken() {
    final String userToken = sharedPreferences.getString(userTokenKey);

    return userToken;
  }

  String getAppData() {
    return sharedPreferences.getString(appDataKey);
  }

  Future<bool> saveAppData(String appData) async {
    await sharedPreferences.setString(
        appDataKey, appData.replaceAll('"', '&quote;'));
    return true;
  }

  Future<bool> saveUserToken(String userToken) async {
    await sharedPreferences.setString(
        userTokenKey, userToken.replaceAll('"', ''));
    return true;
  }
}
