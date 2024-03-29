import 'dart:convert';

class TeamMemberModel {
  TeamMemberModel(this.firebaseUid, this.userId);

  String? firebaseUid;
  int? userId;

  factory TeamMemberModel.empty() {
    return TeamMemberModel('', 0);
  }

  factory TeamMemberModel.fromMap(Map<String, dynamic> data) {
    return TeamMemberModel(data['uid'].toInt(), data['id'].toInt());
  }

  Map<String, dynamic> toMap() {
    return {'uid': firebaseUid, 'id': userId};
  }

  Map<String, dynamic> toJson() =>
      {'firebaseUid': firebaseUid, 'userId': userId};

  factory TeamMemberModel.fromJson(String? fuid, int? uid) {
    return TeamMemberModel(fuid, uid);
  }

  static List<TeamMemberModel> convertFromJson(String? json) {
    if (json == null || json == 'null') return [];

    final alldata = List<dynamic>.from(jsonDecode(json));

    final List<TeamMemberModel> roleObjs = [];
    for (final tm in alldata) {
      if (tm['firebaseUid'] != null) {
        roleObjs.add(
            TeamMemberModel.fromJson(tm['firebaseUid'], tm['userId'].toInt()));
      }
      if (tm['uid'] != null) {
        roleObjs.add(TeamMemberModel.fromJson(tm['uid'], tm['id'].toInt()));
      }
    }

    return roleObjs;
  }

  @override
  String toString() => 'uid: $firebaseUid, id: $userId';
}
