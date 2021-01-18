// Package imports:
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  SharedPreferencesService(this.sharedPreferences);
  final SharedPreferences sharedPreferences;

  static const userTokenKey = 'userToken';
  static const appDataKey = 'appData';

  String getUserToken() {
    var userToken = sharedPreferences.getString(userTokenKey);
    if (userToken?.isEmpty ?? true) {
      userToken =
          '458eb0aedc4e38901255246a9352ba7b1aab2eee3d1537ecb23f2539b7a3efdf';
    }
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
