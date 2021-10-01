// Package imports:
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  SharedPreferencesService(this.sharedPreferences);
  final SharedPreferences sharedPreferences;

  static const userTokenKey = 'userToken';
  static const accessTokenKey = 'accessToken';
  static const appDataKey = 'appData';
  static const userDataKey = 'userData';
  static const onboardingCompleteKey = 'onboardingComplete';
  static const introCompleteKey = 'introComplete';

  String getUserData() {
    final String userData = sharedPreferences.getString(userDataKey);
    if (userData != null) {
      final restoredjson = userData.replaceAll('&quote;', '"');
      return restoredjson;
    }
    return null;
  }

  Future<bool> saveUserData(String userData) async {
    if (userData == null) {
      await sharedPreferences.setString(userDataKey, null);
    } else {
      await sharedPreferences.setString(
          userDataKey, userData?.replaceAll('"', '&quote;'));
    }
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
  Future<bool> saveAccessToken(String accessToken) async {
    await sharedPreferences.setString(
        accessTokenKey, accessToken.replaceAll('"', ''));
    return true;
  }
  String getAccessToken() {
    final String accessToken = sharedPreferences.getString(accessTokenKey);
    return accessToken;
  }
  Future<void> setOnboardingComplete() async {
    await sharedPreferences.setBool(onboardingCompleteKey, true);
  }

  Future<void> unSetOnboardingComplete() async {
    await sharedPreferences.setBool(onboardingCompleteKey, false);
  }

  bool isOnboardingComplete() =>
      sharedPreferences.getBool(onboardingCompleteKey) ?? false;

  Future<void> setIntroComplete() async {
    await sharedPreferences.setBool(introCompleteKey, true);
  }

  Future<void> unSetIntroComplete() async {
    await sharedPreferences.setBool(introCompleteKey, false);
  }

  bool isIntroComplete() =>
      sharedPreferences.getBool(introCompleteKey) ?? false;
}
