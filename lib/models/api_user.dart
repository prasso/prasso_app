// import 'dart:developer';

// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:prasso_app/app_widgets/account/edit_user_profile_viewmodel.dart';

@immutable
class ApiUser {
  const ApiUser(
      {@required this.uid,
      this.email,
      this.photoURL,
      this.displayName,
      this.appConfig,
      this.appToken,
      this.initialized})
      : assert(uid != null, 'User can only be created with a non-null uid');

  final String uid;
  final String email;
  final String photoURL;
  final String displayName;
  final String appConfig;
  final String appToken; //the token which identifies this user's app
  final bool initialized;

  factory ApiUser.fromLocatorUpdated(
      ApiUser user, EditUserProfileViewModel vm) {
    return ApiUser(
        uid: user.uid,
        email: vm.email,
        photoURL: vm.photoURL,
        displayName: vm.displayName,
        appToken: user.appToken,
        initialized: true);
  }

  factory ApiUser.fromAPIJson(
      dynamic _user, String appConfig, String appToken) {
    if (_user == null) {
      return null;
    }

    if (_user is User) {
      final User usr = _user;

      if (!(appConfig?.isEmpty ?? true)) {
        final dynamic jsonAppData = jsonDecode(appConfig);
        if (jsonAppData != null && jsonAppData.containsKey('data') == true) {
          return ApiUser(
              uid: usr.uid,
              email: usr.email,
              displayName: jsonAppData['data']['name'],
              photoURL: jsonAppData['data']['photoURL'],
              appConfig: appConfig,
              appToken: jsonAppData['data']['token'],
              initialized: true);
        }
      }
      return ApiUser(
          uid: usr.uid,
          email: usr.email,
          displayName: usr.displayName,
          photoURL: usr.photoURL,
          appConfig: appConfig,
          appToken: appToken,
          initialized: false);
    } else {
      if (_user is ApiUser) {
        return _user;
      }

      final dynamic jsonResponse = jsonDecode(_user);
      if (jsonResponse['data'] != null) {
        final String jsonusr = jsonEncode(_user);
        return ApiUser(
            uid: _user['data']['uid'].toString(),
            email: _user['data']['email'],
            displayName: _user['data']['name'],
            photoURL: _user['data']['photoURL'].toString(),
            appConfig: jsonusr,
            appToken: _user['data']['token'],
            initialized: true);
      } else {
        return ApiUser(
            uid: jsonResponse['uid'].toString(),
            email: jsonResponse['email'],
            displayName: jsonResponse['displayName'] ?? jsonResponse['name'],
            photoURL: jsonResponse['photoURL'],
            appConfig: jsonResponse['appConfig'] ?? appConfig,
            appToken: jsonResponse['appToken'] ?? appToken,
            initialized: true);
      }
    }
  }

  @override
  String toString() {
    return jsonEncode(toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'photoURL': photoURL,
      'displayName': displayName,
      'appConfig': appConfig,
      'appToken': appToken.replaceAll('"', ''),
    };
  }
}
