// Package imports:
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  SharedPreferencesService(this.sharedPreferences);
  final SharedPreferences sharedPreferences;

  static const userTokenKey = 'userToken';
  static const appDataKey = 'appData';
  static const userDataKey = 'userData';
  static const onboardingCompleteKey = 'onboardingComplete';

  String getUserData() {
    final String userData = sharedPreferences.getString(userDataKey);
    if (userData != null) {
      final restoredjson = userData.replaceAll('&quote;', '"');
      return restoredjson;
    }
    return null;
  }

  Future<bool> saveUserData(String userData) async {
    await sharedPreferences.setString(
        userDataKey, userData.replaceAll('"', '&quote;'));
    return true;
  }

  String getAppData() {
    final appDataFromStorage = sharedPreferences.getString(appDataKey);
    if (appDataFromStorage != null) {
      final restoredjson = appDataFromStorage.replaceAll('&quote;', '"');
      return restoredjson;
    }
    return null;
  }

  Future<bool> saveAppData(String appData) async {
    await sharedPreferences.setString(
        appDataKey, appData.replaceAll('"', '&quote;'));
    return true;
  }

  String getUserToken() {
    final String userToken = sharedPreferences.getString(userTokenKey);

    return userToken;
  }

  Future<bool> saveUserToken(String userToken) async {
    await sharedPreferences.setString(
        userTokenKey, userToken.replaceAll('"', ''));
    return true;
  }

  Future<void> setOnboardingComplete() async {
    await sharedPreferences.setBool(onboardingCompleteKey, true);
  }

  bool isOnboardingComplete() =>
      sharedPreferences.getBool(onboardingCompleteKey) ?? false;
}
