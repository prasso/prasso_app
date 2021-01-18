// Dart imports:
import 'dart:async';
import 'dart:convert';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart' as http;
import 'package:pedantic/pedantic.dart';

// Project imports:
import 'package:prasso_app/app_widgets/home/cupertino_home_scaffold_view_model.dart';
import 'package:prasso_app/common_widgets/alert_dialogs.dart';
import 'package:prasso_app/constants/strings.dart';
import 'package:prasso_app/models/api_user.dart';
import 'package:prasso_app/models/app.dart';
import 'package:prasso_app/services/firestore_database.dart';
import 'package:prasso_app/services/shared_preferences_service.dart';

class PrassoApiRepository {
  PrassoApiRepository(
      this.sharedPreferencesServiceProvider, this.cupertinoHomeScaffoldVM);
  final SharedPreferencesService sharedPreferencesServiceProvider;
  final CupertinoHomeScaffoldViewModel cupertinoHomeScaffoldVM;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final String _apiServer = FlutterConfig.get(Strings.apiUrl).toString();
  final String _configUrl = '${FlutterConfig.get(Strings.apiUrl)}app/';
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  static PrassoApiRepository _prassoApiInstance;

  String appConfig = ''; //holds tabs and some user data not stored at Firebase
  String personalAppToken = ''; //identifies this app

  factory PrassoApiRepository.empty(
      SharedPreferencesService sharedPreferencesServiceProvider,
      CupertinoHomeScaffoldViewModel cupertinoHomeScaffoldVM) {
    _prassoApiInstance = _prassoApiInstance ??
        PrassoApiRepository(
            sharedPreferencesServiceProvider, cupertinoHomeScaffoldVM);
    return PrassoApiRepository.instance;
  }
  static PrassoApiRepository /*!*/ get instance {
    return _prassoApiInstance;
  }

  ApiUser get currentUser {
    if (_firebaseAuth.currentUser != null) {
      return ApiUser.fromAPIJson(
          _firebaseAuth.currentUser, appConfig, personalAppToken);
    }

    return null;
  }

  //if you are using android studio emulator, change localhost to 10.0.2.2

  dynamic authData(String data, String apiUrl) {
    final fullUrl = _apiServer + apiUrl;
    final userToken = sharedPreferencesServiceProvider.getUserToken();
    return http.post(fullUrl,
        body: jsonEncode(data), headers: _setHeaders(userToken));
  }

  Future<dynamic> getData(String apiUrl) async {
    final fullUrl = _apiServer + apiUrl;
    final userToken = sharedPreferencesServiceProvider.getUserToken();
    return http.get(fullUrl, headers: _setHeaders(userToken.toString()));
  }

  dynamic _setHeaders(String usertoken) => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer$usertoken'
      };

  void signInAnonymously() {}

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
        await processIntoTabs(res.body);

        // for an example return, see prasso_api_service_test.dart
        changeStateNReloadUser(usr.user, res.body.toString(), personalAppToken);
      } else {
        throw Exception(res.body);
      }
    } else {
      throw Exception('User name or Password was not recognized.');
    }

    return currentUser;
  }

  ApiUser changeStateNReloadUser(
      dynamic usr, String appconfignew, String passedAppToken) {
    final String newAppToken = passedAppToken.replaceAll('"', '');
    personalAppToken = newAppToken;
    appConfig = appconfignew;

    final user = ApiUser.fromAPIJson(usr, appConfig, personalAppToken);
    if (user != null) {
      final firestoreDatabase = FirestoreDatabase(uid: user.uid);
      unawaited(firestoreDatabase.setUser(user));
    }
    return user;
  }

  /// Notifies about changes to the user's sign-in state (such as sign-in or
  /// sign-out).
  Stream<ApiUser> authStateChanges() {
    return _pipeStreamChanges(_firebaseAuth.authStateChanges());
  }

  /// Notifies about changes to the user's data
//  Stream<ApiUser> userChanges() {
//    return _pipeStreamChanges(_firebaseAuth.userChanges());
//  }
  Stream<ApiUser> userChanges() {
    return _firebaseAuth
        .userChanges()
        .map((user) => ApiUser.fromAPIJson(user, appConfig, personalAppToken));
  }

  Stream<ApiUser> _pipeStreamChanges(Stream<User> stream) {
    final Stream<ApiUser> streamSync = stream.map((delegateUser) {
      if (delegateUser == null) {
        return null;
      }

      return ApiUser.fromAPIJson(delegateUser, appConfig, personalAppToken);
    });

    StreamController<ApiUser> streamController;
    streamController = StreamController<ApiUser>.broadcast(onListen: () {
      // Fire an event straight away
      streamController.add(currentUser);
      // Pipe events of the broadcast stream into this stream
      streamSync.pipe(streamController);
    });

    return streamController.stream;
  }

  Future<void> signOut() async {
    final String _signoutUrl = '$_apiServer${Strings.logoutUrl}';

    final userToken = sharedPreferencesServiceProvider.getUserToken();
    final dynamic res = await http.post(
      Uri.encodeFull(_signoutUrl),
      headers: _setHeaders(userToken.toString()),
    );
    unawaited(_firebaseAuth.signOut());

    await cupertinoHomeScaffoldVM.clear();

    return res;
  }

  Future<String> processIntoTabs(String returnedJson) async {
    if (returnedJson == '') {
      return '';
    }
    //maybe wasting cycles  await cupertinoHomeScaffoldVM.clear();

    //app tabs decoded here and added to route
    final dynamic data = jsonDecode(returnedJson);

    personalAppToken = data['data']['token'] as String;
    appConfig = data['data']['app_data'] as String;

    unawaited(sharedPreferencesServiceProvider.saveAppData(appConfig));
    unawaited(sharedPreferencesServiceProvider.saveUserToken(personalAppToken));

    cupertinoHomeScaffoldVM.setProperties();
    return appConfig;
  }

  /// used in conjunction with updateFirebaseApps to save app info
  Future<void> addApp(AppModel widget) async {
    final String _saveAppUrl = '$_apiServer${Strings.saveApp}';

    final userToken = sharedPreferencesServiceProvider.getUserToken();
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
  }

  /// used in conjunction with addApp to save app info
  Future<void> updateFirebaseApps(
      BuildContext context, AppModel widget, FirestoreDatabase database) async {
    try {
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
  Future<bool> getAppConfig(ApiUser user) async {
    final userToken = sharedPreferencesServiceProvider.getUserToken();
    final clientAppUrl = _configUrl + userToken.toString();
    final dynamic res = await http.post(Uri.encodeFull(clientAppUrl),
        headers: _setHeaders(userToken.toString()));
    if (res.statusCode == 200) {
      await processIntoTabs(res.body);
      changeStateNReloadUser(user, appConfig, personalAppToken);
    }
    return true;
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  // ignore: missing_return
  Future<bool> createUserWithEmailAndPassword(
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
      await processIntoTabs(res.body);
      changeStateNReloadUser(usr.user, appConfig, personalAppToken);
    } else {
      throw Exception(res.body);
    }
    return true;
  }

  Future<bool> saveUserProfileData(
      BuildContext context, ApiUser user, FirestoreDatabase database) async {
    final String _setUserUrl = '${_apiServer}save_user/${user.uid}';

    final userToken = sharedPreferencesServiceProvider.getUserToken();
    if (userToken.isEmpty) {
      await signOut();
      return null;
    }

    await database.setUser(user);

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
      changeStateNReloadUser(user, appConfig, personalAppToken);
    } else {
      throw Exception(res.body);
    }
    return true;
  }
}
