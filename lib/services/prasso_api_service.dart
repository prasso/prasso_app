import 'dart:convert';
// import 'dart:developer' as developer;
import 'package:http/http.dart';
import 'package:prasso_app/app_widgets/home/cupertino_home_scaffold_view_model.dart';
import 'package:prasso_app/common_widgets/alert_dialogs.dart';
import 'package:prasso_app/constants/strings.dart';
import 'package:prasso_app/models/app.dart';
import 'package:prasso_app/service_locator.dart';
import 'package:prasso_app/services/firestore_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:pedantic/pedantic.dart';
import 'package:prasso_app/models/api_user.dart';
import 'package:prasso_app/utils/shared_preferences_helper.dart';
import 'package:provider/provider.dart';
import 'package:flutter_config/flutter_config.dart';

/*
https://medium.com/swlh/authenticating-flutter-application-with-laravel-api-caea30abd57
 */
class PrassoApiService {
  PrassoApiService();
  final String _apiServer = FlutterConfig.get(Strings.apiUrl).toString();

  final String _configUrl = '${FlutterConfig.get(Strings.apiUrl)}app/';
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  String appConfig = ''; //holds tabs and some user data not stored at Firebase
  String personalAppToken = ''; //identifies this app

  Future<bool> getStoredAppConfig() async {
    await SharedPreferencesHelper.getAppData().then<String>((appconfig) {
      // ignore: join_return_with_assignment
      appConfig = appconfig;
      return appConfig;
    });
    return true;
  }
  //if you are using android studio emulator, change localhost to 10.0.2.2

  Future<dynamic> authData(String data, String apiUrl) async {
    final fullUrl = _apiServer + apiUrl;
    await SharedPreferencesHelper.getUserToken().then<Response>((userToken) {
      return http.post(fullUrl,
          body: jsonEncode(data), headers: _setHeaders(userToken));
    });
  }

  Future<dynamic> getData(String apiUrl) async {
    final fullUrl = _apiServer + apiUrl;
    await SharedPreferencesHelper.getUserToken().then<Response>((userToken) {
      return http.get(fullUrl, headers: _setHeaders(userToken.toString()));
    });
  }

