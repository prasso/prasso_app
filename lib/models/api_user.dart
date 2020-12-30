// import 'dart:developer';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

@immutable
class ApiUser {
  const ApiUser(
      {@required this.uid,
      this.email,
      this.photoURL,
      this.displayName,
      this.appConfig,
      this.appToken})
      : assert(uid != null, 'User can only be created with a non-null uid');

  final String uid;
  final String email;
  final String photoURL;
  final String displayName;
  final String appConfig;
  final String appToken; //the token which identifies this user's app

  factory ApiUser.fromLocatorUpdated(
      ApiUser user, String _email, String _photoURL, String _displayName) {
    return ApiUser(
        uid: user.uid,
        email: _email,
        photoURL: _photoURL,
        displayName: _displayName,
        appConfig: user.appConfig,
        appToken: user.appToken);
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
        return ApiUser(
            uid: usr.uid,
            email: usr.email,
            displayName: jsonAppData['data']['name'],
            photoURL: jsonAppData['data']['photoURL'],
            appConfig: appConfig,
            appToken: jsonAppData['data']['token']);
      } else {
        return ApiUser(
            uid: usr.uid,
            email: usr.email,
            displayName: usr.displayName,
            photoURL: usr.photoURL,
            appConfig: appConfig,
            appToken: appToken);
      }
    } else {
      if (_user is ApiUser) {
        return _user;
      }

      final String jsonusr = jsonEncode(_user);
      return ApiUser(
          uid: _user['data']['uid'].toString(),
          email: _user['data']['email'],
          displayName: _user['data']['name'],
          photoURL: _user['data']['photoURL'].toString(),
          appConfig: jsonusr,
          appToken: _user['data']['token']);
    }
  }

  @override
  String toString() =>
      'uid: $uid, email: $email, photoURL: $photoURL, displayName: $displayName, appConfig: $appConfig, appToken: $appToken';

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'photoURL': photoURL,
      'displayName': displayName,
      'appConfig': appConfig,
      'appToken': appToken
    };
  }
}
