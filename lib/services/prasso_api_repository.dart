// Dart imports:
import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
// Flutter imports:
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:pedantic/pedantic.dart';
// Project imports:
import 'package:prasso_app/app_widgets/home/cupertino_home_scaffold_view_model.dart';
import 'package:prasso_app/common_widgets/alert_dialogs.dart';
import 'package:prasso_app/constants/strings.dart';
import 'package:prasso_app/models/api_user.dart';
import 'package:prasso_app/models/app.dart';
import 'package:prasso_app/models/tab_item.dart';
import 'package:prasso_app/services/firestore_database.dart';
import 'package:prasso_app/services/shared_preferences_service.dart';
import 'package:prasso_app/utils/prasso_themedata.dart';

// Show ErrorToast
void showErrorToast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white);
}

void showSuccessToast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: PrassoColors.olive,
      textColor: Colors.white);
}

class PrassoApiRepository {
  PrassoApiRepository(
      this.sharedPreferencesServiceProvider, this.cupertinoHomeScaffoldVM);
  final SharedPreferencesService sharedPreferencesServiceProvider;
  final CupertinoHomeScaffoldViewModel cupertinoHomeScaffoldVM;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final String _apiServer = Strings.prodUrl;

  final String _configUrl = 'app/';
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  static PrassoApiRepository? _prassoApiInstance;

  String? appConfig = ''; //holds tabs and some user data not stored at Firebase
  String? personalAppToken = ''; //identifies this app
  String? thirdPartyToken = ''; //identifies your health user
  bool userIsSigningIn = false;
  bool userIsRegistering = false;
  bool doBuildTabs = false;

  factory PrassoApiRepository.empty(
      SharedPreferencesService sharedPreferencesServiceProvider,
      CupertinoHomeScaffoldViewModel cupertinoHomeScaffoldVM) {
    _prassoApiInstance = _prassoApiInstance ??
        PrassoApiRepository(
            sharedPreferencesServiceProvider, cupertinoHomeScaffoldVM);
    return PrassoApiRepository.instance;
  }
  static PrassoApiRepository get instance {
    return _prassoApiInstance!;
  }

  ApiUser? get currentUser {
    final savedUser = sharedPreferencesServiceProvider.getUserData();
    if (savedUser != null && savedUser.isNotEmpty) {
      userIsSigningIn = false;
      appConfig = sharedPreferencesServiceProvider.getAppData();
      personalAppToken = sharedPreferencesServiceProvider.getUserToken();

      // appConfig will be null if user is newly registered and on their own team
      // for this case, we want them to see a Getting Started screen.
      if (appConfig != '') {
        return ApiUser.fromStorage(savedUser, appConfig??'', personalAppToken);
      }
      
    } else {
      //we were signing out new users who have never registered here thus added userIsSigningIn
      if (!userIsSigningIn && !userIsRegistering) {
        signOut();
      }
    }

    return null;
  }

  //if you are using android studio emulator, change localhost to 10.0.2.2

  dynamic authData(String data, String apiUrl) {
    final fullUrl = _apiServer + apiUrl;
    return http.post(Uri.parse(fullUrl),
        body: jsonEncode(data), headers: _setHeaders());
  }

  Future<dynamic> getData(String apiUrl) async {
    final fullUrl = _apiServer + apiUrl;
    return http.get(Uri.parse(fullUrl), headers: _setHeaders());
  }

