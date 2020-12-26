import 'dart:async';

import 'package:meta/meta.dart';
import 'package:prasso_app/models/app.dart';
import 'package:prasso_app/models/api_user.dart';
import 'package:prasso_app/services/firebase_auth_service/firestore_service.dart';
import 'package:prasso_app/services/firestore_path.dart';

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase {
  FirestoreDatabase({@required this.uid})
      : assert(uid != null, 'Cannot create FirestoreDatabase with null uid');
  final String uid;

  final _service = FirestoreService.instance;

  Future<void> setApp(AppModel app) => _service.setData(
        path: FirestorePath.app(uid, app.documentId),
        data: app.toMap(),
      );

  Future<void> setUser(ApiUser usr) => _service.setData(
        path: FirestorePath.users(usr.uid),
        data: usr.toMap(),
      );

  Future<void> deleteApp(AppModel app) async {
    // delete app
    await _service.deleteData(path: FirestorePath.apps(app.documentId));
  }

  Stream<AppModel> appStream({@required String appId}) =>
      _service.documentStream(
        path: FirestorePath.app(uid, appId),
        builder: (data, documentId) => AppModel.fromMap(data, documentId),
      );

  Stream<List<AppModel>> appsStream() => _service.collectionStream(
        path: FirestorePath.apps(uid),
        builder: (data, documentId) => AppModel.fromMap(data, documentId),
      );
}
