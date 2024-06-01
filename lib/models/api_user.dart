// import 'dart:developer';

// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:prasso_app/app_widgets/account/edit_user_profile_viewmodel.dart';
import 'package:prasso_app/models/role_model.dart';
import 'package:prasso_app/models/team_member_model.dart';

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

  factory ApiUser.fromLocatorUpdated(ApiUser? user, EditUserProfileViewModel vm) {
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

  factory ApiUser.fromAPIJson(dynamic _user, String? appConfig, String? appToken) {
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
              displayName: jsonAppData['data']['name'] as String?,
              photoURL: jsonAppData['data']['photoURL'] as String?,
              appConfig: appConfig as String?,
              appToken: jsonAppData['data']['token'] as String?,
              thirdPartyToken: jsonAppData['data']['your_health_token'] as String? ?? '',
              initialized: true,
              roles: jsonAppData['data']['roles'] == null
                  ? RoleModel.defaultRole()
                  : RoleModel.convertFromJson(jsonAppData['data']['roles'] as String),
                          
              personalTeamId: jsonAppData['data']['personal_team_id'] as int?,
              teamCoachId: jsonAppData['data']['team_coach_id'] as int?,
              teamMembers: jsonAppData['data']['team_members'] == null
                  ? defaultTeamMembers()
                  : TeamMemberModel.convertFromJson(jsonAppData['data']['team_members'] as String),
              pnToken: jsonAppData['data']['pn_token'] as String?,
              coachUid: jsonAppData['data']['coach_uid'] as String?,
              unreadmessages: jsonAppData['data']['unreadmessages'] as bool?,
            );
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

      final dynamic jsonResponse = jsonDecode(_user as String);
      if (jsonResponse['data'] != null) {
        final Map<String, dynamic> data = jsonResponse['data'] as Map<String, dynamic>;
        return ApiUser(
          uid: data['uid'].toString(),
          email: data['email'] as String?,
          displayName: data['name'] as String?,
          photoURL: data['photoURL'] as String?,
          appConfig: jsonEncode(data),
          appToken: data['token'] as String?,
          thirdPartyToken: data['your_health_token'] as String? ?? '',
          initialized: true,
          roles: data['roles'] == null
              ? RoleModel.defaultRole()
              : RoleModel.convertFromJson(data['roles'] as String?),
          personalTeamId: data['personal_team_id'] as int?,
          teamCoachId: data['team_coach_id'] as int?,
          teamMembers: data['team_members'] == null
              ? defaultTeamMembers()
              : TeamMemberModel.convertFromJson(data['team_members'] as String?),
          pnToken: data['pn_token'] as String?,
          coachUid: data['coach_uid'] as String?,
          unreadmessages: data['unreadmessages'] as bool? ?? false,
        );
      } else {
        return ApiUser(
          uid: jsonResponse['uid'].toString(),
          email: jsonResponse['email'] as String?,
          displayName: jsonResponse['displayName'] as String? ?? jsonResponse['name'] as String?,
          photoURL: jsonResponse['photoURL'] as String?,
          appConfig: jsonResponse['appConfig'] as String?,
          appToken: jsonResponse['appToken'] as String?,
          thirdPartyToken: jsonResponse['thirdPartyToken'] as String? ?? '',
          initialized: true,
          roles: jsonResponse['roles'] == null
              ? RoleModel.defaultRole()
              : RoleModel.convertFromJson(jsonResponse['roles'] as String?),
          personalTeamId: jsonResponse['personal_team_id'] as int? ?? 0,
          teamCoachId: jsonResponse['team_coach_id'] as int? ?? 0,
          teamMembers: jsonResponse['team_members'] == null
              ? defaultTeamMembers()
              : TeamMemberModel.convertFromJson(jsonResponse['team_members'] as String),
          pnToken: jsonResponse['pn_token'] as String?,
          coachUid: jsonResponse['coach_uid'] as String? ?? '',
          unreadmessages: jsonResponse['unreadmessages'] as bool? ?? false,
        );
      }
    }
  }

    factory ApiUser.fromStorage(String _user, String? appConfig, String? appToken) {
    final Map<String, dynamic> userFromStorage = jsonDecode(_user) as Map<String, dynamic>;
    return ApiUser(
      uid: userFromStorage['uid'] as String,
      email: userFromStorage['email'] as String?,
      displayName: userFromStorage['displayName'] as String?,
      photoURL: userFromStorage['photoURL'] as String?,
      appConfig: appConfig,
      appToken: appToken,
      thirdPartyToken: userFromStorage['thirdPartyToken'] as String?,
      initialized: true,
      roles: userFromStorage['roles'] == null
          ? RoleModel.defaultRole()
          : RoleModel.convertFromJson(userFromStorage['roles'] as String),
      personalTeamId: userFromStorage['personalTeamId'] as int?,
      teamCoachId: userFromStorage['teamCoachId'] as int?,
      teamMembers: userFromStorage['teamMembers'] == null
          ? []
          : TeamMemberModel.convertFromJson(userFromStorage['teamMembers'] as String),
    pnToken: userFromStorage['pnToken'] as String?,
      coachUid: userFromStorage['coachUid'] as String?,
      unreadmessages: userFromStorage['unreadmessages'] as bool? ?? false,
    );
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
