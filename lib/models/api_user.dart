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
      this.appConfig})
      : assert(uid != null, 'User can only be created with a non-null uid');

  final String uid;
  final String email;
  final String photoURL;
  final String displayName;
  final String appConfig;

  factory ApiUser.fromAPIJson(dynamic _user, String appConfig) {
    if (_user == null) {
      return null;
    }
    if (_user is User) {
      final User usr = _user;
      return ApiUser(
          uid: usr.uid,
          email: usr.email,
          displayName: usr.displayName,
          photoURL: usr.photoURL,
          appConfig: appConfig);
    } else {
      final String jsonusr = jsonEncode(_user);
      return ApiUser(
          uid: _user['data']['uid'].toString(),
          email: _user['data']['email'],
          displayName: _user['data']['name'],
          photoURL: _user['data']['photoURL'].toString(),
          appConfig: jsonusr);
    }
  }

  @override
  String toString() =>
      'uid: $uid, email: $email, photoURL: $photoURL, displayName: $displayName, appConfig: $appConfig';

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'photoURL': photoURL,
      'displayName': displayName,
      'appConfig': appConfig
    };
  }
}