  Future<ApiUser?> signInWithEmailAndPassword(
      String email, String password) async {
    final String _signinUrl = _apiServer + Strings.signinUrl;

    userIsSigningIn = true;
    UserCredential? usr;
    bool userNeedsToRegister = false;
    try {
      usr = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found') {
          showErrorToast(Strings.pleaseRegister);
          userNeedsToRegister = true;
          print('Email not found at Firebase');

          ///if the user exists on api side but not at firebase, they need to register.
        } else {
          if (e.code == 'unauthorized') {
            userIsSigningIn = false;
            showErrorToast(e.message!);

            print('Email already in use');
            // Show an appropriate message to the user
          } else {
            print('An error occurred: ${e.message}');
            // Show a general error message
            showErrorToast('An error occurred: ${e.message}');
          }
        }
      } else {
        // Handle other types of exceptions
        print('An error occurred: $e');
        showErrorToast('An error occurred: $e');
      }
    }
    if (usr != null && usr.user != null) {
      String? _pnToken = '';
      final apiuser = ApiUser.fromAPIJson(
        usr.user,
        appConfig,
        personalAppToken,
      );

      if (apiuser.pnToken == null || apiuser.pnToken == '') {
        await _firebaseMessaging.getToken().then((token) => _pnToken = token);
        unawaited(_firebaseMessaging.subscribeToTopic('all'));
      } else {
        _pnToken = apiuser.pnToken;
      }

      final dynamic res = await http.post(Uri.parse(Uri.encodeFull(_signinUrl)),
          headers: _setHeaders(),
          body: jsonEncode(<String, String?>{
            'email': email,
            'password': password,
            'pn_token': _pnToken,
            'firebase_uid': usr.user!.uid
          }));
      if (res.statusCode == 200) {
        // Save email to shared preferences
        await sharedPreferencesServiceProvider.saveloginID(email);

        doBuildTabs = true; //do the build tabs after login
        await _parseReturnCallReload(res.body as String);
      } else {
        userIsSigningIn = false;
        throw Exception(res.body);
      }
    } else {
      userIsSigningIn = false;
      if (userNeedsToRegister) {
        throw Exception(Strings.pleaseRegister);
      }
      throw Exception('User name or Password was not recognized.');
    }

    userIsSigningIn = false;

    return currentUser;
  }

  Future<ApiUser> _parseReturnCallReload(String resBody) async {
    //app tabs decoded here and added to route
    final dynamic data = jsonDecode(resBody);

    personalAppToken = data['data']['token'] is String
        ? data['data']['token'].toString()
        : null;
    personalAppToken = personalAppToken!.replaceAll('"', '');
    appConfig = data['data']['app_data'] is String
        ? data['data']['app_data'].toString()
        : null;
    thirdPartyToken = data['data']['thirdPartyToken'] is String
        ? data['data']['thirdPartyToken'].toString()
        : null;

    ApiUser user = ApiUser.fromAPIJson(
        jsonEncode(data['data']), appConfig, personalAppToken);

    //update unreadmessages in the user from storage
    final unreadMessages = sharedPreferencesServiceProvider.getUnreadMessages();
    if (unreadMessages) {
      data['data']['unreadmessages'] = true;
      user = ApiUser.fromAPIJson(
          jsonEncode(data['data']), appConfig, personalAppToken);
    }
    final firestoreDatabase = FirestoreDatabase(uid: user.uid);
    await firestoreDatabase.setUser(user);

    unawaited(sharedPreferencesServiceProvider
        .saveUserData(jsonEncode(user.toMap())));

    unawaited(
        sharedPreferencesServiceProvider.setthirdPartyToken(thirdPartyToken));
    unawaited(sharedPreferencesServiceProvider.saveAppData(appConfig!));
    unawaited(
        sharedPreferencesServiceProvider.saveUserToken(personalAppToken!));
    cupertinoHomeScaffoldVM.defaultTabsJson = appConfig;
    if (doBuildTabs) {
      cupertinoHomeScaffoldVM.doBuildTabs = true;
      doBuildTabs = false;
    }
    cupertinoHomeScaffoldVM.currentTab = TabItem.position1;
    return user;
  }

  /// Notifies about changes to the user's sign-in state (such as sign-in or
  /// sign-out).
  Stream<ApiUser?> authStateChanges() {
    return _pipeStreamChanges(_firebaseAuth.authStateChanges());
  }

  //TODO: User Changes Provider should not notify of user changes during a build process
  //how to fix that
  // this method is key to the screen changes during IntroPages
  Stream<ApiUser> userChanges() {
    return _firebaseAuth
        .userChanges()
        .map((user) => ApiUser.fromAPIJson(user, appConfig, personalAppToken));
  }

  Stream<ApiUser?> _pipeStreamChanges(Stream<User?> stream) {
    final Stream<ApiUser?> streamSync = stream.map((delegateUser) {
      if (delegateUser == null) {
        return null;
      }
      return ApiUser.fromAPIJson(delegateUser, appConfig, personalAppToken);
    });

    late StreamController<ApiUser?> streamController;
    streamController = StreamController<ApiUser?>.broadcast(onListen: () {
      // Fire an event straight away
      streamController.add(currentUser);
      // Pipe events of the broadcast stream into this stream
      streamSync.pipe(streamController);
    });

    return streamController.stream;
  }

  Future<void> signOut() async {
    await cupertinoHomeScaffoldVM.signingout();

    final String _signoutUrl = '$_apiServer${Strings.logoutUrl}';

    final dynamic res = await http.post(
      Uri.parse(Uri.encodeFull(_signoutUrl)),
      headers: _setHeaders(),
    );
    unawaited(_firebaseAuth.signOut());

    unawaited(sharedPreferencesServiceProvider.saveUserData(null));

    return res;
  }

  /// used in conjunction with updateFirebaseApps to save app info
  Future<void> addApp(AppModel widget) async {
    final String _saveAppUrl = '$_apiServer${Strings.saveApp}';

    final dynamic res = await http.post(Uri.parse(Uri.encodeFull(_saveAppUrl)),
        headers: _setHeaders(),
        body: jsonEncode(<String, String?>{
          'team_id': Strings.teamId,
          'appicon': widget.tabIcon,
          'app_name': widget.documentId,
          'page_title': widget.pageTitle,
          'page_url': widget.pageUrl,
          'sort_order': widget.sortOrder.toString()
        }));

    if (res.statusCode != 200) {
      print('return statusCode error in addApp');
    }
  }

  /// used in conjunction with addApp to save app info
  Future<void> updateFirebaseApps(
      BuildContext context, AppModel widget, FirestoreDatabase database) async {
    try {
      final apps = await database.appsStream().first;
      final allLowerCaseNames =
          apps.map((app) => app.documentId?.toLowerCase()).toList();
      allLowerCaseNames.remove(widget.pageTitle!.toLowerCase());

      if (allLowerCaseNames.contains(widget.pageTitle!.toLowerCase())) {
        unawaited(showAlertDialog(
          context: context,
          title: 'Name already used',
          content: 'Please choose a different app name',
          defaultActionText: 'OK',
        ));
      } else {
        var documentId = widget.documentId;
        if (documentId!.isEmpty) {
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
  Future<bool> getAppConfig(ApiUser? user) async {
    final userToken = sharedPreferencesServiceProvider.getUserToken();
    if (userToken == null || userToken.isEmpty || userToken == 'null') {
      return false;
    }
    final clientAppUrl = _apiServer + _configUrl + userToken.toString();
    developer.log(
      'reload config data',
      name: 'prasso.app.getAppConfig',
      error: clientAppUrl,
    );
    final dynamic res = await http.post(Uri.parse(Uri.encodeFull(clientAppUrl)),
        headers: _setHeaders());
    if (res.statusCode == 200) {
      final appConfig = res.body.toString();
      if (appConfig.isEmpty || appConfig == 'null') {
        return false;
      }
      unawaited(sharedPreferencesServiceProvider.saveAppData(appConfig));
      cupertinoHomeScaffoldVM.defaultTabsJson = appConfig;
      if (doBuildTabs) {
        cupertinoHomeScaffoldVM.doBuildTabs = true;
        doBuildTabs = false;
      }
    }
    return true;
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    userIsSigningIn = userIsRegistering = true;
    //SET to show the intro
    await sharedPreferencesServiceProvider.unSetIntroComplete();

    String _pnToken = '';
    String _userUid = '';
    try {
      final UserCredential fbusr = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      if (fbusr.user != null) {
        _userUid = fbusr.user!.uid;
      }
    } catch (e) {
      // if user is registering and we get a message from firebase that user exists, then we will try to log them in instead
      userIsRegistering = false;
      if (e is FirebaseAuthException) {
        if (e.code == 'email-already-in-use') {
          userIsSigningIn = false;
          showErrorToast(e.message!);
          await signInWithEmailAndPassword(email, password);

          print('Email already in use');
          // Show an appropriate message to the user
        } else {
          print('An error occurred: ${e.message}');
          // Show a general error message
          showErrorToast('An error occurred: ${e.message}');
        }
      } else {
        // Handle other types of exceptions
        print('An error occurred: $e');
        showErrorToast('An error occurred: $e');
      }

      userIsSigningIn = false;
      return;
    }
    await _firebaseMessaging
        .getToken()
        .then((token) => _pnToken = token is String ? token : '');
    unawaited(_firebaseMessaging.subscribeToTopic('all'));

    final apiUser = ApiUser(
        uid: _userUid,
        displayName: email,
        email: email,
        initialized: false,
        pnToken: _pnToken);
    unawaited(sharedPreferencesServiceProvider
        .saveUserData(jsonEncode(apiUser.toMap())));

    final String _registerUrl = '${_apiServer}register';
    final dynamic res = await http.post(Uri.parse(Uri.encodeFull(_registerUrl)),
        headers: _setHeaders(),
        body: jsonEncode(<String, String?>{
          'name': email,
          'email': email,
          'password': password,
          'c_password': password,
          'firebase_uid': _userUid,
          'pn_token': _pnToken,
        }));

    if (res.statusCode == 200) {
      await sharedPreferencesServiceProvider.saveloginID(email);

      await _parseReturnCallReload(res.body as String);

      userIsSigningIn = userIsRegistering = false;
    } else {
      userIsSigningIn = userIsRegistering = false;
      throw Exception(res.body);
    }
  }

  Future<bool?> saveUserProfileData(
      BuildContext context, ApiUser? user, FirestoreDatabase database) async {
    final String _setUserUrl = '${_apiServer}save_user/${user?.uid}';
    final token = sharedPreferencesServiceProvider.getUserToken();
    if (token == null) {
      print('error getting user token. Login required.');
      await signOut();
      return null;
    }
    final userToken = token;
    if (userToken.isEmpty) {
      await signOut();
      return null;
    }

    await database.setUser(user!);

    final dynamic res = await http.post(Uri.parse(Uri.encodeFull(_setUserUrl)),
        headers: _setHeaders(), body: user.toString());

    if (res.statusCode == 200) {
      doBuildTabs = true; //do the build tabs after saveuserprofile
      await _parseReturnCallReload(res.body as String);
      return true;
    } else {
      print('error running saveUserProfileData: $res.body');
    }
    return false;
  }

  Future<String> uploadFile(String filePath, String filename) async {
    const prodWebUrl = Strings.prodUrl;

    // try post to web site which will push to aws
    const fullUrl = '${prodWebUrl}profile_update_image';

    final imageFile = File(filePath);
    final headerArray = _setHeaders();

    // open a bytestream
    // final stream =   http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    final stream = http.ByteStream(imageFile.openRead());

    // get file length
    final length = await imageFile.length();

    // string to uri
    final uri = Uri.parse(fullUrl);

    // create multipart request
    final request = http.MultipartRequest('POST', uri);
    request.headers.addAll(headerArray);

    // multipart that takes file
    final multipartFile = http.MultipartFile('image', stream, length,
        filename: basename(imageFile.path));

    // add file to multipart
    request.files.add(multipartFile);

    final http.Response response =
        await http.Response.fromStream(await request.send());

    print('Result: ${response.body}');
    if (response.statusCode == 200) {
      //persist the change in photo both locally and at firebase
      // and get it loaded in the display
      final String userData = sharedPreferencesServiceProvider.getUserData()!;
      // ignore: avoid_as
      final userdata = jsonDecode(userData) as Map<String, dynamic>;
      final dynamic data = jsonDecode(response.body);

      userdata['photoURL'] = data['data']['photoURL'];

      final user = ApiUser.fromAPIJson(
          jsonEncode(userdata), appConfig, personalAppToken);

      final firestoreDatabase = FirestoreDatabase(uid: user.uid);
      unawaited(firestoreDatabase.setUser(user));

      unawaited(sharedPreferencesServiceProvider
          .saveUserData(jsonEncode(user.toMap())));
    }
    return response.body;
  }

  Map<String, String> _setHeaders() {
    final String? userToken = sharedPreferencesServiceProvider.getUserToken();

    if (userToken != null && userToken.isNotEmpty) {
      print('Authorization: Bearer $userToken');
      return {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $userToken'
      };
    } else {
      return {'Content-type': 'application/json', 'Accept': 'application/json'};
    }
  }
}
