import 'dart:convert';

import 'package:meta/meta.dart';

@immutable
class RoleModel {
  const RoleModel({this.modelId, this.userId, this.roleId});

  final int? modelId;
  final int? userId;
  final int? roleId;

  factory RoleModel.empty() {
    return const RoleModel();
  }
  factory RoleModel.fromData(int? modelId, int? userId, int? roleId) {
    return RoleModel(modelId: modelId, userId: userId, roleId: roleId);
  }

  Map<String, dynamic> toJson() =>
      {'modelId': modelId, 'userId': userId, 'roleId': roleId};

  static List<RoleModel> defaultRole() {
    final List<RoleModel> defaultRoles = [];

    return defaultRoles;
  }

factory RoleModel.fromMap(Map<String, dynamic> data, int modelId) {
    return RoleModel(
      modelId: modelId,
      userId: data['user_id'] != null ? data['user_id'] as int : 0,  // Provide a default value or handle null case as needed
      roleId: data['role_id'] != null ? data['role_id'] as int : 0,  // Provide a default value or handle null case as needed
    );
  }
static List<RoleModel> convertFromJson(String? json) {
    if (json == null || json == 'null') return [];

    final List<dynamic> alldata = jsonDecode(json) as List<dynamic>;

    final List<RoleModel> roleObjs = [];
    for (final role in alldata) {
      if (role != null && role is Map<String, dynamic>) {
        int modelId;
        int userId;
        int roleId;

        if (role.containsKey('id')) {
          modelId = role['id'] != null ? role['id'] as int : 0;
          userId = role['user_id'] != null ? role['user_id'] as int : 0;
          roleId = role['role_id'] != null ? role['role_id'] as int : 0;
        } else {
          modelId = role['modelId'] != null ? role['modelId'] as int : 0;
          userId = role['userId'] != null ? role['userId'] as int : 0;
          roleId = role['roleId'] != null ? role['roleId'] as int : 0;
        }

        roleObjs.add(RoleModel.fromData(modelId, userId, roleId));
      }
    }

    return roleObjs;
  }

  Map<String, dynamic> toMap() {
    return {'id': modelId, 'user_id': userId, 'role_id': roleId};
  }

  @override
  String toString() => 'id: $modelId, user_id: $userId, role_id: $roleId';
}
