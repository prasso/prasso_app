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
  static const String kUidKey = 'uid';
  static const String kEmailKey = 'email';
  static const String kPhotoURLKey = 'photoURL';
  static const String kDisplayNameKey = 'displayName';
  static const String kAppConfigKey = 'appConfig';
  static const String kAppTokenKey = 'appToken';
  static const String kThirdPartyTokenKey = 'thirdPartyToken';
  static const String kInitializedKey = 'initialized';
  static const String kRolesKey = 'roles';
  static const String kPersonalTeamIdKey = 'personal_team_id';
  static const String kTeamCoachIdKey = 'team_coach_id';
  static const String kTeamMembersKey = 'team_members';
  static const String kPnTokenKey = 'pn_token';
  static const String kCoachUidKey = 'coach_uid';
  static const String kUnreadMessagesKey = 'unreadmessages';
  static const String kNameKey = 'name';
  static const String kDataKey = 'data';
  static const String kTokenKey = 'token';
  static const String kYourHealthTokenKey = 'your_health_token';
  static const String kEmptyString = '';
  static const String kQuote = '"';

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

  ApiUser._fromParsedJson(Map<String, dynamic> data, this.appConfig, this.appToken)
      : uid = data[kUidKey].toString(),
        email = data[kEmailKey] as String?,
        displayName = data[kNameKey] as String?,
        photoURL = data[kPhotoURLKey] as String?,
        thirdPartyToken = data[kYourHealthTokenKey] as String? ?? kEmptyString,
        initialized = true,
        roles = data[kRolesKey] == null
            ? RoleModel.defaultRole()
            : RoleModel.convertFromJson(data[kRolesKey] as String?),
        personalTeamId = data[kPersonalTeamIdKey] as int?,
        teamCoachId = data[kTeamCoachIdKey] as int?,
        teamMembers = data[kTeamMembersKey] == null
            ? defaultTeamMembers()
            : _teamMembersFromJson(data[kTeamMembersKey]),
        pnToken = data[kPnTokenKey] as String?,
        coachUid = data[kCoachUidKey] as String?,
        unreadmessages = data[kUnreadMessagesKey] as bool? ?? false;


  factory ApiUser.fromLocatorUpdated(ApiUser? user, EditUserProfileViewModel vm) {
    return ApiUser(
        uid: user == null ? kEmptyString : user.uid,
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

  factory ApiUser.fromStorage(String _user, String? appConfig, String? appToken) {
    final Map<String, dynamic> userFromStorage = jsonDecode(_user) as Map<String, dynamic>;
    return ApiUser._fromParsedJson(userFromStorage, appConfig, appToken);
  }

  factory ApiUser.fromJsonResponse(String _user, String? appConfig, String? appToken) {
    final  jsonResponse = jsonDecode(_user );
    if (jsonResponse[kDataKey] != null) {
      final Map<String, dynamic> data = jsonResponse[kDataKey] as Map<String, dynamic>;
      return ApiUser._fromParsedJson(data, appConfig, appToken);
    } else {
      return ApiUser._fromParsedJson(jsonResponse as Map<String, dynamic>, appConfig, appToken);
    }
  }

 factory ApiUser.fromAPI(dynamic _user, String? appConfig, String? appToken) {
    if (_user == null) {
      return ApiUser(
        uid: kEmptyString,
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
        unreadmessages: null,
      );
    }

    if (_user is User) {
      final User usr = _user;

      if (!(appConfig?.isEmpty ?? true)) {
        final dynamic jsonAppData = jsonDecode(appConfig!);
        if (jsonAppData != null && jsonAppData.containsKey(kDataKey) == true) {
          return ApiUser._fromParsedJson(
            {
              kUidKey: usr.uid,
              kEmailKey: usr.email,
              kNameKey: jsonAppData[kDataKey][kNameKey] as String?,
              kPhotoURLKey: jsonAppData[kDataKey][kPhotoURLKey] as String?,
              kTokenKey: jsonAppData[kDataKey][kTokenKey] as String?,
              kYourHealthTokenKey: jsonAppData[kDataKey][kYourHealthTokenKey] as String? ?? kEmptyString,
              kRolesKey: jsonAppData[kDataKey][kRolesKey] as String?,
              kPersonalTeamIdKey: jsonAppData[kDataKey][kPersonalTeamIdKey] as int?,
              kTeamCoachIdKey: jsonAppData[kDataKey][kTeamCoachIdKey] as int?,
              kTeamMembersKey: jsonAppData[kDataKey][kTeamMembersKey] as String?,
              kPnTokenKey: jsonAppData[kDataKey][kPnTokenKey] as String?,
              kCoachUidKey: jsonAppData[kDataKey][kCoachUidKey] as String?,
              kUnreadMessagesKey: jsonAppData[kDataKey][kUnreadMessagesKey] as bool?,
            },
            appConfig,
            appToken,
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
        thirdPartyToken: kEmptyString,
        initialized: false,
        roles: RoleModel.defaultRole(),
        personalTeamId: 0,
        teamCoachId: 0,
        teamMembers: defaultTeamMembers(),
        pnToken: kEmptyString,
        coachUid: kEmptyString,
        unreadmessages: false,
      );
    } else if (_user is ApiUser) {
      return _user;
    } else {
      throw ArgumentError('Invalid user type');
    }
  }


  static List<TeamMemberModel> defaultTeamMembers() {
    final List<TeamMemberModel> defaultTeamMembers = [];

    return defaultTeamMembers;
  }


  static List<TeamMemberModel> _teamMembersFromJson(dynamic jsonTeamMembers){

    if  (jsonTeamMembers is String){
        return TeamMemberModel.convertFromJson(jsonTeamMembers);
    }
    else{
      if (jsonTeamMembers is List<dynamic>){
      final List<TeamMemberModel> teamMembers = jsonTeamMembers
              .map((member) => TeamMemberModel.fromMap(member as Map<String, dynamic>))
              .toList();

      print(teamMembers); // Output: []
      return teamMembers;
      }
    }
    return defaultTeamMembers();
  }

  @override
  String toString() {
    return jsonEncode(toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      kUidKey: uid,
      kEmailKey: email,
      kPhotoURLKey: photoURL,
      kDisplayNameKey: displayName,
      kAppConfigKey: appConfig,
      kAppTokenKey: appToken?.replaceAll(kQuote, kEmptyString),
      kThirdPartyTokenKey: thirdPartyToken,
      kRolesKey: jsonEncode(roles),
      kPersonalTeamIdKey: personalTeamId,
      kTeamCoachIdKey: teamCoachId,
      kTeamMembersKey: jsonEncode(teamMembers),
      kPnTokenKey: jsonEncode(pnToken),
      kCoachUidKey: coachUid,
      kUnreadMessagesKey: unreadmessages
    };
  }
}