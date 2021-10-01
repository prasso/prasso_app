// import 'dart:developer';

// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:prasso_app/app_widgets/account/edit_user_profile_viewmodel.dart';
import 'package:prasso_app/models/role_model.dart';
import 'package:prasso_app/models/team_member_model.dart';

@immutable
class ApiUser {
  const ApiUser(
      {@required this.uid,
      this.email,
      this.photoURL,
      this.displayName,
      this.appConfig,
      this.appToken,
      this.initialized,
      this.roles,
      this.personalTeamId,
      this.teamCoachId,
      this.teamMembers,
      this.pnToken,
      this.appName})
      : assert(uid != null, 'User can only be created with a non-null uid');

  final String uid;
  final String email;
  final String photoURL;
  final String displayName;
  final String appConfig;
  final String appToken; //the token which identifies this user's app
  final bool initialized;
  final List<RoleModel> roles;
  final int personalTeamId;
  final int teamCoachId;
  final List<TeamMemberModel> teamMembers;
  final String pnToken;
  final String appName;

  factory ApiUser.fromLocatorUpdated(
      ApiUser user, EditUserProfileViewModel vm) {
    return ApiUser(
        uid: user.uid,
        email: vm.email,
        photoURL: vm.photoURL,
        displayName: vm.displayName,
        appToken: user.appToken,
        initialized: true,
        roles: vm.roles,
        personalTeamId: vm.personalTeamId,
        teamCoachId: vm.teamCoachId,
        teamMembers: vm.teamMembers,
        pnToken: vm.pnToken,
        appName: vm.appName);
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
              initialized: true,
              roles: RoleModel.convertFromJson(jsonAppData['data']['roles'])
                      .toString() ??
                  RoleModel.defaultRole(),
              personalTeamId: jsonAppData['data']['personal_team_id'],
              teamCoachId: jsonAppData['data']['team_coach_id'],
              teamMembers: TeamMemberModel.convertFromJson(
                          jsonAppData['data']['team_members'])
                      .toString() ??
                  defaultTeamMembers(),
              pnToken: jsonAppData['data']['pn_token'],
              appName: jsonAppData['data']['appName']);
        }
      }
      return ApiUser(
          uid: usr.uid,
          email: usr.email,
          displayName: usr.displayName,
          photoURL: usr.photoURL,
          appConfig: appConfig,
          appToken: appToken,
          initialized: false,
          roles: RoleModel.defaultRole(),
          personalTeamId: 0,
          teamCoachId: 0,
          teamMembers: defaultTeamMembers(),
          pnToken: '',
          appName: '');
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
            initialized: true,
            roles:
                RoleModel.convertFromJson(_user['data']['roles']).toString() ??
                    RoleModel.defaultRole(),
            personalTeamId: _user['data']['personal_team_id'],
            teamCoachId: _user['data']['team_coach_id'],
            teamMembers: TeamMemberModel.convertFromJson(
                    _user['data']['team_members'].toString()) ??
                defaultTeamMembers(),
            pnToken: _user['data']['pn_token'],
            appName: _user['data']['appName']);
      } else {
        return ApiUser(
            uid: jsonResponse['uid'].toString(),
            email: jsonResponse['email'],
            displayName: jsonResponse['displayName'] ?? jsonResponse['name'],
            photoURL: jsonResponse['photoURL'],
            appConfig: jsonResponse['appConfig'] ?? appConfig,
            appToken: jsonResponse['appToken'] ?? appToken,
            initialized: true,
            roles:
                RoleModel.convertFromJson(jsonResponse['roles'].toString()) ??
                    RoleModel.defaultRole(),
            personalTeamId: jsonResponse['personal_team_id'] ?? 0,
            teamCoachId: jsonResponse['team_coach_id'] ?? 0,
            teamMembers: TeamMemberModel.convertFromJson(
                    jsonResponse['team_members'].toString()) ??
                defaultTeamMembers(),
            pnToken: jsonResponse['pn_token'],
            appName: jsonResponse['appName']);
      }
    }
  }

  factory ApiUser.fromStorage(String _user, String appConfig, String appToken) {
    final dynamic userFromStorage = jsonDecode(_user);
    return ApiUser(
        uid: userFromStorage['uid'],
        email: userFromStorage['email'],
        displayName: userFromStorage['displayName'],
        photoURL: userFromStorage['photoURL'],
        appConfig: appConfig,
        appToken: appToken,
        initialized: true,
        roles: RoleModel.convertFromJson(userFromStorage['roles'].toString()) ??
            RoleModel.defaultRole(),
        personalTeamId: userFromStorage['personalTeamId'],
        teamCoachId: userFromStorage['teamCoachId'],
        teamMembers: TeamMemberModel.convertFromJson(
                userFromStorage['teamMembers'].toString()) ??
            defaultTeamMembers(),
        pnToken: userFromStorage['pnToken'],
        appName: userFromStorage['appName']);
  }

  static List<TeamMemberModel> defaultTeamMembers() {
    final List<TeamMemberModel> defaultTeamMembers = [];

    return defaultTeamMembers;
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
      'appToken': appToken?.replaceAll('"', ''),
      'roles': jsonEncode(roles),
      'personalTeamId': personalTeamId,
      'teamCoachId': teamCoachId,
      'teamMembers': jsonEncode(teamMembers),
      'pnToken': jsonEncode(pnToken),
      'appName': jsonEncode(appName)
    };
  }
}
