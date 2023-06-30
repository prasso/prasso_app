// import 'dart:developer';

// Dart imports:
import 'dart:convert';

import 'package:delegate_app/app_widgets/account/edit_user_profile_viewmodel.dart';
import 'package:delegate_app/models/role_model.dart';
import 'package:delegate_app/models/team_member_model.dart';
// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

@immutable
class ApiUser {
  const ApiUser(
      {required this.uid,
      this.email,
      this.photoURL,
      this.displayName,
      this.appConfig,
      this.appToken,
      this.thirdPartyToken,
      this.initialized,
      this.roles,
      this.personalTeamId,
      this.teamCoachId,
      this.teamMembers,
      this.pnToken,
      this.coachUid,
      this.unreadmessages});

  final String uid;
  final String? email;
  final String? photoURL;
  final String? displayName;
  final String? appConfig;
  final String? appToken; //the token which identifies this user's app
  final String? thirdPartyToken;
  final bool? initialized;
  final List<RoleModel>? roles;
  final int? personalTeamId;
  final int? teamCoachId;
  final List<TeamMemberModel>? teamMembers;
  final String? pnToken;
  final String? coachUid;
  final bool? unreadmessages;

  factory ApiUser.fromLocatorUpdated(
      ApiUser? user, EditUserProfileViewModel vm) {
    return ApiUser(
        uid: user == null ? '' : user.uid,
        email: vm.email,
        photoURL: vm.photoURL,
        displayName: vm.displayName,
        appToken: user?.appToken,
        thirdPartyToken: user?.thirdPartyToken,
        initialized: true,
        roles: vm.roles,
        personalTeamId: vm.personalTeamId,
        teamCoachId: vm.teamCoachId,
        teamMembers: vm.teamMembers,
        pnToken: vm.pnToken,
        coachUid: vm.coachUid,
        unreadmessages: vm.unreadmessages);
  }

  factory ApiUser.fromAPIJson(
      dynamic _user, String? appConfig, String? appToken) {
    if (_user == null) {
      return ApiUser(
          uid: '',
          email: null,
          photoURL: null,
          displayName: null,
          appConfig: appConfig,
          appToken: appToken,
          thirdPartyToken: null,
          initialized: false,
          roles: null,
          personalTeamId: null,
          teamCoachId: null,
          teamMembers: null,
          pnToken: null,
          coachUid: null,
          unreadmessages: null);
    }

    if (_user is User) {
      final User usr = _user;

      if (!(appConfig?.isEmpty ?? true)) {
        final dynamic jsonAppData = jsonDecode(appConfig!);
        if (jsonAppData != null && jsonAppData.containsKey('data') == true) {
          return ApiUser(
              uid: usr.uid,
              email: usr.email,
              displayName: jsonAppData['data']['name'],
              photoURL: jsonAppData['data']['photoURL'],
              appConfig: appConfig,
              appToken: jsonAppData['data']['token'],
              thirdPartyToken: jsonAppData['data']['your_health_token'] ?? '',
              initialized: true,
              roles: jsonAppData['data']['roles'] == null
                  ? RoleModel.defaultRole()
                  : List<RoleModel>.from(
                      RoleModel.convertFromJson(jsonAppData['data']['roles'])),
              personalTeamId: jsonAppData['data']['personal_team_id'],
              teamCoachId: jsonAppData['data']['team_coach_id'],
              teamMembers: jsonAppData['data']['team_members'] == null
                  ? defaultTeamMembers()
                  : List<TeamMemberModel>.from(TeamMemberModel.convertFromJson(
                      jsonAppData['data']['team_members'])),
              pnToken: jsonAppData['data']['pn_token'],
              coachUid: jsonAppData['data']['coach_uid'],
              unreadmessages: jsonAppData['data']['unreadmessages']);
        }
      }
      return ApiUser(
          uid: usr.uid,
          email: usr.email,
          displayName: usr.displayName,
          photoURL: usr.photoURL,
          appConfig: appConfig,
          appToken: appToken,
          thirdPartyToken: '',
          initialized: false,
          roles: RoleModel.defaultRole(),
          personalTeamId: 0,
          teamCoachId: 0,
          teamMembers: defaultTeamMembers(),
          pnToken: '',
          coachUid: '',
          unreadmessages: false);
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
            thirdPartyToken: _user['data']['your_health_token'] ?? '',
            initialized: true,
            roles: _user['data']['roles'] == null
                ? RoleModel.defaultRole()
                : List<RoleModel>.from(
                    RoleModel.convertFromJson(_user['data']['roles'])),
            personalTeamId: _user['data']['personal_team_id'],
            teamCoachId: _user['data']['team_coach_id'],
            teamMembers: TeamMemberModel.convertFromJson(
                _user['data']['team_members']?.toString()),
            pnToken: _user['data']['pn_token'],
            coachUid: _user['data']['coach_uid'],
            unreadmessages: _user['data']['unreadmessages'] ?? false);
      } else {
        return ApiUser(
            uid: jsonResponse['uid'].toString(),
            email: jsonResponse['email'],
            displayName: jsonResponse['displayName'] ?? jsonResponse['name'],
            photoURL: jsonResponse['photoURL'],
            appConfig: jsonResponse['appConfig'] ?? appConfig,
            appToken: jsonResponse['appToken'] ?? appToken,
            thirdPartyToken: jsonResponse['thirdPartyToken'] ?? '',
            initialized: true,
            roles: RoleModel.convertFromJson(jsonResponse['roles']),
            personalTeamId: jsonResponse['personal_team_id'] ?? 0,
            teamCoachId: jsonResponse['team_coach_id'] ?? 0,
            teamMembers: TeamMemberModel.convertFromJson(
                jsonResponse['team_members'].toString()),
            pnToken: jsonResponse['pn_token'],
            coachUid: jsonResponse['coach_uid'] ?? '',
            unreadmessages: jsonResponse['unreadmessages'] ?? false);
      }
    }
  }

  factory ApiUser.fromStorage(
      String _user, String? appConfig, String? appToken) {
    final dynamic userFromStorage = jsonDecode(_user);
    return ApiUser(
        uid: userFromStorage['uid'],
        email: userFromStorage['email'],
        displayName: userFromStorage['displayName'],
        photoURL: userFromStorage['photoURL'],
        appConfig: appConfig,
        appToken: appToken,
        thirdPartyToken: userFromStorage['thirdPartyToken'],
        initialized: true,
        roles: RoleModel.convertFromJson(userFromStorage['roles'].toString()),
        personalTeamId: userFromStorage['personalTeamId'],
        teamCoachId: userFromStorage['teamCoachId'],
        teamMembers: TeamMemberModel.convertFromJson(
            userFromStorage['teamMembers'].toString()),
        pnToken: userFromStorage['pnToken'],
        coachUid: userFromStorage['coachUid'],
        unreadmessages: userFromStorage['unreadmessages'] ?? false);
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
      'thirdPartyToken': thirdPartyToken,
      'roles': jsonEncode(roles),
      'personalTeamId': personalTeamId,
      'teamCoachId': teamCoachId,
      'teamMembers': jsonEncode(teamMembers),
      'pnToken': jsonEncode(pnToken),
      'coachUid': coachUid,
      'unreadmessages': unreadmessages
    };
  }
}
