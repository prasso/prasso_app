// Package imports:
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  SharedPreferencesService(this.sharedPreferences);
  final SharedPreferences? sharedPreferences;

  static const userTokenKey = 'userToken';
  static const accessTokenKey = 'accessToken';
  static const thirdPartyTokenKey = 'thirdPartyToken';
  static const appDataKey = 'appData';
  static const userDataKey = 'userData';
  static const onboardingCompleteKey = 'onboardingComplete';
  static const introCompleteKey = 'introComplete';
  static const unreadMessagesKey = 'unreadMessages';
  static const loginIDkey = 'loginID';

  String getloginID() {
    final String? email = sharedPreferences!.getString(loginIDkey);
    if (email != null) {
      return email;
    }
    return '';
  }

  Future<bool> saveloginID(String? loginID) async {
    if (loginID == null) {
      await sharedPreferences!.setString(loginIDkey, '');
      return true;
    }
    await sharedPreferences!.setString(loginIDkey, loginID);
    return true;
  }

  String? getUserData() {
    final String? userData = sharedPreferences!.getString(userDataKey);
    if (userData != null) {
      final restoredjson = userData.replaceAll('&quote;', '"');
      return restoredjson;
    }
    return null;
  }

  Future<bool> saveUserData(String? userData) async {
    if (userData == null) {
      await sharedPreferences!.setString(userDataKey, '');
      await setIntroComplete();
      await setOnboardingComplete();
    } else {
      await sharedPreferences!
          .setString(userDataKey, userData.replaceAll('"', '&quote;'));
    }
    return true;
  }

  String? getAppData() {
    final appDataFromStorage = sharedPreferences!.getString(appDataKey);
    if (appDataFromStorage != null) {
      final restoredjson = appDataFromStorage.replaceAll('&quote;', '"');
      return restoredjson;
    }
    return null;
  }

  Future<bool> saveAppData(String appData) async {
    await sharedPreferences!
        .setString(appDataKey, appData.replaceAll('"', '&quote;'));
    return true;
  }

  String? getUserToken() {
    final String? userToken = sharedPreferences!.getString(userTokenKey);
    return userToken;
  }

  Future<bool> saveUserToken(String userToken) async {
    await sharedPreferences!
        .setString(userTokenKey, userToken.replaceAll('"', ''));
    return true;
  }

  Future<bool> saveAccessToken(String accessToken) async {
    await sharedPreferences!
        .setString(accessTokenKey, accessToken.replaceAll('"', ''));
    return true;
  }

  String? getAccessToken() {
    final String? accessToken = sharedPreferences!.getString(accessTokenKey);
    return accessToken;
  }

  Future<bool> setthirdPartyToken(String? thirdPartyToken) async {
    if (thirdPartyToken == null) {
      await sharedPreferences!.setString(thirdPartyTokenKey, '');
    } else {
      await sharedPreferences!
          .setString(thirdPartyTokenKey, thirdPartyToken.replaceAll('"', ''));
    }
    return true;
  }

  String getthirdPartyToken() {
    final String? thirdPartyToken =
        sharedPreferences!.getString(thirdPartyTokenKey);
    if (thirdPartyToken != null) {
      final restoredjson = thirdPartyToken.replaceAll('"', '');
      return restoredjson;
    }
    return '';
  }

  Future<void> setOnboardingComplete() async {
    await sharedPreferences!.setBool(onboardingCompleteKey, true);
  }

  Future<void> unSetOnboardingComplete() async {
    await sharedPreferences!.setBool(onboardingCompleteKey, false);
  }

  bool isOnboardingComplete() =>
      sharedPreferences!.getBool(onboardingCompleteKey) ?? false;

  Future<void> setIntroComplete() async {
    await sharedPreferences!.setBool(introCompleteKey, true);
  }

  Future<void> unSetIntroComplete() async {
    await sharedPreferences!.setBool(introCompleteKey, false);
  }

  bool isIntroComplete() =>
      sharedPreferences!.getBool(introCompleteKey) ?? true;

  bool getUnreadMessages() {
    final bool? unreadMessages = sharedPreferences!.getBool(unreadMessagesKey);
    if (unreadMessages != null) {
      return unreadMessages;
    }
    return false;
  }

  Future<bool> saveUnreadMessages({bool? unreadMessages}) async {
    if (unreadMessages == null) {
      await sharedPreferences!.setBool(unreadMessagesKey, false);
    } else {
      await sharedPreferences!.setBool(unreadMessagesKey, unreadMessages);
    }
    return true;
  }
}