  dynamic _setHeaders(String usertoken) => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer$usertoken'
      };

  Future<ApiUser> signInWithEmailAndPassword(
      String email, String password) async {
    final String _signinUrl = _apiServer + Strings.signinUrl;

    final UserCredential usr = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);

    if (usr.user != null) {
      String _pntoken;
      await _firebaseMessaging.getToken().then((token) => _pntoken = token);
      unawaited(_firebaseMessaging.subscribeToTopic('all'));

      final dynamic res = await http.post(Uri.encodeFull(_signinUrl),
          headers: _setHeaders(''),
          body: jsonEncode(<String, String>{
            'email': email,
            'password': password,
            'pn_token': _pntoken,
            'firebase_uid': usr.user.uid
          }));
      if (res.statusCode == 200) {
        // for an example return, see prasso_api_service_test.dart
        setupLocator();
        changeStateNReloadUser(usr.user, res.body.toString(), personalAppToken);
        await processIntoTabs(res.body);
      } else {
        throw Exception(res.body);
      }
    } else {
      throw Exception('User name or Password was not recognized.');
    }

    return null;
  }

  ApiUser changeStateNReloadUser(
      dynamic usr, String appconfig, String personalAppToken) {
    final String newAppToken = personalAppToken.replaceAll('"', '');
    final ApiUser user = ApiUser.fromAPIJson(usr, appconfig, newAppToken);

    final FirestoreDatabase _database = FirestoreDatabase(uid: user.uid);
    unawaited(_database.setUser(user));

    setupLoggedInUser(user);
    return user;
  }

  Stream<ApiUser> authStateChanges() {
    return _firebaseAuth
        .authStateChanges()
        .map((user) => ApiUser.fromAPIJson(user, appConfig, personalAppToken));
  }

  Future<void> signOut() async {
    final String _signoutUrl = '$_apiServer${Strings.logoutUrl}';

    await SharedPreferencesHelper.getUserToken()
        .then<dynamic>((userToken) async {
      final dynamic res = await http.post(
        Uri.encodeFull(_signoutUrl),
        headers: _setHeaders(userToken.toString()),
      );
      unawaited(_firebaseAuth.signOut());
      await locator<CupertinoHomeScaffoldViewModel>().clear();

      return res;
    });
  }

  Future<String> processIntoTabs(String returnedJson) async {
    if (returnedJson == '') {
      return '';
    }
    await locator<CupertinoHomeScaffoldViewModel>().clear();

    //app tabs decoded here and added to route
    final dynamic data = jsonDecode(returnedJson);

    personalAppToken = data['data']['token'] as String;
    appConfig = data['data']['app_data'] as String;

    unawaited(SharedPreferencesHelper.saveAppData(appConfig));
    unawaited(SharedPreferencesHelper.saveUserToken(personalAppToken));

    locator<CupertinoHomeScaffoldViewModel>().setProperties();
    return appConfig;
  }

  /// used in conjunction with updateFirebaseApps to save app info
  Future<void> addApp(AppModel widget) async {
    final String _saveAppUrl = '$_apiServer${Strings.saveApp}';

    await SharedPreferencesHelper.getUserToken()
        .then<String>((userToken) async {
      final dynamic res = await http.post(Uri.encodeFull(_saveAppUrl),
          headers: _setHeaders(userToken.toString()),
          body: jsonEncode(<String, String>{
            'team_id': Strings.teamId,
            'appicon': widget.tabIcon,
            'app_name': widget.documentId,
            'page_title': widget.pageTitle,
            'page_url': widget.pageUrl,
            'sort_order': widget.sortOrder.toString()
          }));

      if (res.statusCode != 200) {
        return 'error';
      }
      return 'success';
    });
  }

  /// used in conjunction with addApp to save app info
  Future<void> updateFirebaseApps(BuildContext context, AppModel widget) async {
    try {
      final database = Provider.of<FirestoreDatabase>(context, listen: false);
      final apps = await database.appsStream().first;
      final allLowerCaseNames =
          apps.map((app) => app.documentId.toLowerCase()).toList();
      allLowerCaseNames.remove(widget.pageTitle.toLowerCase());

      if (allLowerCaseNames.contains(widget.pageTitle.toLowerCase())) {
        unawaited(showAlertDialog(
          context: context,
          title: 'Name already used',
          content: 'Please choose a different app name',
          defaultActionText: 'OK',
        ));
      } else {
        var documentId = widget?.documentId ?? documentIdFromCurrentDate();
        if (documentId?.isEmpty ?? true) {
          documentId = documentIdFromCurrentDate();
        }
        widget.documentId = documentId;
        await database.setApp(widget);
      }
    } catch (e) {
      unawaited(showExceptionAlertDialog(
        context: context,
        title: 'Operation failed',
        exception: e,
      ));
    }
  }

  ////
  /// this code retrieves the app tabs, these are also retrieved in signInWithEmailandPassword
  ///
  Future<String> getAppConfig(ApiUser user, BuildContext context) async {
    await SharedPreferencesHelper.getUserToken().then((userToken) async {
      final clientAppUrl = _configUrl + userToken.toString();
      final dynamic res = await http.post(Uri.encodeFull(clientAppUrl),
          headers: _setHeaders(userToken.toString()));
      if (res.statusCode == 200) {
        await processIntoTabs(res.body);
        return changeStateNReloadUser(user, appConfig, personalAppToken);
      }
    });
    return null;
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  // ignore: missing_return
  Future<ApiUser> createUserWithEmailAndPassword(
      String email, String password) async {
    final UserCredential usr = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);

    final String _registerUrl = '${_apiServer}register';
    final dynamic res = await http.post(Uri.encodeFull(_registerUrl),
        headers: _setHeaders(usr.user.uid),
        body: jsonEncode(<String, String>{
          'name': email,
          'email': email,
          'password': password,
          'c_password': password,
          'firebase_uid': usr.user.uid
        }));

    if (res.statusCode == 200) {
      setupLocator();
      await processIntoTabs(res.body);
      return changeStateNReloadUser(usr.user, appConfig, personalAppToken);
    } else {
      throw Exception(res.body);
    }
  }

  Future<ApiUser> saveUserProfileData(
      BuildContext context, ApiUser user) async {
    final String _setUserUrl = '${_apiServer}save_user/${user.uid}';

    await SharedPreferencesHelper.getUserToken()
        .then<ApiUser>((userToken) async {
      if (userToken.isEmpty) {
        await signOut();
        return null;
      }

      final _database = Provider.of<FirestoreDatabase>(context, listen: false);
      await _database.setUser(user);

      final dynamic res = await http.post(Uri.encodeFull(_setUserUrl),
          headers: _setHeaders(userToken.toString()),
          body: jsonEncode(<String, String>{
            'name': user.displayName,
            'email': user.email,
            'firebase_uid': user.uid,
            'profile_photo_url': user.photoURL
          }));

      if (res.statusCode == 200) {
        await processIntoTabs(res.body);
        return changeStateNReloadUser(user, appConfig, personalAppToken);
      } else {
        throw Exception(res.body);
      }
    });
    return null;
  }
}
