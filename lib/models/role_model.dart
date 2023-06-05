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
        userId: data['user_id'].toInt(),
        roleId: data['role_id'].toInt());
  }

  static List<RoleModel> convertFromJson(String? json) {
    if (json == null || json == 'null') return [];

    final alldata = List<dynamic>.from(jsonDecode(json));

    final List<RoleModel> roleObjs = [];
    for (final role in alldata) {
      if (role != null && role.containsKey('id') == true) {
        roleObjs.add(
            RoleModel.fromData(role['id'], role['user_id'], role['role_id']));
      } else {
        roleObjs.add(RoleModel.fromData(
            role['modelId'], role['userId'], role['roleId']));
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
