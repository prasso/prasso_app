import 'dart:convert';

class TeamMemberModel {
  TeamMemberModel(this.firebaseUid, this.userId);

  String? firebaseUid;
  int? userId;

  factory TeamMemberModel.empty() {
    return TeamMemberModel('', 0);
  }

  factory TeamMemberModel.fromMap(Map<String, dynamic> data) {
    return TeamMemberModel(
      data['uid'] != null ? data['uid'].toString() : '',
      data['id'] != null ? data['id'] as int : 0,
    );
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
    if (json == null || json == 'null' || json == '[]') return [];

    final List<dynamic> alldata = jsonDecode(json) as List<dynamic>;

    final List<TeamMemberModel> teamMemberObjs = [];
    for (final tm in alldata) {
      if (tm is Map<String, dynamic>) {
        if (tm.containsKey('firebaseUid')) {
          teamMemberObjs.add(TeamMemberModel(
            tm['firebaseUid'] != null ? tm['firebaseUid'].toString() : '',
            tm['userId'] != null ? tm['userId'] as int : 0,
          ));
        } else if (tm.containsKey('uid')) {
          teamMemberObjs.add(TeamMemberModel(
            tm['uid'] != null ? tm['uid'].toString() : '',
            tm['id'] != null ? tm['id'] as int : 0,
          ));
        }
      }
    }

    return teamMemberObjs;
  }

  @override
  String toString() => 'uid: $firebaseUid, id: $userId';
}
